unit xlClientSocket;

interface

uses
  Winsock2;
  
type
  PxlNetServerAddress     = ^TxlNetServerAddress;
  TxlNetServerAddress     = record
    DataType              : integer;
    Host                  : AnsiString;
    Ip                    : AnsiString;
    Port                  : Word;
  end;

  PxlNetClient            = ^TxlNetClient;
  TxlNetClient            = packed record    
    DataType              : integer;
    ConnectSocketHandle   : Winsock2.TSocket;  
    TimeOutConnect        : Integer; //��λ���� (>0 ֵ��Ч)
    TimeOutRead           : Integer; //��λ����
    TimeOutSend           : Integer; //��λ����
    LastErrorCode         : Integer;
    ConnectAddress        : PxlNetServerAddress;
  end;

implementation

end.
