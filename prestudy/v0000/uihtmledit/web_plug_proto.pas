unit web_plug_proto;

interface

uses
   atmcmbaseconst, wintype, dll_UrlMon, Intf_UrlMon, dll_ole32,
   Intf_olefactory, Intf_ole32;

type
  TOleClassFactory = class(TObject, IUnknown, IClassFactory, IInternetProtocol, IInternetProtocolRoot)
  protected
    {IUnknown}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    {IClassFactory}
    function CreateInstance(const unkOuter: IUnknown; const iid: TIID;
      out obj): HResult; stdcall;
    function LockServer(fLock: BOOL): HResult; stdcall;
    {IInternetProtocol}
    function Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
    function LockRequest(dwOptions: DWORD): HResult; stdcall;
    function UnlockRequest: HResult; stdcall;
    {IInternetProtocolRoot}
    function Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
      OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
    function Continue(const ProtocolData: TProtocolData): HResult; stdcall;
    function Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
    function Terminate(dwOptions: DWORD): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
  public
  end;

  PGlobal = ^TGlobal;
  TGlobal = record
    InternetSession : IInternetSession;
    Factory         : TOleClassFactory;
  end;

  procedure InitGlobal(AGlobal: PGlobal);

implementation

uses
  winconst_error;

procedure InitGlobal(AGlobal: PGlobal);
var
  guid: TGUID;
begin
  if AGlobal.InternetSession = nil then
    CoInternetGetSession(0, AGlobal.InternetSession, 0);
  if CoCreateGuid(guid) = S_OK then
  begin
    AGlobal.InternetSession.RegisterNameSpace(AGlobal.Factory, guid{Class_EWBAx}, 'http', 0, nil, 0);
    AGlobal.InternetSession.RegisterNameSpace(AGlobal.Factory, guid{Class_EWBAx}, 'file', 0, nil, 0);
  end;
end;

function TOleClassFactory.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then
  begin
    Result := S_OK;
  end else
  begin
    Result := E_NOINTERFACE;
  end;
end;

function TOleClassFactory._AddRef: Integer; stdcall;
begin
  Result := 1;
end;

function TOleClassFactory._Release: Integer; stdcall;
begin
  Result := 1;
end;

{IClassFactory}
function TOleClassFactory.CreateInstance(const unkOuter: IUnknown; const iid: TIID;
  out obj): HResult; stdcall;
//var
//  returnobj: TEWBAx;
begin
//  returnobj := TEWBAx.Create;
//  if Supports(returnobj, iid, obj) then
    Result := S_OK
//  else
//    Result := S_False;
//  if Result = S_False then
//  begin
//    returnobj.Free;
//  end;
end;

function TOleClassFactory.LockServer(fLock: BOOL): HResult; stdcall;
begin
  Result := S_OK;
end;

{IInternetProtocol}
function TOleClassFactory.Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
var
  finished: Boolean;
begin
  if finished then
  begin
    //数据全部下载完成
    Result := S_False;
//    FProtocolSink.ReportResult(S_OK, 0, nil);
  end else
  begin
  { 通知IE读取更多的数据 }
    Result := S_OK;
    cbRead := 0; // read data
  end;
end;

function TOleClassFactory.Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
begin
//  Result := E_NOTIMPL;
  Result := E_Fail;
end;

function TOleClassFactory.LockRequest(dwOptions: DWORD): HResult; stdcall;
begin
  Result := S_OK;
end;

function TOleClassFactory.UnlockRequest: HResult; stdcall;
begin
  Result := S_OK;
end;

{IInternetProtocolRoot}
function TOleClassFactory.Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
  OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
var
  SrvProvider: IServiceProvider;
  iNeg: Pointer;
begin
//  FProtocolSink := OIProtSink;
//  FBindInfo := OIBindInfo;
  (OIProtSink as iUnknown).QueryInterface(IServiceProvider, SrvProvider);
//  SrvProvider.QueryService(IID_IHTTPNegotiate, IID_IHTTPNegotiate, iNeg);
  if Assigned(iNeg) then
  begin
//    szHeaders := nil;
//    szAdditionalHeaders := nil;
//    iNeg.BeginningTransaction(szUrl, szHeaders, 0, szAdditionalHeaders);
  end;
  if True then
  begin
    // handle by self
    Result := S_OK; //Success
  end else
  begin
    Result := INET_E_USE_DEFAULT_PROTOCOLHANDLER;  
  end;
end;

function TOleClassFactory.Continue(const ProtocolData: TProtocolData): HResult; stdcall;
begin
  Result := S_OK;
end;

function TOleClassFactory.Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TOleClassFactory.Terminate(dwOptions: DWORD): HResult; stdcall;
begin
  Result := S_OK;
end;

function TOleClassFactory.Suspend: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TOleClassFactory.Resume: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

end.
