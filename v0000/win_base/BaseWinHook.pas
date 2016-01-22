unit BaseWinHook;

interface

uses
  Types, Windows;
  
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
                  
  procedure HookChange(AHookRecord: PHookRecord);  
  procedure HookRestore(AHookRecord: PHookRecord);

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
procedure HookInitialize(AHookRecord: PHookRecord; IsTrap:boolean; OldFun, NewFun: pointer);
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
   HookChange(AHookRecord); {��ʼHOOK}
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

procedure HookChange(AHookRecord: PHookRecord);
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
procedure HookRestore(AHookRecord: PHookRecord);
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
  HookRestore(@HookLibCore.Hooks[ProcID_BeginPaint]);
  result:=TBeginPaint(HookLibCore.Hooks[ProcID_BeginPaint].OldFunction)(AWnd, APaint);
//  if AWnd = HookLibCore.ShareMem.ShareMemData^.hHookWnd then{����ǵ�ǰ���Ĵ��ھ��}
//  begin
//    HookLibCore.ShareMem.ShareMemData^.DCMouse := result;{��¼���ķ���ֵ}
//  end else
//  begin
//    HookLibCore.ShareMem.ShareMemData^.DCMouse:=0;
//  end;
  HookChange(@HookLibCore.Hooks[ProcID_BeginPaint]);
end;

procedure TestHook(ATrapMode: Integer);
begin
  HookInitialize(@HookLibCore.Hooks[ProcID_BeginPaint], 1 = ATrapMode, @Windows.BeginPaint, @NewBeginPaint);
end;

end.
