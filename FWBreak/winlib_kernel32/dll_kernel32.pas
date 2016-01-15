{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit dll_kernel32;

interface 
                 
uses
  atmcmbaseconst, winconst, wintype;

const
  DONT_RESOLVE_DLL_REFERENCES = 1;
  // ����ʲô��˼ load lib as data file ???
  LOAD_LIBRARY_AS_DATAFILE = 2;
  LOAD_WITH_ALTERED_SEARCH_PATH = 8;

  function LoadLibraryA(lpLibFileName: PAnsiChar): HMODULE; stdcall; external kernel32 name 'LoadLibraryA';
  function LoadLibraryExA(lpLibFileName: PAnsiChar; hFile: THandle; dwFlags: DWORD): HMODULE; stdcall; external kernel32 name 'LoadLibraryExA';
  
  function FreeLibrary(hLibModule: HMODULE): BOOL; stdcall; external kernel32 name 'FreeLibrary';
  procedure FreeLibraryAndExitThread(hLibModule: HMODULE; dwExitCode: DWORD); stdcall; external kernel32 name 'FreeLibraryAndExitThread';

  // ȡ��DLL_THREAD_ATTACH��DLL_THREAD_DETACH��֪ͨ��Ϣ
  // ��ɼ���ĳЩӦ�ó���Ĺ������ռ�
  // ��Ȼ��DLL�У����ǲ��ܵ���GetModuleHandle(NULL)����ȡDLLģ��ľ����
  // ��Ϊ������õ��ǵ�ǰʹ�ø�DLL�Ŀ�ִ�г���ӳ��Ļ���ַ��������DLLӳ���
  // ����һ��ӵ�кܶ�DLL�Ķ��߳�Ӧ�ó�����ԣ������ЩDLLƵ���ش����������̣߳�
  // ������ЩDLL����Ҫ�̴߳���������֪ͨ������DLL��ʹ��DisableThreadLibraryCalls�������ܹ����Ż�Ӧ�ó��������
  // http://hi.baidu.com/micfree/blog/item/ee3e83f5d8b07132bc31091a.html
  function DisableThreadLibraryCalls(hLibModule: HMODULE): BOOL; stdcall; external kernel32 name 'DisableThreadLibraryCalls';
                                                 
  function GetModuleHandleA(lpModuleName: PAnsiChar): HMODULE; stdcall; external kernel32 name 'GetModuleHandleA';
  
  function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; external kernel32 name 'GetProcAddress';
  function CloseHandle(hObject: THandle): BOOL; stdcall; external kernel32 name 'CloseHandle';

  function GetLastError: Longword; stdcall; external kernel32 name 'GetLastError';

  function InterlockedIncrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedIncrement';
  function InterlockedDecrement(var Addend: Integer): Integer; stdcall; external kernel32 name 'InterlockedDecrement';
  function InterlockedCompareExchange(var Destination: Longint; Exchange: Longint; Comperand: Longint): Longint stdcall; external kernel32 name 'InterlockedCompareExchange';
  function InterlockedExchange(var Target: Integer; Value: Integer): Integer; stdcall; external kernel32 name 'InterlockedExchange';
//  function InterlockedExchangeAdd(Addend: PLongint; Value: Longint): Longint; external kernel32 name 'InterlockedExchangeAdd';
  function InterlockedExchangeAdd(var Addend: Longint; Value: Longint): Longint; external kernel32 name 'InterlockedExchangeAdd';

  function CreateIoCompletionPort(FileHandle, ExistingCompletionPort: THandle;
    CompletionKey, NumberOfConcurrentThreads: DWORD): THandle; stdcall; external kernel32 name 'CreateIoCompletionPort';
  // windows server 2008
  function GetQueuedCompletionStatusEx(CompletionPort: THandle;
    var lpOverlapped: POverlapped; ulCount: ULONG;
    var ulNumEntriesRemoved: PULONG; dwMilliseconds: DWORD; fAlertable: BOOL): BOOL; stdcall; external kernel32 name 'GetQueuedCompletionStatusEx';
  // windows xp
  function GetQueuedCompletionStatus(CompletionPort: THandle;
    var lpNumberOfBytesTransferred, lpCompletionKey: DWORD;
    var lpOverlapped: POverlapped; dwMilliseconds: DWORD): BOOL; stdcall; external kernel32 name 'GetQueuedCompletionStatus';
  function PostQueuedCompletionStatus(CompletionPort: THandle; dwNumberOfBytesTransferred: DWORD;
      dwCompletionKey: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'PostQueuedCompletionStatus';
  //�������������д�����ڴ���ȥ����CPU���¼����µ�ָ�����ִ���µ�ָ��
  //http://blog.csdn.net/caimouse/archive/2007/12/06/1921570.aspx
  function FlushInstructionCache(hProcess: THandle;
      const lpBaseAddress: Pointer; dwSize: DWORD): BOOL; stdcall; external kernel32 name 'FlushInstructionCache';

  procedure OutputDebugStrA(lpOutputStr: PAnsiChar); stdcall; external kernel32 name 'OutputDebugStringA';
  procedure OutputDebugStrW(lpOutputStr: PWideChar); stdcall; external kernel32 name 'OutputDebugStringW';

  function GetComputerNameA(lpBuffer: PAnsiChar; var nSize: DWORD): BOOL; stdcall; external kernel32 name 'GetComputerNameA';
  function SetComputerNameA(lpComputerName: PAnsiChar): BOOL; stdcall; external kernel32 name 'SetComputerNameA';

  function GetLocaleInfoA(Locale: LCID; LCType: LCTYPE; lpLCData: PAnsiChar; cchData: Integer): Integer; stdcall; external kernel32 name 'GetLocaleInfoA';

  function GetUserDefaultLCID: LCID; stdcall; external kernel32 name 'GetUserDefaultLCID';
  function GetSystemDefaultLCID: LCID; stdcall; external kernel32 name 'GetSystemDefaultLCID';

  function GetUserDefaultLangID: LANGID; stdcall; external kernel32 name 'GetUserDefaultLangID';
  function GetSystemDefaultLangID: LANGID; stdcall; external kernel32 name 'GetSystemDefaultLangID';

type                           
  TwDLLKernelProc   = record
    LoadLibrary     : function(lpLibFileName: PAnsiChar): HMODULE; stdcall;
    FreeLibrary     : function(hLibModule: HMODULE): BOOL; stdcall;
    GetProcAddress  : function(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
    CloseHandle     : function(hObject: THandle): BOOL; stdcall;
    GetLastError    : function: Longword; stdcall; 
  end;
  
  TwDLLKernel       = record
    Handle          : HModule;
    Proc            : TwDLLKernelProc;
//    CharProc        : TwDLLKernel_Char;
//    MemProc         : TwDLLKernel_Mem;
//    TimeProc        : TwDLLKernel_Time;
//    SysObjProc      : TwDLLKernel_SysObj;
//    ProcThreadProc  : TwDLLKernel_ProcThread;
  end;

const
  LOCALE_IDEFAULTANSICODEPAGE     = $00001004;   { default ansi code page }

const
  SCS_32BIT_BINARY = 0;
  SCS_DOS_BINARY = 1;
  SCS_WOW_BINARY = 2;
  SCS_PIF_BINARY = 3;
  SCS_POSIX_BINARY = 4;
  SCS_OS216_BINARY = 5;

  // ��� �� exe �ļ� ����Ϊ true
  // if GetBinaryType('E:\Collect\AlgorithmCourse.rar', BinaryType) then
  //   if BinaryType = SCS_32BIT_BINARY then

  function GetBinaryTypeA(lpApplicationName: PAnsiChar; var lpBinaryType: DWORD): BOOL; stdcall; external kernel32 name 'GetBinaryTypeA';
  function GetCommandLineA: PAnsiChar; stdcall; external kernel32 name 'GetCommandLineA';
  function GetEnvironmentVariableA(lpName: PAnsiChar; lpBuffer: PAnsiChar; nSize: DWORD): DWORD; stdcall;
    external kernel32 name 'GetEnvironmentVariableA';
  function SetEnvironmentVariable(lpName, lpValue: PAnsiChar): BOOL; stdcall; external kernel32 name 'SetEnvironmentVariableA';
  function ExpandEnvironmentStrsA(lpSrc: PAnsiChar; lpDst: PAnsiChar; nSize: DWORD): DWORD; stdcall; external kernel32 name 'ExpandEnvironmentStringsA';
  procedure GetStartupInfoA(var lpStartupInfo: TStartupInfoA); stdcall; external kernel32 name 'GetStartupInfoA';
  procedure FatalAppExitA(uAction: UINT; lpMessageText: PAnsiChar); stdcall; external kernel32 name 'FatalAppExitA';

  {
  FatalExit ���������˳�Ӧ�ó������κ����������ֶ�����Ȼ�������ڴ��е��ø�
  ����ʱͨ���ᵼ��GPF ����һ���ڵ���Ӧ�ó���ʱʹ��
  }
  procedure FatalExit(ExitCode: Integer); stdcall; external kernel32 name 'FatalExit';

  { Performance counter API's }
  // Windows�»�ȡ�߾���ʱ��ע������ [ת�� AdamWu]
  // http://www.cnblogs.com/AnyDelphi/archive/2009/05/14/1456716.html
  // 1. RDTSC - ����: ���뼶 ���Ƽ� (��׼ȷ)
  // 2. QueryPerformanceCounter - ����: 1~100΢�뼶 ���Ƽ�
  //    ϵͳ���ý���ģʽ��ʱ��PerformanceCounter�����Ľ������ƫ���ܶ࣬
  //    ��Ƶģʽ��ʱ����ƫ�죬�����õ�غͽӵ�Դ��ʱ��Ч������һ��
  // 3. timeGetTime - ����: ���뼶 �Ƽ�
  // winmm.timeGetTime
  //    A) ��NTϵͳ��(��˵)Ĭ�Ͼ���Ϊ10ms�����ǿ�����timeBeginPeriod�����͵�1ms
  //    B) ���ص���һ��32λ����������Ҫע���Լÿ49.71�����ֹ���(����ǰ������64λ����Ҫ������Ż����)��
  function QueryPerformanceCounter(var lpPerformanceCount: TLargeInteger): BOOL; stdcall; overload;
    external kernel32 name 'QueryPerformanceCounter';
  function QueryPerformanceCounter(var lpPerformanceCount: Int64): BOOL; stdcall; overload;
    external kernel32 name 'QueryPerformanceCounter';
  function QueryPerformanceFrequency(var lpFrequency: TLargeInteger): BOOL; stdcall; external kernel32 name 'QueryPerformanceFrequency';

implementation

end.
