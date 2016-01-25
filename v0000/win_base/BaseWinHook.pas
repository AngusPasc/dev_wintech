unit BaseWinHook;

interface

uses
  Types, Windows, Messages;
  
type             
  PImportCode         = ^TImportCode;
  TImportCode         = packed record
    JumpInstruction   : Word;
    AddressOfPointerToFunction: PPointer;
  end;

  PImage_Import_Entry = ^TImage_Import_Entry;
  TImage_Import_Entry = record
    Characteristics   : DWORD;
    TimeDateStamp     : DWORD;
    MajorVersion      : Word;
    MinorVersion      : Word;
    Name              : DWORD;
    LookupTable       : DWORD;
  end;
  
  TLongJmp            = packed record
    JmpCode           : ShortInt; {ָ���$E9������ϵͳ��ָ��}
    FuncAddr          : DWORD; {������ַ}
  end;

  PHookRecord         = ^THookRecord;
  THookRecord         = record
    ProcessHandle     : Cardinal; {���̾����ֻ��������ʽ}
    Oldcode           : array[0..4]of byte; {ϵͳ����ԭ����ǰ5���ֽ�}
    OldFunction       : Pointer;
    NewFunction       : Pointer;{���غ������Զ��庯��}

    TrapMode          : Byte; {���÷�ʽ��True����ʽ��False�������ʽ}
    AlreadyHook       : boolean; {�Ƿ��Ѱ�װHook��ֻ��������ʽ}
    AllowChange       : boolean; {�Ƿ�����װ��ж��Hook��ֻ���ڸ������ʽ}
    Newcode           : TLongJmp; {��Ҫд��ϵͳ������ǰ5���ֽ�}
  end;

  PWinHook            = ^TWinHook;
  TWinHook            = record
    HookHandle        : HHOOK;
    HookThreadId      : DWORD;
  end;
  
  procedure HookRecordInitialize(AHookRecord: PHookRecord; IsTrap:boolean; OldFun, NewFun: pointer);
  procedure HookRecordChange(AHookRecord: PHookRecord);
  procedure HookRecordRestore(AHookRecord: PHookRecord);

  procedure OpenWinHook(AWinHook: PWinHook);
  procedure CloseWinHook(AWinHook: PWinHook);

implementation
               
const
  ProcID_BeginPaint   = 0;

type
  THookCore           = record
    MouseHook         : THandle;
    //ShareMem    : THookShareMem;
    StartHookProcessID: DWORD;
    Hooks             : array[ProcID_BeginPaint..ProcID_BeginPaint] of THookRecord;{API HOOK��}
  end;

var
  WinHook_Keyboard: TWinHook;
  WinHook_Mouse: TWinHook;
  WinHook_CallWndProc: TWinHook;
  WinHook_Shell: TWinHook;
    
function HookProc_Keyboard(ACode: integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  if (wParam = 65) then
  begin
    //Beep; {ÿ���ص���ĸ A �ᷢ��}
  end;
  Result := CallNextHookEx(WinHook_Keyboard.HookHandle, ACode, wParam, lParam);   
end;

{���Ӻ���, �����Ϣ̫��(Ʃ������ƶ�), ����Ҫ��ѡ��, ����ѡ��������������}   
function HookProc_Mouse(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  if wParam = WM_LBUTTONDOWN then
  begin
    MessageBeep(0);
  end;
  Result := CallNextHookEx(WinHook_Mouse.HookHandle, nCode, wParam, lParam);
end;
            
function HookProc_CALLWNDPROC(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  if(nCode < 0) then
  begin
    Result := CallNextHookEx(WinHook_CallWndProc.HookHandle, nCode, wParam, lParam);
    exit;
  end;
  if nCode <> HC_ACTION then
  begin
    Result := CallNextHookEx(WinHook_CallWndProc.HookHandle, nCode, wParam, lParam);
    exit;
  end;
  Result := CallNextHookEx(WinHook_CallWndProc.HookHandle, nCode, wParam, lParam);
end;

function HookProc_Shell(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  // HSHELL_ACCESSIBILITYSTATE
  // HSHELL_ACTIVATESHELLWINDOW
  // HSHELL_GETMINRECT
  // HSHELL_LANGUAGE
  // HSHELL_REDRAW
  // HSHELL_TASKMAN
  // HSHELL_WINDOWACTIVATED
  // HSHELL_WINDOWCREATED
  // HSHELL_WINDOWDESTROYED
  // HSHELL_ACCESSIBILITYSTATE
  if HSHELL_GETMINRECT = nCode then
  begin
  end;
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_SYSMSGFILTER(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  if MSGF_DIALOGBOX = nCode then
  begin
    // MSGF_MENU
    // MSGF_SCROLLBAR
    // MSGF_NEXTWINDOW  
  end;
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_CBT(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
{
    1������������٣���С������󻯣��ƶ����ı�ߴ�ȴ����¼���
����2���ϵͳָ�
��  3����ϵͳ��Ϣ�����е��ƶ���꣬�����¼���
����4�������뽹���¼���
����5ͬ��ϵͳ��Ϣ�����¼�
}
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_JournalRecord(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_JournalPlayBack(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_GetMessage(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_Hardware(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_Debug(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_ForegroundIdle(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
{
  ��Ӧ�ó����ǰ̨�̴߳��ڿ���״̬ʱ
  ����ʹ��WH_FOREGROUNDIDLEHookִ�е����ȼ�������
  ��Ӧ�ó����ǰ̨�̴߳��Ҫ��ɿ���״̬ʱ
  ϵͳ�ͻ����WH_FOREGROUNDIDLE Hook�ӳ�
}
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;

function HookProc_CallWndProcRet(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := CallNextHookEx(WinHook_Shell.HookHandle, nCode, wParam, lParam);
end;
(*
  �����ڶ�̬���ӿ��й���WH_GETMESSAGE
  ��Ϣ���ӣ��������Ľ��̷���WH_GETMESSAGE ��Ϣʱ����
  ��������ǵĶ�̬���ӿ⣬��������ǵ�DLL ����ʱ�Զ���
  ��API_Hook�����Ϳ����������Ľ��̹������ǵ�API Hook��
*)

// ��Ҫ��Hook��дMessageBox�Ⱥ����������ѭ���ģ����˳���������

procedure OpenWinHook(AWinHook: PWinHook);
begin
  AWinHook.HookHandle := Windows.SetWindowsHookEx(
      WH_MOUSE,
        // WH_JOURNALRECORD
        // WH_JOURNALPLAYBACK
        // WH_KEYBOARD        ���̹���
        // WH_GETMESSAGE
        // WH_CALLWNDPROC
        // WH_CBT             �̻߳�ϵͳ
        // WH_SYSMSGFILTER
        // WH_MOUSE
        // WH_HARDWARE
        // WH_DEBUG
        // WH_SHELL
        // WH_FOREGROUNDIDLE
        // WH_CALLWNDPROCRET
      nil, // HOOKPROC
      HInstance,
      AWinHook.HookThreadId  // ����ר�����ĳһ�߳� hook
      // GetCurrentThreadId
  );
end;

procedure CloseWinHook(AWinHook: PWinHook);
begin
  if UnhookWindowsHookEx(AWinHook.HookHandle) then
  begin
    AWinHook.HookHandle := 0;
  end;
end;

{ȡ������ʵ�ʵ�ַ����������ĵ�һ��ָ����Jmp����ȡ��������ת��ַ��ʵ�ʵ�ַ���������������ڳ����к���Debug������Ϣ�����}
function FinalFunctionAddress(Code: Pointer): Pointer;
Var
  func: PImportCode;
begin
  Result:=Code;
  if Code=nil then exit;
  try
    func:=code;
    if (func.JumpInstruction=$25FF) then
      {ָ���������FF 25  ���ָ��jmp [...]}
      Func:=func.AddressOfPointerToFunction^;
    result:=Func;
  except
    Result:=nil;
  end;
end;
          
var
  HookLibCore: THookCore;

{HOOK����ڣ�����IsTrap��ʾ�Ƿ��������ʽ}
procedure HookRecordInitialize(AHookRecord: PHookRecord; IsTrap:boolean; OldFun, NewFun: pointer);
begin
   {�󱻽غ������Զ��庯����ʵ�ʵ�ַ}
   AHookRecord.OldFunction := FinalFunctionAddress(OldFun);
   AHookRecord.NewFunction := FinalFunctionAddress(NewFun);

   if IsTrap then
     AHookRecord.TrapMode := 1
   else
     AHookRecord.TrapMode := 2;

   if 1 = AHookRecord.TrapMode then{���������ʽ}
   begin
      {����Ȩ�ķ�ʽ���򿪵�ǰ����}
      AHookRecord.ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS,FALSE, GetCurrentProcessID);
      {����jmp xxxx�Ĵ��룬��5�ֽ�}
      AHookRecord.Newcode.JmpCode := ShortInt($E9); {jmpָ���ʮ�����ƴ�����E9}
      AHookRecord.NewCode.FuncAddr := DWORD(AHookRecord.NewFunction) - DWORD(AHookRecord.OldFunction) - 5;
      {���汻�غ�����ǰ5���ֽ�}
      move(AHookRecord.OldFunction^, AHookRecord.OldCode, 5);
      {����Ϊ��û�п�ʼHOOK}
      AHookRecord.AlreadyHook:=false;
   end;
   {����Ǹ������ʽ��������HOOK}
   if 2 = AHookRecord.TrapMode then
   begin
     AHookRecord.AllowChange := true;
   end;
   HookRecordChange(AHookRecord); {��ʼHOOK}
   {����Ǹ������ʽ������ʱ������HOOK}
   if 2 = AHookRecord.TrapMode then
     AHookRecord.AllowChange := false;
end;

{��ʼHOOK}         
type
  PPatchedAddress = ^TPatchedAddress;
  TPatchedAddress = record
    Count: integer;
    Address: array[0..1024 - 1] of Pointer;
  end;

{�����������ָ�������ĵ�ַ��ֻ���ڸ������ʽ}
function PatchAddressInModule(BeenDone: PPatchedAddress; hModule: THandle; OldFunc,NewFunc: Pointer):integer;
const
  tmpSIZE = 4;
var
  tmpDos: PImageDosHeader;
  tmpNT: PImageNTHeaders;
  tmpImportDesc: PImage_Import_Entry;
  tmprva: DWORD;
  tmpFunc: PPointer;
  tmpDLL: String;
  tmpf: Pointer;
  tmpwritten: DWORD;
  tmpmbi_thunk:TMemoryBasicInformation;
  tmpdwOldProtect:DWORD;
  i: Integer;
begin
  Result:=0;
  if hModule=0 then
    exit;
  tmpDos := Pointer(hModule);
  {������DLLģ���Ѿ�����������˳���BeenDone�����Ѵ����DLLģ��}
  for i := 0 to BeenDone.Count - 1 do
  begin
    if BeenDone.Address[i] = tmpDos then
    begin
      exit;
    end;
  end;
  BeenDone.Address[BeenDone.Count] := tmpDos; {��DLLģ��������BeenDone}
  BeenDone.Count := BeenDone.Count + 1;
  
  OldFunc:=FinalFunctionAddress(OldFunc);{ȡ������ʵ�ʵ�ַ}

  {������DLLģ��ĵ�ַ���ܷ��ʣ����˳�}
  if IsBadReadPtr(tmpDos, SizeOf(TImageDosHeader)) then
    exit;
  {������ģ�鲻����'MZ'��ͷ����������DLL�����˳�}
  if tmpDos.e_magic<>IMAGE_DOS_SIGNATURE then
    exit;{IMAGE_DOS_SIGNATURE='MZ'}

  {��λ��NT Header}
  tmpNT := Pointer(Integer(tmpDos) + tmpdos._lfanew);
  {��λ�����뺯����}
  tmpRVA := tmpNT^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;

  if 0 = tmpRVA then
    exit;{������뺯����Ϊ�գ����˳�}
  {�Ѻ�����������Ե�ַRVAת��Ϊ���Ե�ַ}
  tmpImportDesc := pointer(DWORD(tmpDos) + tmpRVA);{Dos�Ǵ�DLLģ����׵�ַ}

  {�������б�������¼�DLLģ��}
  while (tmpImportDesc^.Name<>0) do
  begin
    {��������¼�DLLģ������}
    tmpDLL:=PChar(DWORD(tmpDos) + tmpImportDesc^.Name);
    {�ѱ�������¼�DLLģ�鵱����ǰģ�飬���еݹ����}
    PatchAddressInModule(BeenDone, GetModuleHandle(PChar(tmpDLL)),OldFunc,NewFunc);

    {��λ����������¼�DLLģ��ĺ�����}
    tmpFunc := Pointer(DWORD(tmpDOS) + tmpImportDesc.LookupTable);
    {������������¼�DLLģ������к���}
    while tmpFunc^<>nil do
    begin
      tmpf := FinalFunctionAddress(tmpFunc^);{ȡʵ�ʵ�ַ}
      if tmpf = OldFunc then {�������ʵ�ʵ�ַ������Ҫ�ҵĵ�ַ}
      begin
        VirtualQuery(tmpFunc, tmpmbi_thunk, sizeof(TMemoryBasicInformation));
        VirtualProtect(tmpFunc, tmpSIZE, PAGE_EXECUTE_WRITECOPY, tmpmbi_thunk.Protect);{�����ڴ�����}
        WriteProcessMemory(GetCurrentProcess, tmpFunc, @NewFunc, tmpSIZE, tmpwritten);{���º�����ַ������}
        VirtualProtect(tmpFunc, tmpSIZE, tmpmbi_thunk.Protect, tmpdwOldProtect);{�ָ��ڴ�����}
      end;
      if 4 = tmpWritten then
        Inc(Result);
//      else showmessagefmt('error:%d',[Written]);
      Inc(tmpFunc);{��һ�����ܺ���}
    end;
    Inc(tmpImportDesc);{��һ����������¼�DLLģ��}
  end;
end;

procedure HookRecordChange(AHookRecord: PHookRecord);
var
  tmpCount: DWORD;
  tmpBeenDone: TPatchedAddress;
begin
  if 1 = AHookRecord.TrapMode then{���������ʽ}
  begin
    if (AHookRecord.AlreadyHook) or
       (0 = AHookRecord.ProcessHandle) or
       (nil = AHookRecord.OldFunction) or
       (nil = AHookRecord.NewFunction) then
    begin
      exit;
    end;
    AHookRecord.AlreadyHook := true;{��ʾ�Ѿ�HOOK}
    WriteProcessMemory(AHookRecord.ProcessHandle, AHookRecord.OldFunction, @(AHookRecord.Newcode), 5, tmpCount);
  end else
  begin{����Ǹ������ʽ}
    if (not AHookRecord.AllowChange)or(AHookRecord.OldFunction=nil)or(AHookRecord.NewFunction=nil)then
      exit;
    {���ڴ�ŵ�ǰ��������DLLģ�������}
    FillChar(tmpBeenDone, SizeOf(tmpBeenDone), 0);
    PatchAddressInModule(@tmpBeenDone,
      GetModuleHandle(nil),
      AHookRecord.OldFunction,
      AHookRecord.NewFunction);
  end;
end;

{�ָ�ϵͳ�����ĵ���}
procedure HookRecordRestore(AHookRecord: PHookRecord);
var
   nCount: DWORD;
   BeenDone: TPatchedAddress;
begin
  if 1 = AHookRecord.TrapMode then{���������ʽ}
  begin
    if (not AHookRecord.AlreadyHook) or
       (0 = AHookRecord.ProcessHandle) or
       (nil = AHookRecord.OldFunction) or
       (nil = AHookRecord.NewFunction) then
        exit;
    WriteProcessMemory(AHookRecord.ProcessHandle, AHookRecord.OldFunction, @(AHookRecord.Oldcode), 5, nCount);
    AHookRecord.AlreadyHook := false;{��ʾ�˳�HOOK}
  end else
  begin{����Ǹ������ʽ}
    if (not AHookRecord.AllowChange)or(AHookRecord.OldFunction=nil)or(AHookRecord.NewFunction=nil)then
      exit;           
    {���ڴ�ŵ�ǰ��������DLLģ�������}
    FillChar(BeenDone, SizeOf(BeenDone), 0);
    PatchAddressInModule(@BeenDone, GetModuleHandle(nil),AHookRecord.NewFunction,AHookRecord.OldFunction);
  end;
end;

function NewBeginPaint(AWnd: HWND; var APaint: TPaintStruct): HDC; stdcall;
type
   TBeginPaint=function (Wnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall;
begin
  HookRecordRestore(@HookLibCore.Hooks[ProcID_BeginPaint]);
  result:=TBeginPaint(HookLibCore.Hooks[ProcID_BeginPaint].OldFunction)(AWnd, APaint);
//  if AWnd = HookLibCore.ShareMem.ShareMemData^.hHookWnd then{����ǵ�ǰ���Ĵ��ھ��}
//  begin
//    HookLibCore.ShareMem.ShareMemData^.DCMouse := result;{��¼���ķ���ֵ}
//  end else
//  begin
//    HookLibCore.ShareMem.ShareMemData^.DCMouse:=0;
//  end;
  HookRecordChange(@HookLibCore.Hooks[ProcID_BeginPaint]);
end;

procedure TestHook(ATrapMode: Integer);
begin
  HookRecordInitialize(@HookLibCore.Hooks[ProcID_BeginPaint], 1 = ATrapMode, @Windows.BeginPaint, @NewBeginPaint);
end;

end.
