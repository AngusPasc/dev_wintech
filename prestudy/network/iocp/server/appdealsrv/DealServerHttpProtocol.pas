unit DealServerHttpProtocol;

interface

(*// http Э��
http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html
http://host[":"port][abs_path]
=====================================================
GET     �����ȡRequest-URI����ʶ����Դ
POST    ��Request-URI����ʶ����Դ�󸽼��µ�����
HEAD    �����ȡ��Request-URI����ʶ����Դ����Ӧ��Ϣ��ͷ
PUT     ����������洢һ����Դ������Request-URI��Ϊ���ʶ
DELETE  ���������ɾ��Request-URI����ʶ����Դ
TRACE   ��������������յ���������Ϣ����Ҫ���ڲ��Ի����
CONNECT ��������ʹ��  HTTP/1.1Э����Ԥ�����ܹ������Ӹ�Ϊ�ܵ���ʽ�Ĵ��������
OPTIONS �����ѯ�����������ܣ����߲�ѯ����Դ��ص�ѡ�������
PATCH - �������ֲ��޸�Ӧ����ĳһ��Դ������ڹ淶RFC5789
=====================================================
GET /form.html HTTP/1.1 (CRLF)
-----------------------------------------------------
POST /reg.jsp HTTP/ (CRLF)
Accept:image/gif,image/x-xbit,... (CRLF)
...
HOST:www.guet.edu.cn (CRLF)
Content-Length:22 (CRLF)
Connection:Keep-Alive (CRLF)
Cache-Control:no-cache (CRLF)
(CRLF)         //��CRLF��ʾ��Ϣ��ͷ�Ѿ��������ڴ�֮ǰΪ��Ϣ��ͷ
user=jeffrey&pwd=1234  //��������Ϊ�ύ������   
-----------------------------------------------------  
=====================================================
����������һ��HTTP��Ӧ��Ϣ

������Ϣ����Ӧ��Ϣ������
  ��ʼ�У�����������Ϣ����ʼ�о��������У�������Ӧ��Ϣ����ʼ�о���״̬�У���
  ��Ϣ��ͷ����ѡ����
  ���У�ֻ��CRLF���У���
  ��Ϣ���ģ���ѡ�����
            
HTTP��ӦҲ��������������ɣ��ֱ��ǣ�״̬�С���Ϣ��ͷ����Ӧ����
HTTP-Version Status-Code Reason-Phrase CRLF
1xx��ָʾ��Ϣ--��ʾ�����ѽ��գ���������
2xx���ɹ�--��ʾ�����ѱ��ɹ����ա���⡢����
3xx���ض���--Ҫ������������и���һ���Ĳ���
4xx���ͻ��˴���--�������﷨����������޷�ʵ��
5xx���������˴���--������δ��ʵ�ֺϷ�������
HTTP��Ϣ��ͷ������ͨ��ͷ������ͷ����Ӧ��ͷ��ʵ�屨ͷ
1����ͨ��ͷ
  Cache-Control
  ����ʱ�Ļ���ָ����� no-cache������ָʾ�������Ӧ��Ϣ���ܻ��棩��no-store��max-age��max-stale��min-fresh��only-if-cached
  ��Ӧʱ�Ļ���ָ�������public��private��no-cache��no-store��no-transform��must-revalidate��proxy-revalidate��max-age��s-maxage
  Date
  Connection
2������ͷ
  Accept Accept-Charset Accept-Encoding Accept-Language
  Authorization
  Host
  User-Agent
3����Ӧ��ͷ
  Location Server WWW-Authenticate
4��ʵ�屨ͷ
  Content-Encoding
  Content-Language
  Content-Length
  Content-Type   text/html;charset=GB2312
  Last-Modified
  Expires
=====================================================
 multipart/form-data���뷽ʽ
POST http://www.example.com HTTP/1.1
Content-Type:multipart/form-data; boundary=${bound}
 
--${bound}
Content-Disposition: form-data; name="text"
 
title

--${bound}
Content-Disposition: form-data; name="file"; filename="chrome.png"
Content-Type: image/png
 
PNG ... content of chrome.png ...
--${bound}--                                           
=====================================================
application/x-www-form-urlencoded���뷽ʽ
POST http://www.qmailer.net HTTP/1.1
  Content-Type: application/x-www-form-urlencoded; charset=utf-8
 
  name=qmailer&domain=net
=====================================================
application/json���뷽ʽ
POST http://www.example.com HTTP/1.1
  Content-Type: application/json; charset=utf-8
 
  {"title":"test","sub":[1,2,3]}       
=====================================================
    <form action="Ŀ���ַ" method="���ͷ�ʽ" enctype="��������ı��뷽ʽ">   
      <!-- �����͵ı��� -->
      <input name="NAME" value="VALUE"/>
      <textarea name="NAME">VALUE</textarea>
      <select name="NAME">
        <option value="VALUE" selected="selected"/>
      </select>
    </form>
=====================================================  
//*)

uses
  NetBaseObj,
  BaseDataIO;

type
  THttpAction = (
    actHttpUnknown ,
    actHttpNone    ,
    actHttpGet     ,//�����ȡRequest-URI����ʶ����Դ
    actHttpPost    ,//��Request-URI����ʶ����Դ�󸽼��µ�����
    actHttpHead    ,//�����ȡ��Request-URI����ʶ����Դ����Ӧ��Ϣ��ͷ
    actHttpPut     ,//����������洢һ����Դ������Request-URI��Ϊ���ʶ
    actHttpDelete  ,//���������ɾ��Request-URI����ʶ����Դ
    actHttpTrace   ,//��������������յ���������Ϣ����Ҫ���ڲ��Ի����
    actHttpConnect ,//��������ʹ��  HTTP/1.1Э����Ԥ�����ܹ������Ӹ�Ϊ�ܵ���ʽ�Ĵ��������
    actHttpOptions ,//�����ѯ�����������ܣ����߲�ѯ����Դ��ص�ѡ�������
    actHttpPatch    //�������ֲ��޸�Ӧ����ĳһ��Դ������ڹ淶RFC5789
  );
  
  PHttpUrlInfo = ^THttpUrlInfo;
  THttpUrlInfo = record
    Protocol  : string;
    Host      : string;
    Port      : string;
    PathName  : string;
    UserName  : string;
    Password  : string;
  end;
                
  THttpDataOutSession = record

  end;

  PNetHttpSession     = ^TNetHttpSession;
  TNetHttpSession     = record
    Base              : TNetClientConnectSession;
    DataOutSession    : THttpDataOutSession;
  end;
  
const
  HttpAction: array [THttpAction] of AnsiString = (
    '', '', 'GET', 'POST', 'HEAD', 'PUT',
    'DELETE', 'TRACE', 'CONNECT', 'OPTIONS', 'PATCH'
  );

  SessionMagic_Http = $80;
  
  function HttpUrlInfoParse(AUrl: string; AInfo: PHttpUrlInfo): Boolean; 
  function HttpClientGenRequestHeader(AHttpUrlInfo: PHttpUrlInfo): AnsiString;

  procedure HttpServerDataInHandle(const AClient: PNetClientConnect; const AData: PDataBuffer);
  procedure HttpServerDataOutEndHandle(const AClient: PNetClientConnect; const AData: PDataBuffer);
                                
  function CheckOutHttpClientSession(AClient: PNetClientConnect) : PNetClientConnectSession;
  procedure CheckInHttpClientSession(var ASession: PNetClientConnectSession);

implementation

uses
  //SDLogutils,
  Windows,
  Sysutils,
  win.diskfile;
            
function HttpUrlInfoParse(AUrl: string; AInfo: PHttpUrlInfo): Boolean;
var
  Idx: Integer;
  Buff: string;
  
  function ExtractStr(var ASrc: string; ADelim: string;
    ADelete: Boolean = True): string;
  var
    Idx: Integer;
  begin
    Idx := Pos(ADelim, ASrc);
    if Idx = 0 then
    begin
      Result := ASrc;
      if ADelete then
        ASrc := '';
    end else
    begin
      Result := Copy(ASrc, 1, Idx - 1);
      if ADelete then
        ASrc := Copy(ASrc, Idx + Length(ADelim), MaxInt);
    end;
  end;
  
begin
  Result := False;
  AUrl := Trim(AUrl);
  Idx := Pos('://', AUrl);
  if Idx > 0 then
  begin
    AInfo.Protocol := Copy(AUrl, 1, Idx  - 1);
    Delete(AUrl, 1, Idx + 2);
    if AUrl = '' then
      Exit;

    Buff := ExtractStr(AUrl, '/');
    Idx := Pos('@', Buff);
    AInfo.Password := Copy(Buff, 1, Idx  - 1);
    if Idx > 0 then
      Delete(Buff, 1, Idx);

    AInfo.UserName := ExtractStr(AInfo.Password, ':');
    if Length(AInfo.UserName) = 0 then
      AInfo.Password := '';

    AInfo.Host := ExtractStr(Buff, ':');
    AInfo.Port := Buff;
    AInfo.PathName := '/' + AUrl;
    Result := True;
  end;
end;


function HttpClientGenRequestHeader(AHttpUrlInfo: PHttpUrlInfo): AnsiString;
var
  TmpStr:AnsiString;
  strVersion:AnsiString;
  Index:Integer;
begin
  Result := '';
  //if Self.HttpVersion = pv_11 then
  //else
    //strVersion := '1.0';

//  if (ProxyType = ptNone) or (ProxyType = ptSock5) then
//  begin
//    if FHttpMethod = hmGet then
//      TmpStr := 'GET' + #32 + URLPath + #32 + 'HTTP/' + strVersion
//    else
//      TmpStr := 'POST' + #32 + URLPath + #32 + 'HTTP/' + strVersion;
//  end else if FProxyType = ptHttp then
//  begin
//   if FHttpMethod = hmGet then
//      TmpStr := 'GET' + #32 + URL + #32 + 'HTTP/' + strVersion
//    else
//      TmpStr := 'POST' + #32 + URL + #32 + 'HTTP/' + strVersion;
//  end;
  (*//
  GET / HTTP/1.1#$D#$A
  Host: www.sohu.com#$D#$A
  User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:21.0) Gecko/20100101 Firefox/21.0#$D#$A
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'#$D#$A
  Connection: keep-alive#$D#$A
  Accept-Encoding: gzip, deflate'#$D#$A
  Accept-Language: zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3'#$D#$A#$D#$A
  //*)                       
    strVersion := '1.1';
  Result := 'GET' + #32 + AHttpUrlInfo.PathName + #32 + 'HTTP/' + strVersion;
  Result := Result + #13#10;

  Result := Result + 'Host:' + #32 + AHttpUrlInfo.Host;
  Result := Result + #13#10;

  Result := Result + 'User-Agent:' + #32 + 'Mozilla/5.0 (Windows NT 5.1; rv:21.0) Gecko/20100101 Firefox/21.0';//UserAgent;
  Result := Result + #13#10;

  //Result := Result + 'Accept:' + #32 + 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
  //Result := Result + #13#10;
  Result := Result + 'Accept:' + #32 + 'text/html,*/*';
  Result := Result + #13#10;


  //Referer
  //if Self.Referer <> '' then
  //  Headers.Add('Referer: ' + Referer);

  //Result := Result + 'Connection:' + #32 + 'keep-alive'; 
  Result := Result + 'Connection:' + #32 + 'close';
  Result := Result + #13#10;


  Result := Result + 'Accept-Encoding:identity';  
  //Result := Result + 'Accept-Encoding:' + #32 + 'gzip, deflate';
  Result := Result + #13#10;

  Result := Result + 'Accept-Language:' + #32 + 'zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3';
  Result := Result + #13#10;

  Result := Result + 'Cookie:' +
      's=c0314lsw8q' + '; ' +
      'xq_a_token=51ae43fe10914e301fb74017584c7bee426ed0e6' + '; ' +
      'xq_r_token=5630ffe651fb9190c98bb2f9bddcd2284e76463b';
  Result := Result + #13#10;
    
  Result := Result + #13#10;

  //ContentType
  //if (HttpMethod = hmPost) and (ContentType <> '') then
  //  Headers.Add('Content-Type: ' + ContentType);


  //if (HttpMethod = hmPost) and (ContentLength > 0) then
  //begin
  //  Headers.Add('Content-Length: ' + IntToStr(ContentLength));
  //end;

  //Cookie
  //if FOwner.Cookies <> nil then
  //begin
  //  FCookie := FOwner.Cookies.GetCookies(URL);
  // if FCookie <> '' then
  //   Headers.Add('Cookie: ' + FCookie);

  //����ͻ�ͷ
  //for Index := 0 to CustomHeaders.Count - 1 do
  //begin
  //  TmpStr := CustomHeaders.Strings[Index];
  //  if TmpStr <> '' then
  //    Headers.Add(TmpStr);
  //end;        
end;

function CheckOutHttpClientSession(AClient: PNetClientConnect) : PNetClientConnectSession;
var
  tmpSession: PNetHttpSession;
begin
  tmpSession := System.New(PNetHttpSession);
  FillChar(tmpSession^, SizeOf(TNetHttpSession), 0);
  tmpSession.Base.SessionMagic := SessionMagic_Http;       
  tmpSession.Base.ClientConnect := AClient;
  Result := @tmpSession.Base;
end;

procedure CheckInHttpClientSession(var ASession: PNetClientConnectSession);
begin
  FreeMem(ASession);
  ASession := nil;
end;

var
  rootCounter: integer = 0;

procedure HttpServerDataInHandle(const AClient: PNetClientConnect; const AData: PDataBuffer);
var
  tmpMethod: string;
  tmpPath: string;
  tmpFileExt: string;
  tmpStep: integer;
  tmpAnsi: AnsiString;
  tmpAnsiContentType: AnsiString;
  tmpAnsiContent: AnsiString;
  i: integer;
  tmpLastPos: integer;
  tmpFileUrl: AnsiString;
  tmpDataBuf: PDataBuffer;
  tmpReadSize: DWORD;
  tmpIsStream: Boolean;
  tmpHttpSession: PNetHttpSession;
  tmpServer: PNetServer;
begin
  tmpMethod := '';
  tmpPath := '';
  tmpStep := 0;
  if nil = AClient then
    exit;
  if nil = AData then
    exit;
  tmpServer := AClient.Server;
  if nil = tmpServer then
    exit;
  tmpAnsi := PAnsiChar(@AData.Data[0]);    
  //SDLog('HttpProtocol.pas', 'HttpServerDataIn ' + tmpAnsi);
  if '' <> tmpAnsi then
  begin
    tmpLastPos := 1;
    for i := 1 to Length(tmpAnsi) do
    begin
      if #32 = tmpAnsi[i] then
      begin
        if 0 = tmpStep then
        begin
          tmpMethod := Copy(tmpAnsi, tmpLastPos, i - tmpLastPos);
          tmpLastPos := i + 1;
          tmpStep := 1;
          Continue;
        end;
        if 1 = tmpStep then
        begin
          tmpPath := Copy(tmpAnsi, tmpLastPos, i - tmpLastPos);   
          tmpLastPos := i + 1;
          tmpStep := 2;
          Continue;
        end;
      end;
    end;
  end;
  if '/' = tmpPath then
  begin
    InterlockedIncrement(rootCounter);
    tmpAnsiContent := '<html>' +
               '<head></head>' +
               '<body>' + FormatDateTime('yyyy-mm-dd hh:nn:ss', now) + '_' + inttostr(rootCounter) + '</body>' +
             '</html>' +
             #13#10 +   
             #13#10;
    tmpAnsi := 'HTTP/1.1 200 OK' + #13#10 +  // ״̬��      
             'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
             'Server: Apache' + #13#10 +
             'Content-Type: text/html' + #13#10 +
             'Content-Length: ' + IntToStr(Length(tmpAnsiContent)) + #13#10 +
             //'Connection: keep-alive' + #13#10 +
             'Connection: close' + #13#10 +
             #13#10 +
             tmpAnsiContent + 
             #13#10;        
    tmpDataBuf := tmpServer.CheckOutDataOutBuffer(AClient);
    if nil <> tmpDataBuf then
    begin
      FillChar(tmpDataBuf.Data, SizeOf(tmpDataBuf.Data), 0);
      CopyMemory(@tmpDataBuf.Data[0], @tmpAnsi[1], Length(tmpAnsi));
      tmpDataBuf.BufferHead.DataLength := Length(tmpAnsi);
      tmpServer.SendDataOut(AClient, tmpDataBuf);
    end;
  end else
  begin
    tmpIsStream := false;
    if '' <> tmpPath then
    begin
      if '/' = tmpPath[1] then
      begin
        tmpFileUrl := ExtractFilePath(ParamStr(0)) + Copy(tmpPath, 2, maxint);
      end else
      begin
        tmpFileUrl := ExtractFilePath(ParamStr(0)) + tmpPath;
      end;
    end;
    tmpFileUrl := StringReplace(tmpFileUrl, '/', '\', [rfReplaceAll]);
    if FileExists(tmpFileUrl) then
    begin
      if nil <> AClient.Session then
      begin
        if SessionMagic_Http <> AClient.Session.SessionMagic then
        begin
          AClient.Session := nil;
        end;
      end;
      if nil = AClient.Session then
      begin
        AClient.Session := CheckOutHttpClientSession(AClient);
        //AClient.Session := tmpServer.CheckOutClientSession(AClient);
      end;
      if SessionMagic_Http = AClient.Session.SessionMagic then
      begin
        tmpHttpSession := PNetHttpSession(AClient.Session);
      end;

      tmpIsStream := false;
      tmpFileExt := lowercase(ExtractFileExt(tmpFileUrl));
      tmpAnsiContentType := 'Content-Type: text/html'#13#10;
      if 0 < Pos('.png', tmpFileExt) then
      begin
        tmpIsStream := true;     
        tmpAnsiContentType := 'Content-Type: image/png'#13#10;
      end;                                        
      if 0 < Pos('.jpg', tmpFileExt) then
      begin
        tmpIsStream := true;     
        tmpAnsiContentType := 'Content-Type: image/jpeg'#13#10;
      end;                           
      if 0 < Pos('.ico', tmpFileExt) then
      begin
        tmpIsStream := true;
        tmpAnsiContentType := 'Content-Type: image/x-icon'#13#10;
      end;
      tmpDataBuf := tmpServer.CheckOutDataOutBuffer(AClient);
      if nil <> tmpDataBuf then
      begin
        if nil <> tmpHttpSession.Base.DataOutFile then
        begin
          CheckInWinFile(tmpHttpSession.Base.DataOutFile);
        end;
        tmpHttpSession.Base.DataOutFile := CheckOutWinFile;
                        
        WinFileOpen(tmpHttpSession.Base.DataOutFile, tmpFileUrl, false);
        if tmpIsStream then
        begin
          tmpAnsi := 'HTTP/1.1 200 OK' + #13#10 +  // ״̬��
               'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
               'Server: Apache' + #13#10 +
               //'Content-Type: application/x-png' + #13#10 + �������ͱ��������
               //'Content-Type: application/octet-stream' + #13#10 +
               tmpAnsiContentType + 
               'Content-Length: ' + IntToStr(tmpHttpSession.Base.DataOutFile.FileSizeLow) + #13#10 +
               //'Connection: keep-alive' + #13#10 +
               'Connection: close' + #13#10 +
               #13#10;
        end else
        begin
          tmpAnsi := 'HTTP/1.1 200 OK' + #13#10 +  // ״̬��
               'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
               'Server: Apache' + #13#10 +
               tmpAnsiContentType + 
               'Content-Length: ' + IntToStr(tmpHttpSession.Base.DataOutFile.FileSizeLow) + #13#10 +
               //'Connection: keep-alive' + #13#10 +
               'Connection: close' + #13#10 +
               #13#10;
        end;
        FillChar(tmpDataBuf.Data, SizeOf(tmpDataBuf.Data), 0);
        CopyMemory(@tmpDataBuf.Data[0], @tmpAnsi[1], Length(tmpAnsi));
        tmpDataBuf.BufferHead.DataLength := Length(tmpAnsi);

        if tmpHttpSession.Base.DataOutFile.FileSizeLow + 2 <= (tmpDataBuf.BufferHead.BufferSize - tmpDataBuf.BufferHead.DataLength) then
        begin
          Windows.ReadFile(tmpHttpSession.Base.DataOutFile.FileHandle,
            tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength],
            tmpHttpSession.Base.DataOutFile.FileSizeLow,
            tmpReadSize,
            nil);
          tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + tmpReadSize;
          tmpHttpSession.Base.DataOutFile.FilePosition := tmpHttpSession.Base.DataOutFile.FilePosition + tmpReadSize;   
          tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength] := #13;
          tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength + 1] := #10;
          tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + 2; 
          WinFileClose(tmpHttpSession.Base.DataOutFile);
        end else
        begin
          Windows.ReadFile(tmpHttpSession.Base.DataOutFile.FileHandle,
            tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength],
            tmpDataBuf.BufferHead.BufferSize - tmpDataBuf.BufferHead.DataLength,
            tmpReadSize,
            nil);                                    
          tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + tmpReadSize;
          tmpHttpSession.Base.DataOutFile.FilePosition := tmpHttpSession.Base.DataOutFile.FilePosition + tmpReadSize;              
        end;
        tmpServer.SendDataOut(AClient, tmpDataBuf);
      end;             
    end else
    begin
      tmpAnsi := 'HTTP/1.1 404 Not Found' + #13#10 +  // ״̬��
             'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
             'Server: Apache' + #13#10 +
             #13#10 +
             #13#10 +
             #13#10;     
      tmpDataBuf := tmpServer.CheckOutDataOutBuffer(AClient);
      if nil <> tmpDataBuf then
      begin
        FillChar(tmpDataBuf.Data, SizeOf(tmpDataBuf.Data), 0);
        CopyMemory(@tmpDataBuf.Data[0], @tmpAnsi[1], Length(tmpAnsi));
        tmpDataBuf.BufferHead.DataLength := Length(tmpAnsi); 
        tmpServer.SendDataOut(AClient, tmpDataBuf);
      end;             
    end;
  end;
  //SDLog('HttpProtocol.pas', 'HttpServerDataIn end');  
end;
      
procedure HttpServerDataOutEndHandle(const AClient: PNetClientConnect; const AData: PDataBuffer);
var 
  tmpHttpSession: PNetHttpSession;   
  tmpDataBuf: PDataBuffer;
  tmpReadSize: DWORD;
  tmpServer: PNetServer;
begin
  if nil = AClient then
    exit;
  if nil = AData then
    exit;
  if nil = AClient.Session then
    exit;             
  tmpServer := AClient.Server;
  if nil = tmpServer then
    exit;
  if SessionMagic_Http = AClient.Session.SessionMagic then
  begin
    tmpHttpSession := PNetHttpSession(AClient.Session);
    if nil <> tmpHttpSession.Base.DataOutFile then
    begin
      if 0 < tmpHttpSession.Base.DataOutFile.FileSizeLow then
      begin
        if tmpHttpSession.Base.DataOutFile.FilePosition < tmpHttpSession.Base.DataOutFile.FileSizeLow then
        begin
          tmpDataBuf := tmpServer.CheckOutDataOutBuffer(AClient);
          if nil <> tmpDataBuf then
          begin        
            tmpReadSize := 0;
            if (tmpHttpSession.Base.DataOutFile.FileSizeLow - tmpHttpSession.Base.DataOutFile.FilePosition + 2) <=
               (tmpDataBuf.BufferHead.BufferSize - tmpDataBuf.BufferHead.DataLength) then
            begin
              Windows.ReadFile(tmpHttpSession.Base.DataOutFile.FileHandle,
                  tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength],
                  tmpHttpSession.Base.DataOutFile.FileSizeLow,
                  tmpReadSize,
                  nil);
              tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + tmpReadSize;
              tmpHttpSession.Base.DataOutFile.FilePosition := tmpHttpSession.Base.DataOutFile.FilePosition + tmpReadSize;
              tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength] := #13;
              tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength + 1] := #10;
              tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + 2;
              WinFileClose(tmpHttpSession.Base.DataOutFile);
              CheckInWinFile(tmpHttpSession.Base.DataOutFile);
              tmpHttpSession.Base.DataOutFile := nil;
              tmpServer.SendDataOut(AClient, tmpDataBuf);
            end else
            begin      
              Windows.ReadFile(tmpHttpSession.Base.DataOutFile.FileHandle,
                tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength],
                tmpDataBuf.BufferHead.BufferSize - tmpDataBuf.BufferHead.DataLength,
                tmpReadSize,
                nil);
              if 0 < tmpReadSize then
              begin
                tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + tmpReadSize;
                tmpHttpSession.Base.DataOutFile.FilePosition := tmpHttpSession.Base.DataOutFile.FilePosition + tmpReadSize;
                tmpServer.SendDataOut(AClient, tmpDataBuf);
              end else
              begin
                // close client handle ???
              end;
            end;
          end;
        end else
        begin      
          tmpDataBuf := tmpServer.CheckOutDataOutBuffer(AClient);
          if nil <> tmpDataBuf then
          begin                                                         
            WinFileClose(tmpHttpSession.Base.DataOutFile);
            CheckInWinFile(tmpHttpSession.Base.DataOutFile);
            tmpHttpSession.Base.DataOutFile := nil;
            tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength] := #13;
            tmpDataBuf.Data[tmpDataBuf.BufferHead.DataLength + 1] := #10;
            tmpDataBuf.BufferHead.DataLength := tmpDataBuf.BufferHead.DataLength + 2;
            tmpServer.SendDataOut(AClient, tmpDataBuf);
          end;
        end;
      end else
      begin

      end;
    end;
  end;
end;

end.
