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
      tmpAnsi := 'HTTP/1.1 200 OK' + #13#10 +  // ״̬��      
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
      tmpAnsi := 'HTTP/1.1 404 Not Found' + #13#10 +  // ״̬��      
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
end.
