unit win.iocp;

interface

uses
  Windows;
  
type
  PWinIocp    = ^TWinIocp;    
  TWinIocp    = record
    Handle    : THandle;
  end;

  function InitWinIocp(AIocp: PWinIocp): Boolean;
  function IsValidWinIocp(AIocp: PWinIocp): Boolean;

  function BindWinIocp(AHandle: THandle; AIocp: PWinIocp): Boolean;

implementation

uses
  win.error;
  
function InitWinIocp(AIocp: PWinIocp): Boolean;
begin
  if not IsValidWinIocp(AIocp) then
  begin
    AIocp.Handle := CreateIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
  end;   
  Result := IsValidWinIocp(AIocp);
end;

function IsValidWinIocp(AIocp: PWinIocp): Boolean;
begin
  Result := not ((0 = AIocp.Handle) or (INVALID_HANDLE_VALUE = AIocp.Handle));
end;

function BindWinIocp(AHandle: THandle; AIocp: PWinIocp): Boolean;
begin
  Result := false;
  if nil = AIocp then
    exit;
  Result := 0 <> Windows.CreateIoCompletionPort(AHandle, AIocp.Handle, 1, 0);
  if not Result then
  begin
    GlobalLastError.LastError := Windows.GetLastError;
  end;
end;

end.
