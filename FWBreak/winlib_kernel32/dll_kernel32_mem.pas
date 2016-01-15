unit dll_kernel32_mem;

interface 
                                         
uses
  atmcmbaseconst, winconst, wintype;

type                      
  PMemoryBasicInfo    = ^TMemoryBasicInfo;
  TMemoryBasicInfo    = record
    BaseAddress       : Pointer;
    AllocationBase    : Pointer;
    AllocationProtect : DWORD;
    RegionSize        : DWORD;
    State             : DWORD;
    Protect           : DWORD;
    Type_9            : DWORD;
  end;

  {
    �������û�г�������ɿռ�ȥ�������ǵ�����LocalAlloc����NULL����ΪNULL��ʹ��ȥ����һ�����������ַzero�Ӳ������䡣��ˣ�������ȥ���NULLָ���ʹ��
    ��������ɹ��Ļ��������ٻ��������ָ����С���ڴ档�����������ǵ�������������ָ���Ļ������������ʹ�������������ڴ�
    ʹ��LocalSize����ȥ��ⱻ������ֽ���
  }
  function LocalAlloc(uFlags, uBytes: UINT): HLOCAL; stdcall; external kernel32 name 'LocalAlloc';

  function LocalLock(AMem: HLOCAL): Pointer; stdcall; external kernel32 name 'LocalLock';
  function LocalReAlloc(AMem: HLOCAL; uBytes, uFlags: UINT): HLOCAL; stdcall; external kernel32 name 'LocalReAlloc';
  function LocalUnlock(AMem: HLOCAL): BOOL; stdcall; external kernel32 name 'LocalUnlock';
  function LocalSize(AMem: HLOCAL): UINT; stdcall; external kernel32 name 'LocalSize'; 
  function LocalFree(AMem: HLOCAL): HLOCAL; stdcall; external kernel32 name 'LocalFree';
  function LocalCompact(uMinFree: UINT): UINT; stdcall; external kernel32 name 'LocalCompact';
  function LocalShrink(AMem: HLOCAL; cbNewSize: UINT): UINT; stdcall; external kernel32 name 'LocalShrink';
  function LocalFlags(AMem: HLOCAL): UINT; stdcall; external kernel32 name 'LocalFlags';
  
  function VirtualProtect(lpAddress: Pointer; dwSize, flNewProtect: DWORD;
    lpflOldProtect: Pointer): BOOL; stdcall; overload; external kernel32 name 'VirtualProtect';
  function VirtualProtect(lpAddress: Pointer; dwSize, flNewProtect: DWORD;
    var OldProtect: DWORD): BOOL; stdcall; overload; external kernel32 name 'VirtualProtect';
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
    dwSize, flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL; stdcall; overload;
    external kernel32 name 'VirtualProtectEx';
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
    dwSize, flNewProtect: DWORD; var OldProtect: DWORD): BOOL; stdcall; overload;
    external kernel32 name 'VirtualProtectEx';

  function VirtualLock(lpAddress: Pointer; dwSize: DWORD): BOOL; stdcall; external kernel32 name 'VirtualLock';
  function VirtualUnlock(lpAddress: Pointer; dwSize: DWORD): BOOL; stdcall; external kernel32 name 'VirtualUnlock';

  { VirtualAlloc �ú����Ĺ������ڵ��ý��̵����ַ�ռ�,Ԥ�������ύһ����ҳ
������������ڴ����Ļ�,���ҷ�������δָ��MEM_RESET,��ϵͳ���Զ�����Ϊ0;
    flAllocationType:
    MEM_COMMIT ���ڴ����ָ���Ĵ���ҳ�ļ�(�����ڴ��ļ�)�з���һ����洢���� ������ʼ���������Ϊ0
����MEM_PHYSICAL �����ͱ����MEM_RESERVEһ��ʹ�� ����һ����ж�д���ܵ������ڴ���
����MEM_RESERVE ���������ַ�ռ��Ա��Ժ��ύ��
����MEM_RESET
����MEM_TOP_DOWN ����ϵͳ����߿�����������ַ��ʼӳ��Ӧ�ó���
����MEM_WRITE_WATCH
    ��������
����PAGE_READONLY ������Ϊֻ�������Ӧ�ó�����ͼ���������е�ҳ��ʱ�򣬽��ᱻ�ܾ�����PAGE_READWRITE ����ɱ�Ӧ�ó����д
����PAGE_EXECUTE ��������ɱ�ϵͳִ�еĴ��롣��ͼ��д������Ĳ��������ܾ���
����PAGE_EXECUTE_READ ���������ִ�д��룬Ӧ�ó�����Զ�������
����PAGE_EXECUTE_READWRITE ���������ִ�д��룬Ӧ�ó�����Զ�д������
����PAGE_GUARD �����һ�α�����ʱ����һ��STATUS_GUARD_PAGE�쳣�������־Ҫ������������־�ϲ�ʹ�ã��������򱻵�һ�η��ʵ�Ȩ��
����PAGE_NOACCESS �κη��ʸ�����Ĳ��������ܾ�
����PAGE_NOCACHE RAM�е�ҳӳ�䵽������ʱ�����ᱻ΢���������棨cached)
    ע:PAGE_GUARD��PAGE_NOCHACHE��־���Ժ�������־�ϲ�ʹ���Խ�һ��ָ��ҳ��������
       PAGE_GUARD��־ָ����һ������ҳ��guard page��������һ��ҳ���ύʱ�����һ
       �α����ʶ�����һ��one-shot�쳣������ȡ��ָ���ķ���Ȩ�ޡ�PAGE_NOCACHE��ֹ
       ����ӳ�䵽����ҳ��ʱ��΢���������档�����־�����豸����ʹ��ֱ���ڴ��
       �ʷ�ʽ��DMA���������ڴ��
  }
  function VirtualAlloc(lpvAddress: Pointer; dwSize, flAllocationType, flProtect: DWORD): Pointer; stdcall; external kernel32 name 'VirtualAlloc';
  function VirtualAllocEx(hProcess: THandle; lpAddress: Pointer;
    dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall; external kernel32 name 'VirtualAllocEx';

  function VirtualFree(lpAddress: Pointer; dwSize, dwFreeType: DWORD): BOOL; stdcall; external kernel32 name 'VirtualFree';
  function VirtualFreeEx(hProcess: THandle; lpAddress: Pointer;
    dwSize, dwFreeType: DWORD): Pointer; stdcall; external kernel32 name 'VirtualFreeEx';

  function VirtualQuery(lpAddress: Pointer; var lpBuffer: TMemoryBasicInfo; dwLength: DWORD): DWORD; stdcall; external kernel32 name 'VirtualQuery';
  function VirtualQueryEx(hProcess: THandle; lpAddress: Pointer;
    var lpBuffer: TMemoryBasicInfo; dwLength: DWORD): DWORD; stdcall; external kernel32 name 'VirtualQueryEx';

  {�ú����Ӷ��з���һ����Ŀ���ֽ���.Win32�ڴ�����������ṩ
   �໥�ֿ��ľֲ���ȫ�ֶ�.�ṩ�������ֻ��Ϊ����16λ��Windows�����}
  function GlobalAlloc(uFlags: UINT; dwBytes: DWORD): HGLOBAL; stdcall; external kernel32 name 'GlobalAlloc';
  function GlobalReAlloc(AMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT): HGLOBAL; stdcall; external kernel32 name 'GlobalReAlloc';
  function GlobalLock(AMem: HGLOBAL): Pointer; stdcall; external kernel32 name 'GlobalLock';
  function GlobalSize(AMem: HGLOBAL): DWORD; stdcall; external kernel32 name 'GlobalSize';
  function GlobalHandle(AMem: Pointer): HGLOBAL; stdcall; external kernel32 name 'GlobalHandle';
  function GlobalUnlock(AMem: HGLOBAL): BOOL; stdcall; external kernel32 name 'GlobalUnlock';
  function GlobalFree(AMem: HGLOBAL): HGLOBAL; stdcall; external kernel32 name 'GlobalFree';
  function GlobalCompact(dwMinFree: DWORD): UINT; stdcall; external kernel32 name 'GlobalCompact';
  procedure GlobalFix(AMem: HGLOBAL); stdcall; external kernel32 name 'GlobalFix';
  procedure GlobalUnfix(AMem: HGLOBAL); stdcall; external kernel32 name 'GlobalUnfix';

  // Not necessary and has no effect.
  function GlobalWire(AMem: HGLOBAL): Pointer; stdcall; external kernel32 name 'GlobalWire';
  function GlobalUnWire(AMem: HGLOBAL): BOOL; stdcall; external kernel32 name 'GlobalUnWire';

  { Heap Functions }
  function GetProcessHeap: THandle;stdcall; external kernel32 name 'GetProcessHeap';
  function GetProcessHeaps(NumberOfHeaps: DWORD; ProcessHeaps: PHandle): DWORD;stdcall; external kernel32 name 'GetProcessHeaps';
  function HeapQueryInformation(HeapHandle: THANDLE; HeapInformationClass: Pointer): BOOL;stdcall; external kernel32 name 'HeapQueryInformation';
  function HeapSetInformation(HeapHandle: THANDLE; HeapInformationClass: Pointer): BOOL;stdcall; external kernel32 name 'HeapSetInformation';

  function HeapCreate(flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle; stdcall; external kernel32 name 'HeapCreate';
  function HeapDestroy(AHeap: THandle): BOOL; stdcall; external kernel32 name 'HeapDestroy';
  function HeapAlloc(AHeap: THandle; dwFlags, dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapAlloc';
  function HeapReAlloc(AHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer; stdcall; external kernel32 name 'HeapReAlloc';
  function HeapFree(AHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapFree';
  function HeapSize(AHeap: THandle; dwFlags: DWORD; lpMem: Pointer): DWORD; stdcall; external kernel32 name 'HeapSize';
  function HeapValidate(AHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall; external kernel32 name 'HeapValidate';
  function HeapCompact(AHeap: THandle; dwFlags: DWORD): UINT; stdcall; external kernel32 name 'HeapCompact';
  function HeapLock(AHeap: THandle): BOOL; stdcall; external kernel32 name 'HeapLock';
  function HeapUnlock(AHeap: THandle): BOOL; stdcall; external kernel32 name 'HeapUnlock';
  function HeapWalk(AHeap: THandle; var lpEntry: TProcessHeapEntry): BOOL; stdcall; external kernel32 name 'HeapWalk';

  {
  һ��ĳ�����������ǰ�Ѿ�����õģ�����޸�ָ��Ļ���Ƚ��٣���������ķ�ȷ���
  ����ʹ�úܶࡣ���޸�ָ��֮����ô��������CPUȥִ���µ�ָ���أ���������Ҫʹ�ú���
  FlushInstructionCache���ѻ������������д�����ڴ���ȥ����CPU���¼����µ�ָ�����ִ���µ�ָ��
  }
  function FlushInstructionCache(hProcess: THandle; const lpBaseAddress: Pointer; dwSize: DWORD): BOOL; stdcall; external kernel32 name 'FlushInstructionCache';

  function ReadProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
    nSize: DWORD; var lpNumberOfBytesRead: DWORD): BOOL; stdcall; external kernel32 name 'ReadProcessMemory';
  function WriteProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
    nSize: DWORD; var lpNumberOfBytesWritten: DWORD): BOOL; stdcall; external kernel32 name 'WriteProcessMemory';

  { http://msdn.microsoft.com/en-us/library/windows/desktop/aa366781(v=vs.85).aspx#awe_functions }
  { AWE Functions }
  function AllocateUserPhysicalPages(AProcess: THandle; NumberOfPages: Pointer; UserPfnArray: Pointer): BOOL; stdcall;
      external kernel32 name 'AllocateUserPhysicalPages';
  function FreeUserPhysicalPages(AProcess: THandle; NumberOfPages: Pointer; UserPfnArray: Pointer): BOOL; stdcall;
      external kernel32 name 'FreeUserPhysicalPages';
  function MapUserPhysicalPages(lpAddress: Pointer; NumberOfPages: Pointer; UserPfnArray: Pointer): BOOL; stdcall;
      external kernel32 name 'MapUserPhysicalPages';
  { 64-bit Windows on Itanium-based systems:  Due to the difference in page sizes,
    MapUserPhysicalPagesScatter is not supported for 32-bit applications. }
  function MapUserPhysicalPagesScatter(VirtualAddresses: Pointer; NumberOfPages: Pointer; PageArray: Pointer): BOOL; stdcall;
      external kernel32 name 'MapUserPhysicalPagesScatter';

type
  TwDLLKernel_Mem  = record
    LocalAlloc: function (uFlags, uBytes: UINT): HLOCAL; stdcall;
    LocalLock: function (hMem: HLOCAL): Pointer; stdcall;
    LocalReAlloc: function (hMem: HLOCAL; uBytes, uFlags: UINT): HLOCAL; stdcall;
    LocalUnlock: function (hMem: HLOCAL): BOOL; stdcall;
    LocalFree: function (hMem: HLOCAL): HLOCAL; stdcall;
    LocalCompact: function (uMinFree: UINT): UINT; stdcall;

    VirtualProtect: function (lpAddress: Pointer; dwSize, flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL; stdcall;
  //  VirtualProtect: function (lpAddress: Pointer; dwSize, flNewProtect: DWORD; var OldProtect: DWORD): BOOL; stdcall; overload;
    VirtualProtectEx: function (hProcess: THandle; lpAddress: Pointer; dwSize, flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL; stdcall; 
  //  VirtualProtectEx: function (hProcess: THandle; lpAddress: Pointer; dwSize, flNewProtect: DWORD; var OldProtect: DWORD): BOOL; stdcall; overload;

    VirtualLock: function (lpAddress: Pointer; dwSize: DWORD): BOOL; stdcall;
    VirtualUnlock: function (lpAddress: Pointer; dwSize: DWORD): BOOL; stdcall;

    VirtualAlloc: function (lpvAddress: Pointer; dwSize, flAllocationType, flProtect: DWORD): Pointer; stdcall;
    VirtualAllocEx: function (hProcess: THandle; lpAddress: Pointer; dwSize, flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall;
    VirtualFree: function (lpAddress: Pointer; dwSize, dwFreeType: DWORD): BOOL; stdcall;
    VirtualFreeEx: function (hProcess: THandle; lpAddress: Pointer; dwSize, dwFreeType: DWORD): Pointer; stdcall;

    VirtualQuery: function (lpAddress: Pointer; var lpBuffer: TMemoryBasicInfo; dwLength: DWORD): DWORD; stdcall;
    VirtualQueryEx: function (hProcess: THandle; lpAddress: Pointer; var lpBuffer: TMemoryBasicInfo; dwLength: DWORD): DWORD; stdcall;

    GlobalAlloc: function (uFlags: UINT; dwBytes: DWORD): HGLOBAL; stdcall;
    GlobalReAlloc: function (hMem: HGLOBAL; dwBytes: DWORD; uFlags: UINT): HGLOBAL; stdcall;
    GlobalLock: function (hMem: HGLOBAL): Pointer; stdcall;
    GlobalHandle: function (Mem: Pointer): HGLOBAL; stdcall;
    GlobalUnlock: function (hMem: HGLOBAL): BOOL; stdcall;
    GlobalFree: function (hMem: HGLOBAL): HGLOBAL; stdcall;
    GlobalCompact: function (dwMinFree: DWORD): UINT; stdcall;
    GlobalFix: procedure (hMem: HGLOBAL); stdcall;
    GlobalUnfix: procedure (hMem: HGLOBAL); stdcall;


    HeapCreate: function (flOptions, dwInitialSize, dwMaximumSize: DWORD): THandle; stdcall;
    HeapDestroy: function (hHeap: THandle): BOOL; stdcall;
    HeapAlloc: function (hHeap: THandle; dwFlags, dwBytes: DWORD): Pointer; stdcall;
    HeapReAlloc: function (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer; dwBytes: DWORD): Pointer; stdcall;
    HeapFree: function (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall;
    HeapSize: function (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): DWORD; stdcall;
    HeapValidate: function (hHeap: THandle; dwFlags: DWORD; lpMem: Pointer): BOOL; stdcall;
    HeapCompact: function (hHeap: THandle; dwFlags: DWORD): UINT; stdcall;
    HeapLock: function (hHeap: THandle): BOOL; stdcall;
    HeapUnlock: function (hHeap: THandle): BOOL; stdcall;
    HeapWalk: function (hHeap: THandle; var lpEntry: TProcessHeapEntry): BOOL; stdcall;
  end;


const
  { Global Memory Flags }
  GMEM_FIXED        = 0;
  GMEM_MOVEABLE     = 2;
  GMEM_NOCOMPACT    = $10;
  GMEM_NODISCARD    = $20;
  GMEM_ZEROINIT     = $40;
  GMEM_MODIFY       = $80;
  GMEM_DISCARDABLE  = $100;
  GMEM_NOT_BANKED   = $1000;
  GMEM_SHARE        = $2000;
  GMEM_DDESHARE     = $2000;
  GMEM_NOTIFY       = $4000;
  GMEM_LOWER        = GMEM_NOT_BANKED;
  GMEM_VALID_FLAGS  = 32626;
  GMEM_INVALID_HANDLE = $8000;

  GHND = GMEM_MOVEABLE or GMEM_ZEROINIT;
  GPTR = GMEM_FIXED or GMEM_ZEROINIT;

implementation

end.
