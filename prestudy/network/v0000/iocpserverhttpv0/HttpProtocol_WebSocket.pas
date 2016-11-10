unit HttpProtocol_WebSocket;

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
    //======================================
    (*//
    http://baike.baidu.com/link?url=xoViP-xBxZtadNNM_kn9w-SmwMtmorfwG16W-No_to_Pe965-
      omk8NLQ3SjMKRDhJDnJs54HlqkzVfdDq-Qw8X__PQhFY3xzDR8xBYbgNwq
    //*)   
    //======================================
    (*//
     GET /websocket HTTP/1.1#$D#$A
     Host: localhost:7785#$D#$A
     Connection: Upgrade#$D#$A
     Pragma: no-cache#$D#$A
     Cache-Control: no-cache#$D#$A
     Upgrade: websocket#$D#$A
     Origin: http://deal.com#$D#$A
     Sec-WebSocket-Version: 13'#$D#$A
     User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64)
                 AppleWebKit/537.36 (KHTML, like Gecko)
                 Chrome/54.0.2840.71 Safari/537.36'#$D#$A
     Accept-Encoding: gzip, deflate, sdch, br#$D#$A
     Accept-Language: zh-CN,zh;q=0.8#$D#$A
     Cookie: Hm_lvt_7c3a8b33688e717fde23187a359d7bad=1470116815;
             _jzqa=1.297879906954211200.1470116816.1470116816.1470116816.1;
             _qzja=1.735691871.1470116815633.1470116815633.1470116815635.1470116815633.1470116815635..0.0.1.1;
             _ga=GA1.1.1425599062.1470116817'#$D#$A
     Sec-WebSocket-Key: hAv1ylgsJU+wANhdd0iXBA=='#$D#$A
     Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits'#$D#$A#$D#$A
    //*)     
    (*//
    用 Sec-WebSocket-Key字符串 + 258EAFA5-E914-47DA-95CA-C5AB0DC85B11
    使用SHA-1加密
    之后进行BASE-64编码
    
    Sec-WebSocket-Accept: K7DJLdLooIwIG/MOpvWFB3y3FE8=
    //*)
    //======================================
    (*//
    GET /demo HTTP/1.1 
    Host: example.com
    Connection: Upgrade
    Sec-WebSocket-Key2: 12998 5 Y3 1 .P00
    Upgrade: WebSocket
    Sec-WebSocket-Key1: 4@1 46546xW%0l 1 5
    Origin: http://example.com
    [8-byte security key]
    //*)
    (*//
    http://blog.163.com/soda_water05/blog/static/21283223520141190037863/
    Sec-WebSocket-Key1，Sec-WebSocket-Key2 和 [8-byte security key]
    这几个头信息是 WebSocket 服务器用来生成应答信息的来源，
    依据 draft-hixie-thewebsocketprotocol-76 草案

    逐个字符读取 Sec-WebSocket-Key1 头信息中的值，将数值型字符连接到一起放到一个临时字符串里
    同时统计所有空格的数量；
    将在第 1 步里生成的数字字符串转换成一个整型数字，然后除以第 1 步里统计出来的空格数量
    将得到的浮点数转换成整数型；
    将第 2 步里生成的整型值转换为符合网络传输的网络字节数组；
    对 Sec-WebSocket-Key2 头信息同样进行第 1 到第 3 步的操作，得到另外一个网络字节数组；
    将 [8-byte security key] 和在第 3，第 4 步里生成的网络字节数组合并成一个 16 字节的数组
    对第 5 步生成的字节数组使用 MD5 算法生成一个哈希值，这个哈希值就作为安全密钥返回给客户端
    以表明服务器端获取了客户端的请求，同意创建 WebSocket 连接
    //*)
    //======================================
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
    tmpAnsi := 'HTTP/1.1 101 Switching Protocols' + #13#10 +
                 'Upgrade: websocket' + #13#10 +
                 'Connection: Upgrade' + #13#10 +
                 'Sec-WebSocket-Accept: K7DJLdLooIwIG/MOpvWFB3y3FE8=' + #13#10 +
                 #13#10;
    Windows.InterlockedIncrement(Count);

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
(*//
<html> 
    <head> 
        <title>WebSoket Demo</title> 
        <script type="text/javascript"> 
            //验证浏览器是否支持WebSocket协议
            if (!window.WebSocket) { 
                alert("WebSocket not supported by this browser!"); 
            } 
             var ws;
            function display() { 
                //var valueLabel = document.getElementById("valueLabel"); 
                //valueLabel.innerHTML = ""; 
                ws=new WebSocket("ws://localhost:7785/websocket"); 
                //监听消息
                ws.onmessage = function(event) { 
                    //valueLabel.innerHTML+ = event.data; 
                    log(event.data);
                }; 
                // 打开WebSocket 
                ws.onclose = function(event) { 
                  //WebSocket Status:: Socket Closed
                }; 
                // 打开WebSocket
                ws.onopen = function(event) { 
                   //WebSocket Status:: Socket Open
                    //// 发送一个初始化消息
                    ws.send("Hello, Server!"); 
                }; 
                ws.onerror =function(event){
                    //WebSocket Status:: Error was reported
                };
            } 
            var log = function(s) {  
   if (document.readyState !== "complete") {  
       log.buffer.push(s);  
   } else {  
       document.getElementById("contentId").innerHTML += (s + "\n");  
   }  
}  
            function sendMsg(){
                var msg=document.getElementById("messageId");
                //alert(msg.value);
                ws.send(msg.value); 
            }
        </script> 
    </head> 
    <body onload="display();"> 
        <div id="valueLabel"></div> 
        <textarea rows="20" cols="30" id="contentId"></textarea>
        <br/>
        <input name="message" id="messageId"/>
        <button id="sendButton" onClick="javascript:sendMsg()" >Send</button>
    </body> 
</html> 
//*)
end.
