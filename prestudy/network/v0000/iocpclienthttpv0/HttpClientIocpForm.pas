unit HttpClientIocpForm;

interface

uses
  Windows, Forms, SysUtils,
  Classes, Controls, StdCtrls,
  BaseForm,
  NetBaseObj,
  NetObjClient;

type
  TfrmHttpClientIocp = class(TfrmBase)
    edtIp: TEdit;
    edtPort: TEdit;
    btnConnect: TButton;
    mmo1: TMemo;
    btnSend: TButton;
    edtSendData: TEdit;
    mmo2: TMemo;
    btnDisconnect: TButton;
    procedure btnSendClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  NetClientIocp,
  NetObjClientProc,
  HttpClientIocpApp;

var
  Client: PNetClientIocp = nil;
  ServerAddr: TNetServerAddress;
  SendDataBuffer: array[0..4 * 1024 - 1] of Byte;
  
procedure TfrmHttpClientIocp.btnConnectClick(Sender: TObject);
begin
  inherited;
  if nil <> Self.App then
  begin
    if nil = Client then
    begin
      Client := THttpClientIocpApp(Self.App).NetMgr.CheckOutNetClient;
    end;
    ServerAddr.Host := edtIp.Text;
    ServerAddr.Port := StrToIntDef(edtPort.text, 7785);
    NetClientIocp.NetClientConnect(Client, @ServerAddr);
  end;
end;

procedure TfrmHttpClientIocp.btnDisconnectClick(Sender: TObject);
begin
  inherited;
  if nil <> Client then
  begin
    NetClientIocp.NetClientDisconnect(Client);
  end;
end;

procedure TfrmHttpClientIocp.btnSendClick(Sender: TObject);
var
  tmpSendLength: integer;
  tmpSendCount: integer;
  tmpAnsi: AnsiString; 
begin
  inherited;
  if nil <> Client then
  begin
    FillChar(SendDataBuffer, SizeOf(SendDataBuffer), 0);
    tmpAnsi := Trim(edtSendData.text);
                          
    tmpSendLength := Length(tmpAnsi);
    CopyMemory(@SendDataBuffer[0], @tmpAnsi[1], tmpSendLength);
    
    tmpSendCount := 0;
    NetClientIocp.NetClientSendBuf(Client, @SendDataBuffer[0], tmpSendLength, tmpSendCount);
  end;
//
end;

end.
