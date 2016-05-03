unit win.clientsocket;

interface

uses
  Winsock2, base.netclient;
  
type
  PWinNetClient           = ^TWinNetClient;
  TWinNetClient           = packed record    
    DataType              : integer;
    ConnectSocketHandle   : Winsock2.TSocket;  
    TimeOutConnect        : Integer; //��λ���� (>0 ֵ��Ч)
    TimeOutRead           : Integer; //��λ����
    TimeOutSend           : Integer; //��λ����
    LastErrorCode         : Integer;
    ConnectAddress        : PNetServerAddress;
  end;

implementation

end.
