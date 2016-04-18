unit service.test;

interface

uses
  Types,
  WinSvc,
  win.app,
  win.service;

var
  GlobalApp: TWinApp;
  GlobalServiceApp: TWinServiceAppW;   
  GlobalService: TWinServiceProcW;

  procedure ServiceHandler_TestProc(CtrlCode: DWORD); stdcall;
  
implementation

procedure ServiceHandler_TestProc(CtrlCode: DWORD); stdcall;
begin
  if WinSvc.SERVICE_CONTROL_STOP = CtrlCode then
  begin
    //WinSvc.SetServiceStatus();
    //success := ReportStatus(SERVICE_STOP_PENDING, NO_ERROR,0,1,5000);

    //CloseTask();

    //success := ReportStatus(SERVICE_STOPPED, NO_ERROR,0,0,0);
    exit;
  end;  
  if WinSvc.SERVICE_CONTROL_PAUSE = CtrlCode then//          = $00000002;
  begin
    exit;
  end;
  if WinSvc.SERVICE_CONTROL_CONTINUE = CtrlCode then//       = $00000003;
  begin
    exit;
  end;
  if WinSvc.SERVICE_CONTROL_INTERROGATE = CtrlCode then//    = $00000004;
  begin
    // Ҫ�������ϱ�������״̬
    exit;
  end;
  if WinSvc.SERVICE_CONTROL_SHUTDOWN = CtrlCode then//       = $00000005;
  begin
    // ���߷��񼴽��ػ�
    exit;
  end;
end;

end.
