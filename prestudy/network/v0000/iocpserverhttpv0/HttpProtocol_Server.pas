unit HttpProtocol_Server;

interface

uses
  NetHttpServerClientConnectIocp;
  
  procedure DoHandleHttpClientDataIn(AIocpBuffer: PNetIocpBuffer);
  
implementation

uses
  Windows,
  WinSock2,
  BaseDataIO,
  SysUtils;
             
var
  Count: integer = 1;
  
procedure DoHandleHttpClientDataIn(AIocpBuffer: PNetIocpBuffer);
var
  tmpWriteBuffer: PNetIocpBuffer;
  tmpAnsi: AnsiString;
  i: integer;
  tmpLastPos: integer;
  tmpStep: integer;
  tmpMethod: AnsiString;
  tmpPath: AnsiString;  
  tmpCompleteKey: DWORD;   
  iFlags: DWORD;
  iTransfer: DWORD;
  tmpBufferCount: DWORD; 
  iErrCode: Integer;
begin                        
  tmpWriteBuffer := nil;//AIocpBuffer.ClientConnect.WriteBuffer;
  if nil <> AIocpBuffer.DataBufferPtr then
  begin            
    tmpMethod := '';
    tmpPath := '';
    tmpStep := 0;
    tmpAnsi := PAnsiChar(@AIocpBuffer.DataBufferPtr.Data[0]);  
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
    iFlags := 0;
    iTransfer := 0;
    if '/' = tmpPath then
    begin
      tmpAnsi := 'HTTP/1.1 200 OK' + #13#10 +  // 状态行      
               'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
               'Server: Apache' + #13#10 +
               'Content-Type: text/html' + #13#10 +
               //'Connection: keep-alive' + #13#10 +
               'Connection: close' + #13#10 +
               #13#10 +
               '<html>' +
                 '<head></head>' +
                 '<body>' + FormatDateTime('yyyy mmdd hhnnss', now) + '_' + inttostr(Count) + '</body>' +
               '</html>' +
               #13#10 +  
               #13#10;        
      Windows.InterlockedIncrement(Count);
    end else
    begin
      tmpAnsi := 'HTTP/1.1 404 Not Found' + #13#10 +  // 状态行      
               'Date: Fri, 04 Dec 2015 08:27:25 GMT' + #13#10 +
               'Server: Apache' + #13#10 +   
               #13#10 +
               #13#10;
    end;

    tmpWriteBuffer := System.New(PNetIocpBuffer);
    FillChar(tmpWriteBuffer^, SizeOf(TNetIocpBuffer), 0);
    tmpWriteBuffer.DataBufferPtr := System.New(BaseDataIO.PDataBuffer);
    FillChar(tmpWriteBuffer.DataBufferPtr^, SizeOf(TDataBuffer), 0); 

    CopyMemory(@tmpWriteBuffer.DataBufferPtr.Data[0], @tmpAnsi[1], Length(tmpAnsi));                          


    tmpWriteBuffer.ClientConnect := AIocpBuffer.ClientConnect;
            
    tmpWriteBuffer.IocpOperate := ioSockWrite;
    tmpWriteBuffer.WsaBuf.len := Length(tmpWriteBuffer.DataBufferPtr.Data);
    tmpWriteBuffer.WsaBuf.len := 4096;
    tmpWriteBuffer.WsaBuf.len := Length(tmpAnsi);
    tmpWriteBuffer.WsaBuf.buf := @tmpWriteBuffer.DataBufferPtr.Data[0];
    
    tmpBufferCount := 1;  
    iTransfer := 0;
    iFlags := MSG_PARTIAL;
    iFlags := MSG_OOB;
    if SOCKET_ERROR = WinSock2.WSASend(tmpWriteBuffer.ClientConnect.BaseConnect.ClientSocketHandle,
        @tmpWriteBuffer.WsaBuf,
        tmpBufferCount,
        @iTransfer,
        iFlags,
        @tmpWriteBuffer.Overlapped, nil) then
    begin
      iErrCode := WSAGetLastError;
      if iErrCode = WSAECONNRESET then //客户端被关闭
      begin

      end;    
    end;
  end;
end;

{ http 协议
http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html
http://host[":"port][abs_path]
=====================================================
GET     请求获取Request-URI所标识的资源
POST    在Request-URI所标识的资源后附加新的数据
HEAD    请求获取由Request-URI所标识的资源的响应消息报头
PUT     请求服务器存储一个资源，并用Request-URI作为其标识
DELETE  请求服务器删除Request-URI所标识的资源
TRACE   请求服务器回送收到的请求信息，主要用于测试或诊断
CONNECT 保留将来使用
OPTIONS 请求查询服务器的性能，或者查询与资源相关的选项和需求
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
(CRLF)         //该CRLF表示消息报头已经结束，在此之前为消息报头
user=jeffrey&pwd=1234  //此行以下为提交的数据   
-----------------------------------------------------  
=====================================================
服务器返回一个HTTP响应消息

请求消息和响应消息都是由
  开始行（对于请求消息，开始行就是请求行，对于响应消息，开始行就是状态行），
  消息报头（可选），
  空行（只有CRLF的行），
  消息正文（可选）组成
            
HTTP响应也是由三个部分组成，分别是：状态行、消息报头、响应正文
HTTP-Version Status-Code Reason-Phrase CRLF
1xx：指示信息--表示请求已接收，继续处理
2xx：成功--表示请求已被成功接收、理解、接受
3xx：重定向--要完成请求必须进行更进一步的操作
4xx：客户端错误--请求有语法错误或请求无法实现
5xx：服务器端错误--服务器未能实现合法的请求
HTTP消息报头包括普通报头、请求报头、响应报头、实体报头
1、普通报头
  Cache-Control
  请求时的缓存指令包括 no-cache（用于指示请求或响应消息不能缓存）、no-store、max-age、max-stale、min-fresh、only-if-cached
  响应时的缓存指令包括：public、private、no-cache、no-store、no-transform、must-revalidate、proxy-revalidate、max-age、s-maxage
  Date
  Connection
2、请求报头
  Accept Accept-Charset Accept-Encoding Accept-Language
  Authorization
  Host
  User-Agent
3、响应报头
  Location Server WWW-Authenticate
4、实体报头
  Content-Encoding
  Content-Language
  Content-Length
  Content-Type   text/html;charset=GB2312
  Last-Modified
  Expires
=====================================================       
}
end.
