unit win.x64;

interface
                   
  function DisableWowRedirection: Boolean;     
  function RevertWowRedirection: Boolean;

implementation

uses
  Windows;

function IsWin64: boolean;
var 
  Kernel32Handle: THandle;   
  IsWow64Process: function(Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;   
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;   
  isWoW64: Bool;   
  SystemInfo: TSystemInfo;   
const 
  PROCESSOR_ARCHITECTURE_AMD64 = 9;   
  PROCESSOR_ARCHITECTURE_IA64 = 6;
begin 
  Result := False;
  Kernel32Handle := GetModuleHandle('KERNEL32.DLL');
  if Kernel32Handle = 0 then
    Kernel32Handle := LoadLibrary('KERNEL32.DLL');
  if Kernel32Handle <> 0 then
  begin
    IsWOW64Process := GetProcAddress(Kernel32Handle,'IsWow64Process');
    //GetNativeSystemInfo������Windows XP��ʼ���У���IsWow64Process������Windows XP SP2�Լ�Windows Server 2003 SP1��ʼ���С�
    //����ʹ�øú���ǰ�����GetProcAddress��
    GetNativeSystemInfo := GetProcAddress(Kernel32Handle,'GetNativeSystemInfo');
    if Assigned(IsWow64Process) then
    begin
      IsWow64Process(GetCurrentProcess, isWoW64);
      Result := isWoW64 and Assigned(GetNativeSystemInfo);
      if Result then
      begin
        GetNativeSystemInfo(SystemInfo);
        Result := (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) or
                  (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);
      end;
    end;
  end;
end;  
(*//
��64λWindowsϵͳ�����е�32λ����ᱻϵͳ��ƭ.
����windows\system32��Ŀ¼ʵ����windows\syswow64Ŀ¼��ӳ��.
program filesʵ����program files(x86)��ӳ��.

ע����hkey_local_machine\softwareʵ����hkey_local_machine\software\wow6432node�Ӽ���ӳ��.
��ô��η��ʵ�������64λ�����Ŀ¼��ע�����?

�ص�Ŀ¼�ض��򼴿�.
�ر��ļ����ض���
//*)
function DisableWowRedirection: Boolean;
type
  TWow64DisableWow64FsRedirection = function(var Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
var
  tmpHandle: THandle;
  Wow64DisableWow64FsRedirection: TWow64DisableWow64FsRedirection;
  OldWow64RedirectionValue: LongBool;
begin
  Result := true;
  try
    tmpHandle := GetModuleHandle('kernel32.dll');
    if (0 <> tmpHandle) then
    begin
      @Wow64DisableWow64FsRedirection := GetProcAddress(tmpHandle, 'Wow64DisableWow64FsRedirection');
      if (nil <> @Wow64DisableWow64FsRedirection) then
      begin
        Wow64DisableWow64FsRedirection(OldWow64RedirectionValue);
      end;
    end;
  except
    Result := False;
  end;
 end;
 
function RevertWowRedirection: Boolean;
type
  TWow64RevertWow64FsRedirection = function(var Wow64RevertWow64FsRedirection: LongBool): LongBool; stdcall;
var
  tmpHandle: THandle;
  Wow64RevertWow64FsRedirection: TWow64RevertWow64FsRedirection;  
  OldWow64RedirectionValue: LongBool;
begin
  Result := true;
  try
    tmpHandle := GetModuleHandle('kernel32.dll');
    @Wow64RevertWow64FsRedirection := GetProcAddress(tmpHandle, 'Wow64RevertWow64FsRedirection');
    if (0 <> tmpHandle) then
    begin
      if (nil <> @Wow64RevertWow64FsRedirection) then
      begin              
        Wow64RevertWow64FsRedirection(OldWow64RedirectionValue);
      end;
    end;
  except
    Result := False;
  end;
end;

(*//
ע���ͺܼ���.
var
  r: TRegistry;
begin
  r := TRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.Access := r.Access or KEY_WOW64_64KEY; //ע����һ��.
  if r.OpenKey('SOFTWARE\abc', true) then
  begin
    r.WriteString('test', 'test');
  end;
  r.Free;
end;
//*)

end.
