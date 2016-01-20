unit winmem.awe;

interface

uses
  Windows;

{
  ʹ��AWE����ȴ� ֧�ֳ���4G   Address Windowing Extensions
  http://blog.sina.com.cn/s/blog_6942a159010144at.html

  [ת��]PAE ( Physical Address Extension )
}

type
  PMemoryAwe = ^TMemoryAwe;
  TMemoryAwe = record      
    MemoryPointer: Pointer;
    SysInfo: TSystemInfo;
    Pages: ULONG;
    UserPfnArray: PULONG;
  end;

  procedure AllocMem;     
  function AWE_SetLockPagesPrivilege(APrivilegeName: PChar; AIsEnabled: BOOL = TRUE): BOOL;

implementation

const
  SE_LOCK_MEMORY_NAME = 'SeLockMemoryPrivilege';
  MEM_PHYSICAL = $400000;
type
  TAllocateUserPhysicalPages = function (hProcess: THandle; NumberOfPages, UserPfnArray: PULONG): BOOL; stdcall;
  TFreeUserPhysicalPages = function (hProcess: THandle; NumberOfPages, UserPfnArray: PULONG): BOOL; stdcall;
  TMapUserPhysicalPages = function (lpAddress: Pointer; NumberOfPages: ULONG; UserPfnArray: PULONG): BOOL; stdcall;
                       
var
  AllocateUserPhysicalPages: TAllocateUserPhysicalPages;
  FreeUserPhysicalPages: TFreeUserPhysicalPages;
  MapUserPhysicalPages: TMapUserPhysicalPages;
  // ��λ AWE ����
function Initialize_AWE(): BOOL;
var
  tmpKernelHandle: THandle;
begin
  tmpKernelHandle := GetModuleHandle(kernel32);
  if (tmpKernelHandle <> 0) then
  begin
    @AllocateUserPhysicalPages := GetProcAddress(tmpKernelHandle, 'AllocateUserPhysicalPages');
    @FreeUserPhysicalPages := GetProcAddress(tmpKernelHandle, 'FreeUserPhysicalPages');
    @MapUserPhysicalPages := GetProcAddress(tmpKernelHandle, 'MapUserPhysicalPages');
  end;
  Result := (tmpKernelHandle <> 0) and
    Assigned(AllocateUserPhysicalPages) and
    Assigned(MapUserPhysicalPages) and
    Assigned(FreeUserPhysicalPages);
end;

 // ������ַ����
function AWE_Create(AMemory: PMemoryAwe; dwBytes: ULONG; pvPreferredWindowBase: Pointer = nil): BOOL;
begin
  AMemory.MemoryPointer := Windows.VirtualAlloc(pvPreferredWindowBase, dwBytes, MEM_RESERVE or MEM_PHYSICAL, PAGE_READWRITE);
  Result := (AMemory.MemoryPointer <> nil);
end;

  // �ͷŵ�ַ����
function AWE_Destroy(AMemory: PMemoryAwe): BOOL;
begin
  if (AMemory.MemoryPointer <> nil) then
  begin
    Result := VirtualFree(AMemory.MemoryPointer, 0, MEM_RELEASE);
    AMemory.MemoryPointer := nil;
  end else
  begin
    Result := TRUE;
  end;
end;

 // ӳ��RAM������
function AWS_MapStorage(AMemory: PMemoryAwe): BOOL;
begin
  Result := MapUserPhysicalPages(AMemory.MemoryPointer, AMemory.Pages, AMemory.UserPfnArray);
end;

 // ȡ�� RAM ӳ��
function AWE_UnmapStorage(AMemory: PMemoryAwe): BOOL;
var
  mbi: TMemoryBasicInformation;
begin
  VirtualQuery(AMemory.MemoryPointer, mbi, SizeOf(mbi));
  Result := MapUserPhysicalPages(AMemory.MemoryPointer, mbi.RegionSize div AMemory.SysInfo.dwPageSize, nil);
end;

 // �ͷ����� RAM
function AWS_Free(AMemory: PMemoryAwe): BOOL;
begin
  if (AMemory.UserPfnArray <> nil) then
  begin
    // �ͷ� RAM ҳ��
    if FreeUserPhysicalPages(GetCurrentProcess(), @AMemory.Pages, AMemory.UserPfnArray) then
    begin
      // �ͷ�ҳ�������
      HeapFree(GetProcessHeap(), 0, AMemory.UserPfnArray);
      AMemory.Pages := 0;
      AMemory.UserPfnArray := nil;
      Result := TRUE;
    end else
      Result := FALSE;
  end else
    Result := TRUE;  
end;
  // �������� RAM
function AWS_Allocate(AMemory: PMemoryAwe; ABytes: ULONG): BOOL;
begin
  // �����ǰ�ķ���
  AWS_Free(AMemory);
  // �����ڴ�ҳ����
  AMemory.Pages := (ABytes + AMemory.SysInfo.dwPageSize) div AMemory.SysInfo.dwPageSize;
  // ����ҳ�������
  AMemory.UserPfnArray := HeapAlloc(GetProcessHeap(), 0, AMemory.Pages * SizeOf(ULONG));
  if (AMemory.UserPfnArray <> nil) then
  begin
    // ���� RAM ҳ��
    AWE_SetLockPagesPrivilege(SE_LOCK_MEMORY_NAME, TRUE);
    Result := AllocateUserPhysicalPages(GetCurrentProcess(), @AMemory.Pages, AMemory.UserPfnArray);
    AWE_SetLockPagesPrivilege(SE_LOCK_MEMORY_NAME, FALSE);
  end else
    Result := FALSE;
end;
// �����û�Ȩ��
function AWE_SetLockPagesPrivilege(APrivilegeName: PChar; AIsEnabled: BOOL = TRUE): BOOL;
var                             
  tmpTokenHandle: THandle;
  tmpIsSucc: Boolean;
  tmpIsDisableAllPrivileges: Boolean;
  tmpInfo: TTokenPrivileges;
  tmpReturnLen: DWORD;
  tmpName: AnsiString;
begin
  // �򿪽�������
  Result := false;
  if Windows.OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, tmpTokenHandle) then
  begin
    // ����Ȩ��Luid
    tmpInfo.PrivilegeCount := 1;
    // ��������ڴ�Ȩ�޵�ID
    tmpName := APrivilegeName;
    tmpIsSucc := LookupPrivilegeValueA(nil, @tmpName, tmpInfo.Privileges[0].Luid);       
    if AIsEnabled then
    begin
      tmpInfo.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    end else
    begin
      tmpInfo.Privileges[0].Attributes := 0;
    end;
    if tmpIsSucc then
    begin
      // �����û�Ȩ��
      tmpIsDisableAllPrivileges := false;
      tmpIsSucc := AdjustTokenPrivileges(tmpTokenHandle,
        tmpIsDisableAllPrivileges, tmpInfo, SizeOf(TTokenPrivileges), PTokenPrivileges(nil)^, PULONG(nil)^);
      Result := (GetLastError() = ERROR_SUCCESS);
    end;
    CloseHandle(tmpTokenHandle);
  end;
end;

//  function AllocateUserPhysicalPages(hProcess: THandle; var NumberOfPages: ULONG_PTR; var UserPfnArray: ULONG_PTR): BOOL; stdcall;
//      external kernel32 name 'AllocateUserPhysicalPages';
  function AllocateUserPhysicalPagesNuma(hProcess: THANDLE; var NumberOfPages: ULONG_PTR; var PageArray: ULONG_PTR; nndPreferred: DWORD): BOOL; stdcall;
      external kernel32 name 'AllocateUserPhysicalPagesNuma';
  function MapUserPhysicalPagesScatter(VirtualAddresses: Pointer; NumberOfPages: ULONG_PTR; var PageArray: ULONG_PTR): BOOL; stdcall;
      external kernel32 name 'MapUserPhysicalPagesScatter';
//  function MapUserPhysicalPages(lpAddress: Pointer; NumberOfPages: ULONG_PTR; var UserPfnArray: ULONG_PTR): BOOL; stdcall;
//      external kernel32 name 'MapUserPhysicalPages';
//  function FreeUserPhysicalPages(hProcess: THANDLE; var NumberOfPages: ULONG_PTR; var UserPfnArray: ULONG_PTR): BOOL; stdcall;
//      external kernel32 name 'FreeUserPhysicalPages';

procedure AllocMem;
const
  MEMORY_REQUESTED = 16*1024*1024;
  RAMSize = 1024000 * 1024; // 1G
var
  tmpMem: Pointer;
  tmpSize: DWORD;
  tmpSysInfo: TSystemInfo;
  tmpPageCount: integer;
begin
  //AWESetLockPagesPrivilege();
  tmpMem := Windows.VirtualAlloc(nil, tmpSize, MEM_RESERVE or MEM_PHYSICAL, PAGE_READWRITE);
  Windows.GetSystemInfo(tmpSysInfo);
  tmpPageCount := RAMSize div tmpSysInfo.dwPageSize;
  //AllocateUserPhysicalPages();
  //MapUserPhysicalPages(tmpMem, ulRAMPages, aRAMPages);
  //FreeUserPhysicalPages(GetCurrentProcess(), &ulRAMPages, aRAMPages);
  Windows.VirtualFree(tmpMem, 0, MEM_RELEASE);
  //if(!(GetCurrentProcess(), &ulRAMPages,aRAMPages))
end;

end.
