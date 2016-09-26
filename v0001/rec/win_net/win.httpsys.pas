unit win.httpsys;

interface

uses
  Windows, Winsock2;
          
type              
  RawByteString = AnsiString;
  
  ULONGLONG = Int64;
  HTTP_OPAQUE_ID = ULONGLONG;
  HTTP_URL_CONTEXT = HTTP_OPAQUE_ID;
  HTTP_REQUEST_ID = HTTP_OPAQUE_ID;
  HTTP_CONNECTION_ID = HTTP_OPAQUE_ID;
  HTTP_RAW_CONNECTION_ID = HTTP_OPAQUE_ID;
          
  THttpVerb = (
    hvUnparsed,
    hvUnknown,
    hvInvalid,
    hvOPTIONS,
    hvGET,
    hvHEAD,
    hvPOST,
    hvPUT,
    hvDELETE,
    hvTRACE,
    hvCONNECT,
    hvTRACK,  // used by Microsoft Cluster Server for a non-logged trace
    hvMOVE,
    hvCOPY,
    hvPROPFIND,
    hvPROPPATCH,
    hvMKCOL,
    hvLOCK,
    hvUNLOCK,
    hvSEARCH,
    hvMaximum );
                   
  THttpChunkType = (
    hctFromMemory,
    hctFromFileHandle,
    hctFromFragmentCache);

  // the req* values identify Request Headers, and resp* Response Headers
  THttpHeader = (
    reqCacheControl,
    reqConnection,
    reqDate,
    reqKeepAlive,
    reqPragma,
    reqTrailer,
    reqTransferEncoding,
    reqUpgrade,
    reqVia,
    reqWarning,
    reqAllow,
    reqContentLength,
    reqContentType,
    reqContentEncoding,
    reqContentLanguage,
    reqContentLocation,
    reqContentMd5,
    reqContentRange,
    reqExpires,
    reqLastModified,
    reqAccept,
    reqAcceptCharset,
    reqAcceptEncoding,
    reqAcceptLanguage,
    reqAuthorization,
    reqCookie,
    reqExpect,
    reqFrom,
    reqHost,
    reqIfMatch,
    reqIfModifiedSince,
    reqIfNoneMatch,
    reqIfRange,
    reqIfUnmodifiedSince,
    reqMaxForwards,
    reqProxyAuthorization,
    reqReferer,
    reqRange,
    reqTe,
    reqTranslate,
    reqUserAgent
{$ifndef CONDITIONALEXPRESSIONS}
   );
const
  respAcceptRanges = THttpHeader(20);
  respLocation = THttpHeader(23);
  respWwwAuthenticate = THttpHeader(29);
type
{$else}  ,
    respAcceptRanges = 20,
    respAge,
    respEtag,
    respLocation,
    respProxyAuthenticate,
    respRetryAfter,
    respServer,
    respSetCookie,
    respVary,
    respWwwAuthenticate);
{$endif}
                         
  THttpServiceConfigID = (
    hscIPListenList,
    hscSSLCertInfo,
    hscUrlAclInfo,      
    hscMax);
    
  THttpServiceConfigQueryType = (
    hscQueryExact,
    hscQueryNext,
    hscQueryMax);

  // HTTP version used
  HTTP_VERSION = packed record
    MajorVersion: word;
    MinorVersion: word;
  end;
            
  // Pointers overlap and point into pFullUrl. nil if not present.
  HTTP_COOKED_URL = record
    FullUrlLength: word;     // in bytes not including the #0
    HostLength: word;        // in bytes not including the #0
    AbsPathLength: word;     // in bytes not including the #0
    QueryStringLength: word; // in bytes not including the #0
    pFullUrl: PWideChar;     // points to "http://hostname:port/abs/.../path?query"
    pHost: PWideChar;        // points to the first char in the hostname
    pAbsPath: PWideChar;     // Points to the 3rd '/' char
    pQueryString: PWideChar; // Points to the 1st '?' char or #0
  end;
           
  HTTP_TRANSPORT_ADDRESS = record
    pRemoteAddress: PSOCKADDR;
    pLocalAddress: PSOCKADDR;
  end;
                    
  HTTP_UNKNOWN_HEADER = record
    NameLength: word;          // in bytes not including the #0
    RawValueLength: word;      // in bytes not including the n#0
    pName: PAnsiChar;          // The header name (minus the ':' character)
    pRawValue: PAnsiChar;      // The header value
  end;
  PHTTP_UNKNOWN_HEADER = ^HTTP_UNKNOWN_HEADER;
                   
  HTTP_KNOWN_HEADER = record
    RawValueLength: word;     // in bytes not including the #0
    pRawValue: PAnsiChar;
  end;
  PHTTP_KNOWN_HEADER = ^HTTP_KNOWN_HEADER;

  HTTP_REQUEST_HEADERS = record
    // number of entries in the unknown HTTP headers array
    UnknownHeaderCount: word;
    // array of unknown HTTP headers
    pUnknownHeaders: PHTTP_UNKNOWN_HEADER;
    // Reserved, must be 0
    TrailerCount: word;
    // Reserved, must be nil
    pTrailers: pointer;
    // Known headers
    KnownHeaders: array[low(THttpHeader)..reqUserAgent] of HTTP_KNOWN_HEADER;
  end;
                          
  HTTP_BYTE_RANGE = record
    StartingOffset: ULARGE_INTEGER;
    Length: ULARGE_INTEGER;
  end;
   
  HTTP_DATA_CHUNK = record
    case DataChunkType: THttpChunkType of
    hctFromMemory: (
    FromMemory: record
      Reserved1: ULONG;
      pBuffer: pointer;
      BufferLength: ULONG;
      Reserved2: ULONG;
      Reserved3: ULONG;
    end; );
    hctFromFileHandle: (
    FromFileHandle: record
      ByteRange: HTTP_BYTE_RANGE;
      FileHandle: THandle;
    end; );
    hctFromFragmentCache: (
    FromFragmentCache: record
      FragmentNameLength: word;      // in bytes not including the #0
      pFragmentName: PWideChar;
    end; );
  end;
  PHTTP_DATA_CHUNK = ^HTTP_DATA_CHUNK;
                     
  HTTP_SSL_CLIENT_CERT_INFO = record
    CertFlags: ULONG;
    CertEncodedSize: ULONG;
    pCertEncoded: PUCHAR;
    Token: THandle;
    CertDeniedByMapper: boolean;
  end;
  PHTTP_SSL_CLIENT_CERT_INFO = ^HTTP_SSL_CLIENT_CERT_INFO;

  HTTP_SSL_INFO = record
    ServerCertKeySize: word;
    ConnectionKeySize: word;
    ServerCertIssuerSize: ULONG;
    ServerCertSubjectSize: ULONG;
    pServerCertIssuer: PAnsiChar;
    pServerCertSubject: PAnsiChar;
    pClientCertInfo: PHTTP_SSL_CLIENT_CERT_INFO;
    SslClientCertNegotiated: ULONG;
  end;
  PHTTP_SSL_INFO = ^HTTP_SSL_INFO;
                             
  HTTP_SERVICE_CONFIG_URLACL_KEY = record
    pUrlPrefix: PWideChar;
  end;
  HTTP_SERVICE_CONFIG_URLACL_PARAM = record
    pStringSecurityDescriptor: PWideChar;
  end;
  HTTP_SERVICE_CONFIG_URLACL_SET = record
    KeyDesc: HTTP_SERVICE_CONFIG_URLACL_KEY;
    ParamDesc: HTTP_SERVICE_CONFIG_URLACL_PARAM;
  end;
  HTTP_SERVICE_CONFIG_URLACL_QUERY = record
    QueryDesc: THttpServiceConfigQueryType;
    KeyDesc: HTTP_SERVICE_CONFIG_URLACL_KEY;
    dwToken: DWORD;
  end;

  /// structure used to handle data associated with a specific request
  HTTP_REQUEST = record
    // either 0 (Only Header), either HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY
    Flags: cardinal;
    // An identifier for the connection on which the request was received
    ConnectionId: HTTP_CONNECTION_ID;
    // A value used to identify the request when calling
    // HttpReceiveRequestEntityBody, HttpSendHttpResponse, and/or
    // HttpSendResponseEntityBody
    RequestId: HTTP_REQUEST_ID;
    // The context associated with the URL prefix
    UrlContext: HTTP_URL_CONTEXT;
    // The HTTP version number
    Version: HTTP_VERSION;
    // An HTTP verb associated with this request
    Verb: THttpVerb;
    // The length of the verb string if the Verb field is hvUnknown
    // (in bytes not including the last #0)
    UnknownVerbLength: word;
    // The length of the raw (uncooked) URL (in bytes not including the last #0)
    RawUrlLength: word;
     // Pointer to the verb string if the Verb field is hvUnknown
    pUnknownVerb: PAnsiChar;
    // Pointer to the raw (uncooked) URL
    pRawUrl: PAnsiChar;
    // The canonicalized Unicode URL
    CookedUrl: HTTP_COOKED_URL;
    // Local and remote transport addresses for the connection
    Address: HTTP_TRANSPORT_ADDRESS;
    // The request headers.
    Headers: HTTP_REQUEST_HEADERS;
    // The total number of bytes received from network for this request
    BytesReceived: ULONGLONG;
    EntityChunkCount: word;
    pEntityChunks: PHTTP_DATA_CHUNK;
    RawConnectionId: HTTP_RAW_CONNECTION_ID;
    // SSL connection information
    pSslInfo: PHTTP_SSL_INFO; 
  end;
  PHTTP_REQUEST = ^HTTP_REQUEST;
                       
  HTTP_RESPONSE_HEADERS = record
    // number of entries in the unknown HTTP headers array
    UnknownHeaderCount: word;
    // array of unknown HTTP headers
    pUnknownHeaders: PHTTP_UNKNOWN_HEADER;
    // Reserved, must be 0
    TrailerCount: word;
    // Reserved, must be nil
    pTrailers: pointer;
    // Known headers
    KnownHeaders: array[low(THttpHeader)..respWwwAuthenticate] of HTTP_KNOWN_HEADER;
  end;
       
  HTTP_RESPONSE = object
  public
    Flags: cardinal;
    // The raw HTTP protocol version number
    Version: HTTP_VERSION;
    // The HTTP status code (e.g., 200)
    StatusCode: word;
    // in bytes not including the '\0'
    ReasonLength: word;
    // The HTTP reason (e.g., "OK"). This MUST not contain non-ASCII characters
    // (i.e., all chars must be in range 0x20-0x7E).
    pReason: PAnsiChar;
    // The response headers
    Headers: HTTP_RESPONSE_HEADERS;
    // number of elements in pEntityChunks[] array
    EntityChunkCount: word;
    // pEntityChunks points to an array of EntityChunkCount HTTP_DATA_CHUNKs
    pEntityChunks: PHTTP_DATA_CHUNK;
    // will set both StatusCode and Reason
    // - OutStatus is a temporary variable
    // - if DataChunkForErrorContent is set, it will be used to add a content
    // body in the response with the textual representation of the error code
    procedure SetStatus(code: integer; var OutStatus: RawByteString;
      DataChunkForErrorContent: PHTTP_DATA_CHUNK=nil; const ErrorMsg: RawByteString='');
    // will set the content of the reponse, and ContentType header
    procedure SetContent(var DataChunk: HTTP_DATA_CHUNK; const Content: RawByteString;
      const ContentType: RawByteString='text/html');
    /// will set all header values from lines
    // - Content-Type/Content-Encoding/Location will be set in KnownHeaders[]
    // - all other headers will be set in temp UnknownHeaders[0..MaxUnknownHeader]
    procedure SetHeaders(P: PAnsiChar; UnknownHeaders: PHTTP_UNKNOWN_HEADER;
      MaxUnknownHeader: integer);
  end;
  PHTTP_RESPONSE = ^HTTP_RESPONSE;

  PLibHttpSys = ^TLibHttpSys;
  TLibHttpSys = packed record
    Module: THandle;
    {/ The HttpInitialize function initializes the HTTP Server API driver, starts it,
    if it has not already been started, and allocates data structures for the
    calling application to support response-queue creation and other operations.
    Call this function before calling any other functions in the HTTP Server API. }
    Initialize: function(Version: HTTP_VERSION; Flags: cardinal;
      pReserved: pointer=nil): HRESULT; stdcall;
    {/ The HttpTerminate function cleans up resources used by the HTTP Server API
    to process calls by an application. An application should call HttpTerminate
    once for every time it called HttpInitialize, with matching flag settings. }
    Terminate: function(Flags: cardinal;
      Reserved: integer=0): HRESULT; stdcall;
    {/ The HttpCreateHttpHandle function creates an HTTP request queue for the
    calling application and returns a handle to it. }
    CreateHttpHandle: function(var ReqQueueHandle: THandle;
      Reserved: integer=0): HRESULT; stdcall;
    {/ The HttpAddUrl function registers a given URL so that requests that match
    it are routed to a specified HTTP Server API request queue. An application
    can register multiple URLs to a single request queue using repeated calls to
    HttpAddUrl.
    - a typical url prefix is 'http://+:80/vroot/', 'https://+:80/vroot/' or
      'http://adatum.com:443/secure/database/' - here the '+' is called a
      Strong wildcard, i.e. will match every IP or server name }
    AddUrl: function(ReqQueueHandle: THandle; UrlPrefix: PWideChar;
      Reserved: integer=0): HRESULT; stdcall;
    {/ Unregisters a specified URL, so that requests for it are no longer
      routed to a specified queue. }
    RemoveUrl: function(ReqQueueHandle: THandle; UrlPrefix: PWideChar): HRESULT; stdcall;
    {/ retrieves the next available HTTP request from the specified request queue }
    ReceiveHttpRequest: function(ReqQueueHandle: THandle; RequestId: HTTP_REQUEST_ID;
      Flags: cardinal; var pRequestBuffer: HTTP_REQUEST; RequestBufferLength: ULONG;
      var pBytesReceived: ULONG; pOverlapped: pointer=nil): HRESULT; stdcall;
    {/ sent the response to a specified HTTP request }
    SendHttpResponse: function(ReqQueueHandle: THandle; RequestId: HTTP_REQUEST_ID;
      Flags: integer; var pHttpResponse: HTTP_RESPONSE; pReserved1: pointer;
      var pBytesSent: cardinal; pReserved2: pointer=nil; Reserved3: ULONG=0;
      pOverlapped: pointer=nil; pReserved4: pointer=nil): HRESULT; stdcall;
    {/ receives additional entity body data for a specified HTTP request }
    ReceiveRequestEntityBody: function(ReqQueueHandle: THandle; RequestId: HTTP_REQUEST_ID;
      Flags: ULONG; pBuffer: pointer; BufferLength: cardinal; var pBytesReceived: cardinal;
      pOverlapped: pointer=nil): HRESULT; stdcall;
    {/ set specified data, such as IP addresses or SSL Certificates, from the
      HTTP Server API configuration store}
    SetServiceConfiguration: function(ServiceHandle: THandle;
      ConfigId: THttpServiceConfigID; pConfigInformation: pointer;
      ConfigInformationLength: ULONG; pOverlapped: pointer=nil): HRESULT; stdcall;
    {/ deletes specified data, such as IP addresses or SSL Certificates, from the
      HTTP Server API configuration store}
    DeleteServiceConfiguration: function(ServiceHandle: THandle;
      ConfigId: THttpServiceConfigID; pConfigInformation: pointer;
      ConfigInformationLength: ULONG; pOverlapped: pointer=nil): HRESULT; stdcall;
  end;
                        
const
  HTTP_VERSION_UNKNOWN: HTTP_VERSION = (MajorVersion: 0; MinorVersion: 0);
  HTTP_VERSION_0_9: HTTP_VERSION = (MajorVersion: 0; MinorVersion: 9);
  HTTP_VERSION_1_0: HTTP_VERSION = (MajorVersion: 1; MinorVersion: 0);
  HTTP_VERSION_1_1: HTTP_VERSION = (MajorVersion: 1; MinorVersion: 1);
  HTTPAPI_VERSION_1: HTTP_VERSION = (MajorVersion: 1; MinorVersion: 0);
  HTTPAPI_VERSION_2: HTTP_VERSION = (MajorVersion: 2; MinorVersion: 0);
  
  // if set, available entity body is copied along with the request headers
  // into pEntityChunks
  HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY = 1;
  // there is more entity body to be read for this request
  HTTP_REQUEST_FLAG_MORE_ENTITY_BODY_EXISTS = 1;
  // initialization for applications that use the HTTP Server API
  HTTP_INITIALIZE_SERVER = 1;
  // initialization for applications that use the HTTP configuration functions
  HTTP_INITIALIZE_CONFIG = 2;
  // see http://msdn.microsoft.com/en-us/library/windows/desktop/aa364496
  HTTP_RECEIVE_REQUEST_ENTITY_BODY_FLAG_FILL_BUFFER = 1;
  // see http://msdn.microsoft.com/en-us/library/windows/desktop/aa364499
  HTTP_SEND_RESPONSE_FLAG_PROCESS_RANGES = 1;

  procedure HttpApiInitialize(AHttpApiLib: PLibHttpSys);   
  function IdemPChar(p, up: pAnsiChar): boolean;

implementation

{ HTTP_RESPONSE }
                            
const
  XPOWEREDNAME = 'X-Powered-By';
  XPOWEREDVALUE = 'SynCrtSock http://synopse.info';
                               
procedure HTTP_RESPONSE.SetContent(var DataChunk: HTTP_DATA_CHUNK;
  const Content, ContentType: RawByteString);
begin
  if Content='' then
    exit;
  fillchar(DataChunk,sizeof(DataChunk),0);
  DataChunk.DataChunkType := hctFromMemory;
  DataChunk.FromMemory.pBuffer := pointer(Content);
  DataChunk.FromMemory.BufferLength := length(Content);
  EntityChunkCount := 1;
  pEntityChunks := @DataChunk;
  Headers.KnownHeaders[reqContentType].RawValueLength := length(ContentType);
  Headers.KnownHeaders[reqContentType].pRawValue := pointer(ContentType);
end;
                  
function IdemPChar(p, up: pAnsiChar): boolean;
// if the beginning of p^ is same as up^ (ignore case - up^ must be already Upper)
var c: AnsiChar;
begin
  result := false;
  if (p=nil) or (up=nil) then
    exit;
  while up^<>#0 do begin
    c := p^;
    if up^<>c then
      if c in ['a'..'z'] then begin
        dec(c,32);
        if up^<>c then
          exit;
      end else exit;
    inc(up);
    inc(p);
  end;
  result := true;
end;

procedure HTTP_RESPONSE.SetHeaders(P: PAnsiChar;
  UnknownHeaders: PHTTP_UNKNOWN_HEADER; MaxUnknownHeader: integer);
const XPN: PAnsiChar = XPOWEREDNAME;
      XPV: PAnsiChar = XPOWEREDVALUE;
var Known: THttpHeader;
begin
  with UnknownHeaders^ do begin
    pName := XPN;
    NameLength := length(XPOWEREDNAME);
    pRawValue := XPV;
    RawValueLength := length(XPOWEREDVALUE);
  end;
  Headers.pUnknownHeaders := UnknownHeaders;
  Headers.UnknownHeaderCount := 1;
  inc(UnknownHeaders);
  if P<>nil then
  repeat
    while P^ in [#13,#10] do inc(P);
    if P^=#0 then
      break;
    if IdemPChar(P,'CONTENT-TYPE:') then
      Known := reqContentType else
    if IdemPChar(P,'CONTENT-ENCODING:') then
      Known := reqContentEncoding else
    if IdemPChar(P,'LOCATION:') then
      Known := respLocation else
      Known := reqCacheControl; // mark not found
    if Known<>reqCacheControl then
    with Headers.KnownHeaders[Known] do begin
      while P^<>':' do inc(P);
      inc(P); // jump ':'
      while P^=' ' do inc(P);
      pRawValue := P;
      while P^>=' ' do inc(P);
      RawValueLength := P-pRawValue;
    end else begin
      UnknownHeaders^.pName := P;
      while (P^>=' ') and (P^<>':') do inc(P);
      if P^=':' then
        with UnknownHeaders^ do begin
          NameLength := P-pName;
          repeat inc(P) until P^<>' ';
          pRawValue := P;
          repeat inc(P) until P^<' ';
          RawValueLength := P-pRawValue;
          if Headers.UnknownHeaderCount<MaxUnknownHeader then begin
            inc(UnknownHeaders);
            inc(Headers.UnknownHeaderCount);
          end;
        end else
        while P^>=' ' do inc(P);
    end;
  until false;
end;
                       
function StatusCodeToReason(Code: integer): RawByteString;
begin
  case Code of
    100: result := 'Continue';
    200: result := 'OK';
    201: result := 'Created';
    202: result := 'Accepted';
    203: result := 'Non-Authoritative Information';
    204: result := 'No Content';
    300: result := 'Multiple Choices';
    301: result := 'Moved Permanently';
    302: result := 'Found';
    303: result := 'See Other';
    304: result := 'Not Modified';
    307: result := 'Temporary Redirect';
    400: result := 'Bad Request';
    401: result := 'Unauthorized';
    403: result := 'Forbidden';
    404: result := 'Not Found';
    405: result := 'Method Not Allowed';
    406: result := 'Not Acceptable';
    500: result := 'Internal Server Error';
    503: result := 'Service Unavailable';
    else str(Code,result);
  end;
end;

procedure HTTP_RESPONSE.SetStatus(code: integer; var OutStatus: RawByteString;
 DataChunkForErrorContent: PHTTP_DATA_CHUNK; const ErrorMsg: RawByteString);
begin
  StatusCode := code;
  OutStatus := StatusCodeToReason(code);
  ReasonLength := length(OutStatus);
  pReason := pointer(OutStatus);
  if DataChunkForErrorContent<>nil then
    SetContent(DataChunkForErrorContent^,'<h1>'+OutStatus+'</h1>'+ErrorMsg);
end;

procedure HttpApiInitialize(AHttpApiLib: PLibHttpSys);      
const
  HttpNames: array[0..9] of PChar = (
    'HttpInitialize','HttpTerminate','HttpCreateHttpHandle',
    'HttpAddUrl', 'HttpRemoveUrl', 'HttpReceiveHttpRequest',
    'HttpSendHttpResponse', 'HttpReceiveRequestEntityBody',
    'HttpSetServiceConfiguration', 'HttpDeleteServiceConfiguration');
//var i: Integer;
//    P: PPointer;
begin
  if nil = AHttpApiLib then
    exit;
  if 0 <> AHttpApiLib.Module then
    exit; // already loaded
  if 0 = AHttpApiLib.Module then
  begin
    AHttpApiLib.Module := LoadLibrary('httpapi.dll');
    if AHttpApiLib.Module <= 255 then
    begin
      AHttpApiLib.Module := 0;
      //raise Exception.Create('Unable to find httpapi.dll');
      exit;
    end;
  end;
  AHttpApiLib.Initialize := GetProcAddress(AHttpApiLib.Module, HttpNames[0]);
  AHttpApiLib.Terminate := GetProcAddress(AHttpApiLib.Module, HttpNames[1]);
  AHttpApiLib.CreateHttpHandle := GetProcAddress(AHttpApiLib.Module, HttpNames[2]);
  AHttpApiLib.AddUrl := GetProcAddress(AHttpApiLib.Module, HttpNames[3]);
  AHttpApiLib.RemoveUrl := GetProcAddress(AHttpApiLib.Module, HttpNames[4]);
  AHttpApiLib.ReceiveHttpRequest := GetProcAddress(AHttpApiLib.Module, HttpNames[5]);
  AHttpApiLib.SendHttpResponse := GetProcAddress(AHttpApiLib.Module, HttpNames[6]);
  AHttpApiLib.ReceiveRequestEntityBody := GetProcAddress(AHttpApiLib.Module, HttpNames[7]);
  AHttpApiLib.SetServiceConfiguration := GetProcAddress(AHttpApiLib.Module, HttpNames[8]);
  AHttpApiLib.DeleteServiceConfiguration := GetProcAddress(AHttpApiLib.Module, HttpNames[9]);              
  (*//                  
  try
      {$ifdef FPC}
      P := @AHttpApiLib.Initialize;
      {$else}
      P := @@AHttpApiLib.Initialize;
      {$endif}
      for i := 0 to high(HttpNames) do begin
        P^ := GetProcAddress(AHttpApiLib.Module, HttpNames[i]);
        if nil = P^ then
        begin
          //raise Exception.CreateFmt('Unable to find %s in httpapi.dll',[HttpNames[i]]);
        end;
        inc(P);
      end;
  except
    on E: Exception do
    begin
      if 255 < AHttpApiLib.Module then
      begin
        FreeLibrary(AHttpApiLib.Module);
        AHttpApiLib.Module := 0;
      end;
      raise E;
    end;
  end;
  //*)
end;

end.
