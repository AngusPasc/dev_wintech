unit win.service_install;

interface

uses
  win.service;
                    
  procedure InstallWinService(AWinService: PWinServiceW); overload;
  procedure InstallWinService(AWinService: PWinServiceW; ASvcMgr: Integer); overload;

  procedure UninstallWinService(AWinService: PWinServiceW); overload;
  procedure UninstallWinService(AWinService: PWinServiceW; ASvcMgr: Integer); overload;
   
implementation
            
uses
  WinSvc,
  Windows,
  SysUtils,
  UtilsLog;
                     
procedure InstallWinService(AWinService: PWinServiceW; ASvcMgr: Integer);
var
  tmpPath: WideString;
  tmpPSSN: PWideChar;  
  tmpTagID: Integer;
  tmpPTag: Pointer;
  tmpStartType: integer;
  tmpServiceType: integer;
  tmpErrorSeverity: integer;
begin                 
  Log('win.service.pas', 'InstallWinService begin:');
  tmpPath := ParamStr(0);
  if AWinService.ServiceStartName = '' then
    tmpPSSN := nil
  else
    tmpPSSN := PWideChar(AWinService.ServiceStartName);
                  
  tmpTagID := AWinService.TagID;
  if tmpTagID > 0 then
    tmpPTag := @tmpTagID
  else
    tmpPTag := nil;

  tmpServiceType := GetNTServiceType(AWinService);
  tmpStartType:= GetNTStartType(AWinService);
  tmpErrorSeverity := GetNTErrorSeverity(AWinService);

  AWinService.ServiceHandle := WinSvc.CreateServiceW(ASvcMgr,
        PWideChar(@AWinService.Name[0]),
        PWideChar(@AWinService.DisplayName[0]),
        SERVICE_ALL_ACCESS,
        tmpServiceType,
        tmpStartType,
        tmpErrorSeverity,
        PWideChar(tmpPath),
        nil,//PWideChar(AServiceProc.LoadGroup),
        tmpPTag,
        nil, //PWideChar(GetNTDependenciesW(AWinService)),
        tmpPSSN,
        nil //PWideChar(AServiceProc.Password)
        );
  if 0 = AWinService.ServiceHandle then
  begin
    Log('', 'CreateServiceW Error');
    AWinService.LastError := Windows.GetLastError;
    if 0 <> AWinService.LastError then
    begin                   
      Log('', 'CreateServiceW Error Code:' + IntToStr(AWinService.LastError));
      if ERROR_ALREADY_EXISTS = AWinService.LastError  then // 183
      begin
      end;
      if ERROR_INVALID_SERVICE_ACCOUNT = AWinService.LastError then// 1057
      begin
      end;
    end else
    begin
      Log('', 'CreateServiceW Error Code 0');
    end;
  end else
  begin       
    Log('', 'CreateServiceW Succ');
    WinSvc.CloseServiceHandle(AWinService.ServiceHandle);
  end;
  Log('win.service.pas', 'InstallWinService end');    
end;

procedure InstallWinService_Reg(AWinService: PWinServiceW);
begin
  // HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services
  //   DisplayName -- String
  // Description�ַ���ֵ����Ӧ��������
  // ImagePath �ַ���ֵ����Ӧ�÷���������ڵ�·��
  // ObjectName �ַ���ֵ��ֵΪ"LocalSystem"����ʾ���ص�¼
  // ErrorControl Dwordֵ��ֵΪ"1"
  // Start Dwordֵ��ֵΪ2��ʾ�Զ����У�ֵΪ3��ʾ�ֶ����У�ֵΪ4��ʾ��ֹ
  // Type Dwordֵ��Ӧ�ó����Ӧ10��������Ӧ20
end;

procedure InstallWinService(AWinService: PWinServiceW);
var
  tmpSvcMgr: integer;
begin                  
  Log('', 'InstallWinService begin');
  //windows �ֶ���ӷ���
  //����һ���޸�ע���
  tmpSvcMgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if 0 <> tmpSvcMgr then
  begin
    try
      InstallWinService(AWinService, tmpSvcMgr);
    finally
      CloseServiceHandle(tmpSvcMgr);
    end;
  end;
  Log('', 'InstallWinService end');  
end;

procedure UninstallWinService(AWinService: PWinServiceW; ASvcMgr: Integer);
begin
  Log('', 'UninstallWinService begin');
  AWinService.ServiceHandle := OpenServiceW(ASvcMgr, PWideChar(@AWinService.Name[0]), SERVICE_ALL_ACCESS);
  if 0 = AWinService.ServiceHandle then
  begin
    //RaiseLastOSError;
  end;
  try
    if not WinSvc.DeleteService(AWinService.ServiceHandle) then
    begin
      //RaiseLastOSError;
    end;
  finally
  end;    
  Log('', 'UninstallWinService end');
end;

procedure UninstallWinService(AWinService: PWinServiceW);
var
  tmpSvcMgr: Integer;
begin
  Log('', 'UninstallWinService begin');        
  tmpSvcMgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  try
    UninstallWinService(nil, tmpSvcMgr);
  finally
    WinSvc.CloseServiceHandle(tmpSvcMgr);
  end;
  Log('', 'UninstallWinService end');  
end;                                                 

end.
