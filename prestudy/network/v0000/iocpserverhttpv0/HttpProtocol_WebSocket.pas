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
    �� Sec-WebSocket-Key�ַ��� + 258EAFA5-E914-47DA-95CA-C5AB0DC85B11
    ʹ��SHA-1����
    ֮�����BASE-64����
    
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
    Sec-WebSocket-Key1��Sec-WebSocket-Key2 �� [8-byte security key]
    �⼸��ͷ��Ϣ�� WebSocket ��������������Ӧ����Ϣ����Դ��
    ���� draft-hixie-thewebsocketprotocol-76 �ݰ�

    ����ַ���ȡ Sec-WebSocket-Key1 ͷ��Ϣ�е�ֵ������ֵ���ַ����ӵ�һ��ŵ�һ����ʱ�ַ�����
    ͬʱͳ�����пո��������
    ���ڵ� 1 �������ɵ������ַ���ת����һ���������֣�Ȼ����Ե� 1 ����ͳ�Ƴ����Ŀո�����
    ���õ��ĸ�����ת���������ͣ�
    ���� 2 �������ɵ�����ֵת��Ϊ�������紫��������ֽ����飻
    �� Sec-WebSocket-Key2 ͷ��Ϣͬ�����е� 1 ���� 3 ���Ĳ������õ�����һ�������ֽ����飻
    �� [8-byte security key] ���ڵ� 3���� 4 �������ɵ������ֽ�����ϲ���һ�� 16 �ֽڵ�����
    �Ե� 5 �����ɵ��ֽ�����ʹ�� MD5 �㷨����һ����ϣֵ�������ϣֵ����Ϊ��ȫ��Կ���ظ��ͻ���
    �Ա����������˻�ȡ�˿ͻ��˵�����ͬ�ⴴ�� WebSocket ����
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
      if iErrCode = WSAECONNRESET then //�ͻ��˱��ر�
      begin

      end;    
    end;
  end;
end;

{ http Э��
http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html
http://host[":"port][abs_path]
=====================================================
GET     �����ȡRequest-URI����ʶ����Դ
POST    ��Request-URI����ʶ����Դ�󸽼��µ�����
HEAD    �����ȡ��Request-URI����ʶ����Դ����Ӧ��Ϣ��ͷ
PUT     ����������洢һ����Դ������Request-URI��Ϊ���ʶ
DELETE  ���������ɾ��Request-URI����ʶ����Դ
TRACE   ��������������յ���������Ϣ����Ҫ���ڲ��Ի����
CONNECT ��������ʹ��
OPTIONS �����ѯ�����������ܣ����߲�ѯ����Դ��ص�ѡ�������
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
}
(*//
<html> 
    <head> 
        <title>WebSoket Demo</title> 
        <script type="text/javascript"> 
            //��֤������Ƿ�֧��WebSocketЭ��
            if (!window.WebSocket) { 
                alert("WebSocket not supported by this browser!"); 
            } 
             var ws;
            function display() { 
                //var valueLabel = document.getElementById("valueLabel"); 
                //valueLabel.innerHTML = ""; 
                ws=new WebSocket("ws://localhost:7785/websocket"); 
                //������Ϣ
                ws.onmessage = function(event) { 
                    //valueLabel.innerHTML+ = event.data; 
                    log(event.data);
                }; 
                // ��WebSocket 
                ws.onclose = function(event) { 
                  //WebSocket Status:: Socket Closed
                }; 
                // ��WebSocket
                ws.onopen = function(event) { 
                   //WebSocket Status:: Socket Open
                    //// ����һ����ʼ����Ϣ
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
