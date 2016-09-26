unit HttpApiServer;

interface

uses
  Windows, Classes, SysUtils, WinSock2, win.httpsys;
  
type      
  THttpSocketCompress = function(var Data: RawByteString; Compress: boolean): RawByteString;
                     
  /// event handler used by THttpServerGeneric.OnRequest property
  // - InURL/InMethod/InHeaders/InContent properties are input parameters
  // - OutContent/OutContentType/OutCustomHeader are output parameters
  // - result of the function is the HTTP error code (200 if OK, e.g.)
  // - OutCustomHeader will handle Content-Type/Location
  // - if OutContentType is HTTP_RESP_STATICFILE (i.e. '!STATICFILE'),
  // then OutContent is the UTF-8 file name of a file which must be sent to the
  // client via http.sys (much faster than manual buffering/sending)
  TOnHttpServerRequest = function(
      const InURL, InMethod, InHeaders, InContent, InContentType: RawByteString;
      out OutContent, OutContentType, OutCustomHeader: RawByteString): cardinal of object;
                         
  /// used to maintain a list of known compression algorithms
  THttpSocketCompressRec = record
    /// the compression name, as in ACCEPT-ENCODING: header (gzip,deflate,synlz)
    Name: AnsiString;
    /// the function handling compression and decompression
    Func: THttpSocketCompress;
  end;

  THttpSocketCompressRecDynArray = array of THttpSocketCompressRec;
                           
  /// event prototype used e.g. by THttpServerGeneric.OnHttpThreadStart
  TNotifyThreadEvent = procedure(Sender: TThread) of object;

  THttpApiServer = class(TThread)//THttpServerGeneric)
  protected                        
    /// optional event handler for the virtual Request method
    fOnRequest: TOnHttpServerRequest;
    /// list of all registered compression algorithms
    fCompress: THttpSocketCompressRecDynArray;
    /// set by RegisterCompress method
    fCompressAcceptEncoding: RawByteString;
    fOnHttpThreadStart: TNotifyThreadEvent;
    
    /// the internal request queue
		fReqQueue: THandle;
    fLibHttpSys: TLibHttpSys;
    /// contain clones list
    //fClones: TObjectList;
    /// list of all registered URL (Unicode-encoded)
    fRegisteredUrl: array of RawByteString;
    /// server main loop - don't change directly
    // - will call the Request public virtual method with the appropriate
    // parameters to retrive the content
    procedure Execute; override;
    /// create a clone
    constructor CreateClone(From: THttpApiServer);
  public
    /// initialize the HTTP Service
    // - will raise an exception if http.sys is not available (e.g. before
    // Windows XP SP2) or if the request queue creation failed
    // - if you override this contructor, put the AddUrl() methods within,
    // and you can set CreateSuspended to TRUE
    // - if you will call AddUrl() methods later, set CreateSuspended to FALSE,
    // then call explicitely the Resume method, after all AddUrl() calls, in
    // order to start the server
    constructor Create(CreateSuspended: Boolean);
    /// release all associated memory and handles
    destructor Destroy; override;
    /// will clone this thread into multiple other threads
    // - could speed up the process on multi-core CPU
    // - will work only if the OnProcess property was set (this is the case
    // e.g. in TSQLite3HttpServer.Create() constructor)
    // - maximum value is 256 - higher should not be worth it
    procedure Clone(ChildThreadCount: integer);
    /// register the URLs to Listen On
    // - e.g. AddUrl('root','888')
    // - aDomainName could be either a fully qualified case-insensitive domain
    // name, an IPv4 or IPv6 literal string, or a wildcard ('+' will bound
    // to all domain names for the specified port, '*' will accept the request
    // when no other listening hostnames match the request for that port)
    // - return 0 (NO_ERROR) on success, an error code if failed: under Vista
    // and Seven, you could have ERROR_ACCESS_DENIED if the process is not
    // running with enough rights (by default, UAC requires administrator rights
    // for adding an URL to http.sys registration list) - solution is to call
    // the THttpApiServer.AddUrlAuthorize class method during program setup 
    // - if this method is not used within an overriden constructor, default
    // Create must have be called with CreateSuspended = TRUE and then call the
    // Resume method after all Url have been added
    function AddUrl(const aRoot, aPort: RawByteString; Https: boolean=false;
      const aDomainName: RawByteString='*'): integer;
    /// will authorize a specified URL prefix
    // - will allow to call AddUrl() later for any user on the computer
    // - if aRoot is left '', it will authorize any root for this port
    // - must be called with Administrator rights: this class function is to be
    // used in a Setup program for instance, especially under Vista or Seven,
    // to reserve the Url for the server
    // - add a new record to the http.sys URL reservation store
    // - return '' on success, an error message otherwise
    // - will first delete any matching rule for this URL prefix
    // - if OnlyDelete is true, will delete but won't add the new authorization;
    // in this case, any error message at deletion will be returned 
    class function AddUrlAuthorize(const aRoot, aPort: RawByteString; Https: boolean=false;
      const aDomainName: RawByteString='*'; OnlyDelete: boolean=false): string;
    /// will register a compression algorithm
    // - overriden method which will handle any cloned instances
    procedure RegisterCompress(aFunction: THttpSocketCompress); //override;
  end;

implementation
                      
constructor THttpApiServer.Create(CreateSuspended: Boolean);
var Error: HRESULT;
begin
  inherited Create(true);
  HttpApiInitialize(@fLibHttpSys); // will raise an exception in case of failure
  Error := fLibHttpSys.Initialize(HTTPAPI_VERSION_1, HTTP_INITIALIZE_SERVER);
  if NO_ERROR <> Error then
  begin
    //raise EHttpApiServer.Create(0,Error);
  end;
  Error := fLibHttpSys.CreateHttpHandle(fReqQueue);
  if NO_ERROR <> Error then
  begin
    //raise EHttpApiServer.Create(2,Error);
  end;
  //fClones := TObjectList.Create;
  if not CreateSuspended then
    Suspended := False;
end;

constructor THttpApiServer.CreateClone(From: THttpApiServer);
begin
  inherited Create(false);
  fReqQueue := From.fReqQueue;
  //fOnRequest := From.OnRequest;
  //fCompress := From.fCompress;
  //OnHttpThreadTerminate := From.OnHttpThreadTerminate;
  //fCompressAcceptEncoding := From.fCompressAcceptEncoding;
end;

destructor THttpApiServer.Destroy;
var
  i: Integer;
begin
  (*//
  if nil <> fClones then
  begin  // fClones=nil for clone threads
    if 0 <> fReqQueue then
    begin
      for i := 0 to high(fRegisteredUrl) do
      begin
        fLibHttpSys.RemoveUrl(fReqQueue,Pointer(fRegisteredUrl[i]));
      end;
      CloseHandle(fReqQueue); // will break all THttpApiServer.Execute
      fLibHttpSys.Terminate(HTTP_INITIALIZE_SERVER);
    end;
    fClones.Free;
  end;
  //*)
  inherited Destroy;
end;
                   
function RetrieveHeaders(const Head: HTTP_REQUEST_HEADERS;
  const Address: PSOCKADDR): RawByteString;  
const
  KNOWNHEADERS_NAME: array[reqCacheControl..reqUserAgent] of string[19] = (
    'Cache-Control','Connection','Date','Keep-Alive','Pragma','Trailer',
    'Transfer-Encoding','Upgrade','Via','Warning','Allow','Content-Length',
    'Content-Type','Content-Encoding','Content-Language','Content-Location',
    'Content-MD5','Content-Range','Expires','Last-Modified','Accept',
    'Accept-Charset','Accept-Encoding','Accept-Language','Authorization',
    'Cookie','Expect','From','Host','If-Match','If-Modified-Since',
    'If-None-Match','If-Range','If-Unmodified-Since','Max-Forwards',
    'Proxy-Authorization','Referer','Range','TE','Translate','User-Agent');

var i, L: integer;
    H: THttpHeader;
    P: PHTTP_UNKNOWN_HEADER;
    D: PAnsiChar;
    IP: RawByteString;
begin
  assert(low(KNOWNHEADERS_NAME)=low(Head.KnownHeaders));
  assert(high(KNOWNHEADERS_NAME)=high(Head.KnownHeaders));
  // compute headers length
  L := 0;
  for H := low(KNOWNHEADERS_NAME) to high(KNOWNHEADERS_NAME) do
    if Head.KnownHeaders[H].RawValueLength<>0 then
      inc(L,Head.KnownHeaders[H].RawValueLength+ord(KNOWNHEADERS_NAME[H][0])+4);
  P := Head.pUnknownHeaders;
  if P<>nil then
    for i := 1 to Head.UnknownHeaderCount do begin
      inc(L,P^.NameLength+P^.RawValueLength+4); // +4 for each ': '+#13#10
      inc(P);
    end;
  // set headers content
  SetString(result,nil,L);
  D := pointer(result);
  for H := low(Head.KnownHeaders) to high(Head.KnownHeaders) do
    if Head.KnownHeaders[H].RawValueLength<>0 then begin
      move(KNOWNHEADERS_NAME[H][1],D^,ord(KNOWNHEADERS_NAME[H][0]));
      inc(D,ord(KNOWNHEADERS_NAME[H][0]));
      PWord(D)^ := ord(':')+ord(' ')shl 8;
      inc(D,2);
      move(Head.KnownHeaders[H].pRawValue^,D^,Head.KnownHeaders[H].RawValueLength);
      inc(D,Head.KnownHeaders[H].RawValueLength);
      PWord(D)^ := 13+10 shl 8;
      inc(D,2);
    end;
  P := Head.pUnknownHeaders;
  if nil <> P then
  begin
    for i := 1 to Head.UnknownHeaderCount do
    begin
      move(P^.pName,D^,P^.NameLength);
      inc(D,P^.NameLength);
      PWord(D)^ := ord(':')+ord(' ')shl 8;
      inc(D,2);
      move(P^.pRawValue,D^,P^.RawValueLength);
      inc(D,P^.RawValueLength);
      inc(P);
      PWord(D)^ := 13+10 shl 8;
      inc(D,2);
    end;
  end;
  assert(D-pointer(result)=L);
  if Address<>nil then
  begin
    //IP := GetSinIP(PVarSin(Address)^);
    if '' <> IP then
      result := result+'RemoteIP: '+IP+#13#10;
  end;
end;
               
function GetCardinal(P: PAnsiChar): cardinal; overload;
var c: cardinal;
begin
  if nil = P then
  begin
    result := 0;
    exit;
  end;
  if P^=' ' then
    repeat
      inc(P)
    until P^<>' ';
  c := byte(P^)-48;
  if 9 < c then
    result := 0
  else
  begin
    result := c;
    inc(P);
    repeat
      c := byte(P^)-48;
      if c>9 then
        break
      else
        result := result*10+c;
      inc(P);
    until false;
  end;
end;
         
function GetCardinal(P,PEnd: PAnsiChar): cardinal; overload;
var
  c: cardinal;
begin
  result := 0;
  if (P=nil) or (P>=PEnd) then
    exit;
  if P^=' ' then
  repeat
    inc(P);
    if P=PEnd then
      exit;
  until P^<>' ';
  c := byte(P^)-48;
  if 9 < c then
    exit;
  result := c;
  inc(P);
  while P < PEnd do
  begin
    c := byte(P^)-48;
    if c>9 then
      break
    else
      result := result*10+c;
    inc(P);
  end;
end;
                     
procedure THttpApiServer.Execute;
type
  THttpSocketCompressSet = set of 0..31; 
  /// FPC 64 compatibility integer type
  PtrInt = integer;
  /// FPC 64 compatibility pointer type
  PPtrInt = ^PtrInt;   
  {$ifdef UNICODE}
  PtrUInt = NativeUInt;
  {$else}
  PtrUInt = Cardinal;
  {$endif}
  PPtrUInt = ^PtrUInt;
                             
const
  // below this size (in bytes), no compression will be done (not worth it)
  COMPRESS_MIN_SIZE = 1024;
            
function GetNextItemUInt64(var P: PAnsiChar): Int64;
var c: PtrUInt;
begin
  if P=nil then begin
    result := 0;
    exit;
  end;
  result := byte(P^)-48;  // caller ensured that P^ in ['0'..'9']
  inc(P);
  repeat
    c := byte(P^)-48;
    if c>9 then
      break else
      result := result*10+c;
    inc(P);
  until false;
end; // P^ will point to the first non digit char

/// decode 'CONTENT-ENCODING: ' parameter from registered compression list
function SetCompressHeader(const Compress: THttpSocketCompressRecDynArray;
  P: PAnsiChar): THttpSocketCompressSet;
var i: integer;
    aName: AnsiString;
    Beg: PAnsiChar;
begin
  integer(result) := 0;
  if P<>nil then
    repeat
      while P^ in [' ',','] do inc(P);
      Beg := P; // 'gzip;q=1.0, deflate' -> aName='gzip' then 'deflate'
      while not (P^ in [';',',',#0]) do inc(P);
      SetString(aName,Beg,P-Beg);
      for i := 0 to high(Compress) do
        if aName=Compress[i].Name then
          include(result,i);
      while not (P^ in [',',#0]) do inc(P);
    until P^=#0;
end;
         
function CompressDataAndGetHeaders(Accepted: THttpSocketCompressSet;
  var Handled: THttpSocketCompressRecDynArray; const OutContentType: RawByteString;
  var OutContent: RawByteString): RawByteString;
var i: integer;
    OutContentTypeP: PAnsiChar absolute OutContentType;
begin
  if (integer(Accepted)<>0) and (OutContentType<>'') and (Handled<>nil) and
     (length(OutContent)>=COMPRESS_MIN_SIZE) and
     (IdemPChar(OutContentTypeP,'TEXT/') or
      ((IdemPChar(OutContentTypeP,'APPLICATION/') and
                (IdemPChar(OutContentTypeP+12,'JSON') or
                 IdemPChar(OutContentTypeP+12,'XML'))))) then
    for i := 0 to high(Handled) do
    if i in Accepted then begin
      // compression of the OutContent + update header
      result := Handled[i].Func(OutContent,true);
      exit; // first in fCompress[] is prefered
    end;
  result := '';
end;

const
  VERB_TEXT: array[hvOPTIONS..hvSEARCH] of RawByteString = (
    'OPTIONS', 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE',
    'CONNECT', 'TRACK', 'MOVE', 'COPY', 'PROPFIND', 'PROPPATCH',
    'MKCOL', 'LOCK', 'UNLOCK', 'SEARCH');

  /// used by THttpApiServer.Request for http.sys to send a static file
  // - the OutCustomHeader should contain the proper 'Content-type: ....'
  // corresponding to the file
  HTTP_RESP_STATICFILE = '!STATICFILE';

var Req: PHTTP_REQUEST;
    ReqID: HTTP_REQUEST_ID;
    ReqBuf, RespBuf: RawByteString;
    i: integer;
    flags, bytesRead, bytesSent: cardinal;
    Err: HRESULT;
    InCompressAccept: THttpSocketCompressSet;
    InContentLength, InContentLengthRead: cardinal;
    InContentEncoding, InAcceptEncoding, Range: RawByteString;
    OutContentEncoding: RawByteString;
    InURL, InMethod, InHeaders, InContent, InContentType: RawByteString;
    OutContent, OutContentType, OutCustomHeader, OutStatus: RawByteString;
    OutContentTypeP: PAnsiChar absolute OutContentType;
    FileHandle: THandle;
    Resp: PHTTP_RESPONSE;
    BufRead, R: PAnsiChar;
    Heads: array of HTTP_UNKNOWN_HEADER;
    RangeStart, RangeLength: Int64;
    DataChunk: HTTP_DATA_CHUNK;

  procedure SendError(StatusCode: cardinal; const ErrorMsg: string);
  begin
    Resp^.SetStatus(StatusCode,OutStatus,@DataChunk,RawByteString(ErrorMsg));
    fLibHttpSys.SendHttpResponse(fReqQueue,Req^.RequestId,0,Resp^,nil,bytesSent);
  end;

begin
  // THttpServerGeneric thread preparation: launch any OnHttpThreadStart event
  inherited Execute;
  // reserve working buffers
  SetLength(Heads,64);
  SetLength(RespBuf,sizeof(Resp^));
  Resp := pointer(RespBuf);
  SetLength(ReqBuf,16384+sizeof(HTTP_REQUEST)); // space for Req^ + 16 KB of headers
  Req := pointer(ReqBuf);
  // main loop
  ReqID := 0;
  repeat
    // read header
    fillchar(Req^,sizeof(HTTP_REQUEST),0);
    Err := fLibHttpSys.ReceiveHttpRequest(fReqQueue,ReqID,0,Req^,length(ReqBuf),bytesRead);
    if Terminated then
      break;
    case Err of
      NO_ERROR:
      try
        // parse header
        InURL := Req^.pRawUrl;
        if Req^.Verb in [low(VERB_TEXT)..high(VERB_TEXT)] then
          InMethod := VERB_TEXT[Req^.Verb] else
          SetString(InMethod,Req^.pUnknownVerb,Req^.UnknownVerbLength);
        with Req^.Headers.KnownHeaders[reqContentType] do
          SetString(InContentType,pRawValue,RawValueLength);
        with Req^.Headers.KnownHeaders[reqAcceptEncoding] do
          SetString(InAcceptEncoding,pRawValue,RawValueLength);
        InCompressAccept := SetCompressHeader(fCompress,pointer(InAcceptEncoding));
        InHeaders := RetrieveHeaders(Req^.Headers,Req^.Address.pRemoteAddress);
        {$ifdef DEBUGAPI}writeln(InMethod,' ',InURL,#13#10,InHeaders);{$endif}
        // retrieve body
        InContent := '';
        if HTTP_REQUEST_FLAG_MORE_ENTITY_BODY_EXISTS and Req^.Flags<>0 then
        begin
          with Req^.Headers.KnownHeaders[reqContentLength] do
          begin
            InContentLength := GetCardinal(pRawValue, pRawValue + RawValueLength);
          end;
          if InContentLength<>0 then
          begin
            SetLength(InContent,InContentLength);
            BufRead := pointer(InContent);
            InContentLengthRead := 0;
            repeat
              BytesRead := 0;
              if Win32MajorVersion>5 then // speed optimization for Vista+
                flags := HTTP_RECEIVE_REQUEST_ENTITY_BODY_FLAG_FILL_BUFFER else
                flags := 0;
              Err := fLibHttpSys.ReceiveRequestEntityBody(fReqQueue,Req^.RequestId,flags,
                BufRead,InContentLength-InContentLengthRead,BytesRead);
              inc(InContentLengthRead,BytesRead);
              if Err=ERROR_HANDLE_EOF then
              begin
                if InContentLengthRead<InContentLength then
                  SetLength(InContent,InContentLengthRead);
                Err := NO_ERROR;
                break; // should loop until returns ERROR_HANDLE_EOF
              end;
              if Err<>NO_ERROR then
                break;
              inc(BufRead,BytesRead);
            until InContentLengthRead=InContentLength;
            if Err<>NO_ERROR then
            begin
              SendError(406,SysErrorMessage(Err));
              continue;
            end;
            with Req^.Headers.KnownHeaders[reqContentEncoding] do
            begin
              SetString(InContentEncoding,pRawValue,RawValueLength);
            end;
            if InContentEncoding<>'' then
            begin
              for i := 0 to high(fCompress) do
              begin
                if fCompress[i].Name=InContentEncoding then
                begin
                  fCompress[i].Func(InContent,false); // uncompress
                  break;
                end;
              end;
            end;
          end;
        end;
        try
          // compute response
          fillchar(Resp^,sizeof(Resp^),0);
          //Resp^.SetStatus(Request(InURL,InMethod,InHeaders,InContent,InContentType,
          //  OutContent,OutContentType,OutCustomHeader),OutStatus);
          if Terminated then
            exit;
          // send response
          Resp^.Version := Req^.Version;
          if fCompressAcceptEncoding<>'' then
            OutCustomHeader := OutCustomHeader+#13#10+fCompressAcceptEncoding;
          Resp^.SetHeaders(pointer(OutCustomHeader),pointer(Heads),high(Heads));
          if OutContentType=HTTP_RESP_STATICFILE then
          begin
            // response is file -> let http.sys serve it (OutContent is UTF-8)
            FileHandle := FileOpen(
              {$ifdef UNICODE}UTF8ToUnicodeString{$else}Utf8ToAnsi{$endif}(OutContent),
              fmOpenRead or fmShareDenyNone);
            if PtrInt(FileHandle)<0 then
              SendError(404,SysErrorMessage(GetLastError)) else
            try
              DataChunk.DataChunkType := hctFromFileHandle;
              DataChunk.FromFileHandle.FileHandle := FileHandle;
              flags := 0;
              DataChunk.FromFileHandle.ByteRange.StartingOffset.QuadPart := 0;
              Int64(DataChunk.FromFileHandle.ByteRange.Length.QuadPart) := -1; // to eof
              with Req^.Headers.KnownHeaders[reqRange] do
                if (RawValueLength>6) and IdemPChar(pRawValue,'BYTES=') and
                   (pRawValue[6] in ['0'..'9']) then begin
                  SetString(Range,pRawValue+6,RawValueLength-6); // need #0 end
                  R := pointer(Range);
                  RangeStart := GetNextItemUInt64(R);
                  if R^='-' then begin
                    inc(R);
                    flags := HTTP_SEND_RESPONSE_FLAG_PROCESS_RANGES;
                    DataChunk.FromFileHandle.ByteRange.StartingOffset := ULARGE_INTEGER(RangeStart);
                    if R^ in ['0'..'9'] then begin
                      RangeLength := GetNextItemUInt64(R)-RangeStart+1;
                      if RangeLength>=0 then // "bytes=0-499" -> start=0, len=500
                        DataChunk.FromFileHandle.ByteRange.Length := ULARGE_INTEGER(RangeLength);
                    end; // "bytes=1000-" -> start=1000, len=-1 (to eof)
                  end;
                end;
              Resp^.EntityChunkCount := 1;
              Resp^.pEntityChunks := @DataChunk;
              fLibHttpSys.SendHttpResponse(fReqQueue,Req^.RequestId,flags,Resp^,nil,bytesSent);
            finally
              FileClose(FileHandle);
            end;
          end else begin
            // response is in OutContent -> sent it
            if integer(fCompress)<>0 then
            with Resp^.Headers.KnownHeaders[reqContentEncoding] do
            if RawValueLength=0 then
            begin
              // no previous encoding -> try if any compression
              OutContentEncoding := CompressDataAndGetHeaders(InCompressAccept,
                fCompress,OutContentType,OutContent);
              pRawValue := pointer(OutContentEncoding);
              RawValueLength := length(OutContentEncoding);
            end;
            Resp^.SetContent(DataChunk,OutContent,OutContentType);
            fLibHttpSys.SendHttpResponse(fReqQueue,Req^.RequestId,0,Resp^,nil,bytesSent);
          end;
        except
          on E: Exception do
            // handle any exception raised during process: show must go on!
            SendError(500,E.Message); 
        end;
      finally    
        ReqId := 0; // reset Request ID to handle the next request
      end;
      ERROR_MORE_DATA: begin
        // The input buffer was too small to hold the request headers
        // Increase the buffer size and call the API again
        ReqID := Req^.RequestId;
        SetLength(ReqBuf,bytesRead);
        Req := pointer(ReqBuf);
      end;
      ERROR_CONNECTION_INVALID:
        if ReqID=0 then
          break else
          // TCP connection was corrupted by the peer -> ignore + next request
          ReqID := 0;
      else break;
    end;
  until Terminated;
end;

procedure THttpApiServer.RegisterCompress(aFunction: THttpSocketCompress);
var
  i: integer;
begin
  inherited;
//  if fClones<>nil then
//  begin
//    for i := 0 to fClones.Count-1 do
//    begin
//      THttpApiServer(fClones.List{$ifdef FPC}^{$endif}[i]).RegisterCompress(aFunction);
//    end;
//  end;
end;
  
procedure THttpApiServer.Clone(ChildThreadCount: integer);
var i: integer;
begin
  if (fReqQueue=0) or (ChildThreadCount<=0) then
    exit; // nothing to clone (need a queue and a process event)
  if ChildThreadCount > 256 then
    ChildThreadCount := 256; // not worth adding
  for i := 1 to ChildThreadCount do
  begin
    //fClones.Add(THttpApiServer.CreateClone(self));
  end;
end;

function THttpApiServer.AddUrl(const aRoot, aPort: RawByteString; Https: boolean;
  const aDomainName: RawByteString): integer;
var s: RawByteString;
    n: integer;
begin
  result := -1;
  if (Self=nil) or (fReqQueue=0) or (fLibHttpSys.Module=0) then
    exit;
  //s := RegURL(aRoot, aPort, Https, aDomainName);
  if s='' then
    exit; // invalid parameters
  result := fLibHttpSys.AddUrl(fReqQueue,pointer(s));
  if NO_ERROR = result then
  begin
    n := length(fRegisteredUrl);
    SetLength(fRegisteredUrl,n+1);
    fRegisteredUrl[n] := s;
  end;
end;

class function THttpApiServer.AddUrlAuthorize(const aRoot, aPort: RawByteString;
  Https: boolean; const aDomainName: RawByteString; OnlyDelete: boolean): string; 
const
  /// will allow AddUrl() registration to everyone
  // - 'GA' (GENERIC_ALL) to grant all access
  // - 'S-1-1-0'	defines a group that includes all users
  HTTPADDURLSECDESC: PWideChar = 'D:(A;;GA;;;S-1-1-0)';
var
  prefix: RawByteString;
  Error: HRESULT;
  Config: HTTP_SERVICE_CONFIG_URLACL_SET;
begin
  try
    //**HttpApiInitialize(@fLibHttpSys);
    //prefix := RegURL(aRoot, aPort, Https, aDomainName);
    if prefix='' then
      result := 'Invalid parameters'
    else
    begin
      //Error := Http.Initialize(HTTPAPI_VERSION_1,HTTP_INITIALIZE_CONFIG);
      if NO_ERROR <> Error then
      begin
        //raise EHttpApiServer.Create(0,Error);
      end;
      try
        fillchar(Config,sizeof(Config),0);
        Config.KeyDesc.pUrlPrefix := pointer(prefix);
        // first delete any existing information
        //Error := fLibHttpSys.DeleteServiceConfiguration(0,hscUrlAclInfo,@Config,Sizeof(Config));
        // then add authorization rule
        if not OnlyDelete then
        begin
          Config.KeyDesc.pUrlPrefix := pointer(prefix);
          Config.ParamDesc.pStringSecurityDescriptor := HTTPADDURLSECDESC;
          //Error := fLibHttpSys.SetServiceConfiguration(0,hscUrlAclInfo,@Config,Sizeof(Config));
        end;
        if (NO_ERROR <> Error) and (ERROR_ALREADY_EXISTS <> Error) then
        begin
          //raise EHttpApiServer.Create(8,Error);
        end;
        result := ''; // success
      finally
        //fLibHttpSys.Terminate(HTTP_INITIALIZE_CONFIG);
      end;
    end;
  except
    on E: Exception do
      result := E.Message;
  end;
end;

end.
