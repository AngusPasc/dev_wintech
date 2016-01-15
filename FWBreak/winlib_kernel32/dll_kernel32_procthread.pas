unit dll_kernel32_procthread;

interface

uses
  atmcmbaseconst, winconst, wintype;
  
type
  PProcessInfo      = ^TProcessInfo;
  TProcessInfo      = record
    hProcess        : THandle;
    hThread         : THandle;
    dwProcessId     : DWORD;
    dwThreadId      : DWORD;
  end;
                                 
const                               
  PROCESS_TERMINATE         = $0001;
  PROCESS_CREATE_THREAD     = $0002;
  PROCESS_VM_OPERATION      = $0008;
  PROCESS_VM_READ           = $0010;
  PROCESS_VM_WRITE          = $0020;
  PROCESS_DUP_HANDLE        = $0040;
  PROCESS_CREATE_PROCESS    = $0080;
  PROCESS_SET_QUOTA         = $0100;
  PROCESS_SET_INFORMATION   = $0200;
  PROCESS_QUERY_INFORMATION = $0400;
  PROCESS_ALL_ACCESS        = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $FFF);
                                       
  DEBUG_PROCESS             = $00000001;
  DEBUG_ONLY_THIS_PROCESS   = $00000002;

  CREATE_SUSPENDED          = $00000004;

  DETACHED_PROCESS          = $00000008;
  CREATE_NEW_CONSOLE        = $00000010;

  // �������û��������������Ҫ��
  NORMAL_PRIORITY_CLASS     = $00000020;

  // ָʾ������̵��߳�ֻ����ϵͳ����ʱ�Ż����в��ҿ��Ա��κθ����ȼ���������
  IDLE_PRIORITY_CLASS       = $00000040;

  //ָʾ������̽�ִ��ʱ���ٽ���������������뱻���������Ա�֤��ȷ��
  // ������ȼ��ĳ����������������ȼ���������ȼ��ĳ���
  // һ��������Windows�����б�Ϊ�˱�֤���û�����ʱ����������Ӧ��
  // �����˶�ϵͳ���ɵĿ��ǡ�ȷ����ʹ�ø����ȼ�ʱӦ���㹻��������Ϊ
  // һ�������ȼ���CPU����Ӧ�ó������ռ�ü���ȫ����CPU����ʱ��
  HIGH_PRIORITY_CLASS       = $00000080;

  // ָʾ�������ӵ�п��õ�������ȼ���
  // һ��ӵ��ʵʱ���ȼ��Ľ��̵��߳̿���
  // ����������������̵߳�ִ�У�������
  // ��ִ����Ҫ�����ϵͳ���̡����磬һ
  // ��ִ��ʱ���Գ�һ���ʵʱ���̿��ܵ�
  // �´��̻��治�����귴ӳ�ٶ�
  REALTIME_PRIORITY_CLASS   = $00000100;

  // �½��̽�ʹһ���������ĸ����̡��������е�ȫ�����̶��Ǹ����̵��ӽ���
  // CREATE_NEW_PROCESS_GROUP or NORMAL_PRIORITY_CLASS
  CREATE_NEW_PROCESS_GROUP  = $00000200;


  CREATE_UNICODE_ENVIRONMENT= $00000400;
  CREATE_SEPARATE_WOW_VDM   = $00000800;
  CREATE_SHARED_WOW_VDM     = $00001000;
  CREATE_FORCEDOS           = $00002000;
  CREATE_DEFAULT_ERROR_MODE = $04000000;

  // CREATE_NO_WINDOW ��ΪӦ�ó��򴴽��κο���̨���� ???
  // ����̨���� ???
  CREATE_NO_WINDOW          = $08000000;

    { Dual Mode API below this line. Dual Mode Structures also included. }
  STARTF_USESHOWWINDOW = 1;
  STARTF_USESIZE = 2;
  STARTF_USEPOSITION = 4;
  STARTF_USECOUNTCHARS = 8;
  STARTF_USEFILLATTRIBUTE = $10;
  STARTF_RUNFULLSCREEN = $20;  { ignored for non-x86 platforms }
  STARTF_FORCEONFEEDBACK = $40;
  STARTF_FORCEOFFFEEDBACK = $80;
  STARTF_USESTDHANDLES = $100;
  STARTF_USEHOTKEY = $200;
                                 
  STATUS_WAIT_0                   = $00000000;
  STATUS_ABANDONED_WAIT_0         = $00000080;
  STATUS_USER_APC                 = $000000C0;
  STATUS_TIMEOUT                  = $00000102;
  STATUS_PENDING                  = $00000103;
  STATUS_SEGMENT_NOTIFICATION     = $40000005;
  STATUS_GUARD_PAGE_VIOLATION     = DWORD($80000001);
  STATUS_DATATYPE_MISALIGNMENT    = DWORD($80000002);
  STATUS_BREAKPOINT               = DWORD($80000003);
  STATUS_SINGLE_STEP              = DWORD($80000004);
  STATUS_ACCESS_VIOLATION         = DWORD($C0000005);
  STATUS_IN_PAGE_ERROR            = DWORD($C0000006);
  STATUS_INVALID_HANDLE           = DWORD($C0000008);
  STATUS_NO_MEMORY                = DWORD($C0000017);
  STATUS_ILLEGAL_INSTRUCTION      = DWORD($C000001D);
  STATUS_NONCONTINUABLE_EXCEPTION = DWORD($C0000025);
  STATUS_INVALID_DISPOSITION      = DWORD($C0000026);
  STATUS_ARRAY_BOUNDS_EXCEEDED    = DWORD($C000008C);
  STATUS_FLOAT_DENORMAL_OPERAND   = DWORD($C000008D);
  STATUS_FLOAT_DIVIDE_BY_ZERO     = DWORD($C000008E);
  STATUS_FLOAT_INEXACT_RESULT     = DWORD($C000008F);
  STATUS_FLOAT_INVALID_OPERATION  = DWORD($C0000090);
  STATUS_FLOAT_OVERFLOW           = DWORD($C0000091);
  STATUS_FLOAT_STACK_CHECK        = DWORD($C0000092);
  STATUS_FLOAT_UNDERFLOW          = DWORD($C0000093);
  STATUS_INTEGER_DIVIDE_BY_ZERO   = DWORD($C0000094);
  STATUS_INTEGER_OVERFLOW         = DWORD($C0000095);
  STATUS_PRIVILEGED_INSTRUCTION   = DWORD($C0000096);
  STATUS_STACK_OVERFLOW           = DWORD($C00000FD);
  STATUS_CONTROL_C_EXIT           = DWORD($C000013A);
  STILL_ACTIVE = STATUS_PENDING;
  
  { *************** some thing abount process **************************** }
  function CreateProcessA(lpApplicationName: PAnsiChar; lpCommandLine: PAnsiChar;
    lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
    bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
    lpCurrentDirectory: PAnsiChar; const lpStartupInfo: TStartupInfoA;
    var lpProcessInfo: TProcessInfo): BOOL; stdcall; external kernel32 name 'CreateProcessA';
  function TerminateProcess(AProcess: THandle; uExitCode: UINT): BOOL; stdcall; external kernel32 name 'TerminateProcess';
  function GetCurrentProcess: THandle; stdcall; external kernel32 name 'GetCurrentProcess';
  function GetCurrentProcessId: DWORD; stdcall; external kernel32 name 'GetCurrentProcessId';
  function OpenProcess(dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): THandle; stdcall; external kernel32 name 'OpenProcess';
  function ReadProcessMemory(AProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
    nSize: DWORD; var lpNumberOfBytesRead: DWORD): BOOL; stdcall; external kernel32 name 'ReadProcessMemory';
  function WriteProcessMemory(AProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
    nSize: DWORD; var lpNumberOfBytesWritten: DWORD): BOOL; stdcall; external kernel32 name 'WriteProcessMemory';

  function GetProcessHeap: THandle; stdcall; external kernel32 name 'GetProcessHeap';
  function GetProcessHeaps(NumberOfHeaps: DWORD; var ProcessHeaps: THandle): DWORD; stdcall; external kernel32 name 'GetProcessHeaps';
  function GetProcessTimes(AProcess: THandle; var lpCreationTime,
      lpExitTime, lpKernelTime, lpUserTime: TFileTime): BOOL; stdcall; external kernel32 name 'GetProcessTimes';
  function GetProcessVersion(AProcessId: DWORD): DWORD; stdcall; external kernel32 name 'GetProcessVersion';
  function GetProcessWorkingSetSize(AProcess: THandle; var lpMinimumWorkingSetSize,
      lpMaximumWorkingSetSize: DWORD): BOOL; stdcall; external kernel32 name 'GetProcessWorkingSetSize';

  function SetProcessWorkingSetSize(AProcess: THandle; dwMinimumWorkingSetSize,
      dwMaximumWorkingSetSize: DWORD): BOOL; stdcall; external kernel32 name 'SetProcessWorkingSetSize';
  function GetModuleFileNameA(AModule: HINST; lpFilename: PAnsiChar; nSize: DWORD): DWORD; stdcall; external kernel32 name 'GetModuleFileNameA';
  { *************** some thing abount thread **************************** }
  function CreateThread(lpThreadAttributes: Pointer;
    dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine;
    lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall; external kernel32 name 'CreateThread';
  function SuspendThread(AThread: THandle): DWORD; stdcall; external kernel32 name 'SuspendThread';
  function ResumeThread(AThread: THandle): DWORD; stdcall; external kernel32 name 'ResumeThread';
  function TerminateThread(AThread: THandle; dwExitCode: DWORD): BOOL; stdcall; external kernel32 name 'TerminateThread';
  procedure ExitThread(dwExitCode: DWORD); stdcall; external kernel32 name 'ExitThread';
  function GetCurrentThread: THandle; stdcall; external kernel32 name 'GetCurrentThread';
  function GetCurrentThreadId: DWORD; stdcall; external kernel32 name 'GetCurrentThreadId';

  { http://www.cnblogs.com/kex1n/archive/2011/05/09/2040924.html
    http://blog.csdn.net/solstice/article/details/5196544
    ���ʱ���������� x86 �� RDTSC ָ�����ָ�����ں�ʱ��
�Դ� Intel Pentium ���� RDTSC ָ������������ָ���� micro-benchmarking
�������������Լ�С�Ĵ��ۻ�ø߾��ȵ� CPU ʱ����������Time Stamp Counter����
���ٽ����Ż�������[1]���鼮�������Ƚ����δ���Ŀ����������еĴ����� RDTSC
ָ������ʱ�����滻 gettimeofday() ֮���ϵͳ���á��ڶ��ʱ����RDTSC ָ���
׼ȷ�ȴ�������ˣ�ԭ��������
    1.���ܱ�֤ͬһ��������ÿ���˵� TSC ��ͬ����
    2.CPU ��ʱ��Ƶ�ʿ��ܱ仯������ʼǱ����ԵĽ��ܹ���
    3.����ִ�е��� RDTSC ��õ���������׼���������� Pentium Pro ʱ���ʹ���

    ��Ȼ RDTSC �ϵ��ˣ����ܲ����õĸ߾��ȼ�ʱ�����а취�� [2]��
    �� Windows �� QueryPerformanceCounter �� QueryPerformanceFrequency��
    Linux ���� POSIX �� clock_gettime �������� CLOCK_MONOTONIC �������á�

    QueryPerformanceCounter() ������������Ҳ���������� SetThreadAffinityMask() ���
    SetThreadAffinityMask(GetCurrentThread(), 1);
    //timeConsuming();
    QueryPerformanceFrequency(&freq);

    dwThreadAffinityMask�����ǽ��̵���Ե�����ε���Ӧ�Ӽ�
    ����ֵ���̵߳�ǰһ����Ե������
    ��Ҫ��3���߳����Ƶ�CPU1��2��3��ȥ���У�������������
    SetThreadAffinityMask(hThread0, 0x00000001);
    SetThreadAffinityMask(hThread1, 0x0000000E);   1110
    SetThreadAffinityMask(hThread2, 0x0000000E);
    SetThreadAffinityMask(hThread3, 0x0000000E);
  }

  { GetProcessAffinityMask �õ����̿����д��������������֡�������2��ֵ��һ���ǵ�ǰ���̿����еģ�һ����ϵͳӵ�е�CPU
  }
  function GetProcessAffinityMask(hProcess: THandle; var lpProcessAffinityMask, lpSystemAffinityMask: DWORD): BOOL; stdcall; external kernel32 name 'GetProcessAffinityMask';
  function SetProcessAffinityMask(hProcess: THandle; dwProcessAffinityMask: DWORD): BOOL; stdcall; external kernel32 name 'SetProcessAffinityMask';

  function SetThreadAffinityMask(AThread: THandle; dwThreadAffinityMask: DWORD): DWORD; stdcall; external kernel32 name 'SetThreadAffinityMask';

  { GetSystemInfo(&SystemInfo);
    SystemInfo.dwNumberOfProcessors, SystemInfo.dwActiveProcessorMask
  }
  function SetThreadIdealProcessor(AThread: THandle; dwIdealProcessor: DWORD): BOOL; stdcall; external kernel32 name 'SetThreadIdealProcessor';

  { ��ȡһ�����жϽ��̵��˳����� }
  function GetExitCodeProcess(AProcess: THandle; var lpExitCode: DWORD): BOOL; stdcall; external kernel32 name 'GetExitCodeProcess';
  { ��ȡһ������ֹ�̵߳��˳����� �߳���δ�жϣ�����Ϊ����STILL_ACTIVE }
  function GetExitCodeThread(AThread: THandle; var lpExitCode: DWORD): BOOL; stdcall; external kernel32 name 'GetExitCodeThread';

  { ��̬�����߳����ȼ�,������ֹϵͳ����һ�������������̵߳����ȼ�
    GetProcessPriorityBoost��GetThreadPriorityBoost,SetFileInformationByHandle }
  function SetProcessPriorityBoost(AhThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'SetProcessPriorityBoost';
  function GetProcessPriorityBoost(AThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'GetProcessPriorityBoost';

  { �������ȼ������Ե���SetPriorityClass���ı�������ȼ���Ҳ���Ըı���̱���� }
  function SetPriorityClass(hProcess: THandle; dwPriorityClass: DWORD): BOOL; stdcall; external kernel32 name 'SetPriorityClass';
  function GetPriorityClass(hProcess: THandle): DWORD; stdcall; external kernel32 name 'GetPriorityClass';
  {
  dwLevel [in]  ���̹ر����ȼ��������ϵͳ�е��������̵ģ�.ϵͳ�Ӹ߼��𵽵ͼ���رս���.
  ��ߺ���͵Ĺر����ȼ�������ϵͳ����ã��û��Ĳ������������£�
  Value Meaning
    000�C0FF	System reserved last shutdown range.
    100�C1FF	Application reserved last shutdown range.
    200�C2FF	Application reserved "in between" shutdown range.
    300�C3FF	Application reserved first shutdown range.
    400�C4FF	System reserved first shutdown range.
  dwFlags
    [in] Flags. This parameter can be the following value.
    Value	Meaning
      SHUTDOWN_NORETRY The system terminates the process without displaying a retry dialog box for the user.
  }
  function SetProcessShutdownParameters(dwLevel, dwFlags: DWORD): BOOL; stdcall; external kernel32 name 'SetProcessShutdownParameters';

  function GetThreadLocale: LCID; stdcall; external kernel32 name 'GetThreadLocale';
  function SetThreadLocale(ALocale: LCID): BOOL; stdcall; external kernel32 name 'SetThreadLocale';
  
  function GetThreadPriority(AThread: THandle): Integer; stdcall; external kernel32 name 'GetThreadPriority';
  function SetThreadPriority(AThread: THandle; nPriority: Integer): BOOL; stdcall; external kernel32 name 'SetThreadPriority';

  { ��̬�����߳����ȼ���������ֹϵͳ����һ�������������̵߳����ȼ�SetProcessPriorityBoost��
    ������ֹϵͳ����ĳ���̵߳����ȼ�SetThreadPriorityBoost }
  function GetThreadPriorityBoost(AThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall;
      external kernel32 name 'GetThreadPriorityBoost';
  function SetThreadPriorityBoost(AThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall; external kernel32 name 'SetThreadPriorityBoost';

  { Win32����APIԭ��  http://blog.csdn.net/b2b160/article/details/4242894
   1. ContinueDebugEvent
   2. DebugActiveProcess
   3. DebugActiveProcessStop
   4. DebugBreak
   5. DebugBreakProcess
   6. FatalExit
   7. FlushInstructionCache
   8. GetThreadContext
   9. GetThreadSelectorEntry �˺�������ָ��ѡ�������̵߳������������ڵ�ַ
   10. IsDebuggerPresent
   11. OutputDebugString
   12. ReadProcessMemory
   13. SetThreadContext
   14. WaitForDebugEvent
   15. WriteProcessMemory
  }
  function GetThreadSelectorEntry(AThread: THandle; dwSelector: DWORD;
      var lpSelectorEntry: TLDTEntry): BOOL; stdcall; external kernel32 name 'GetThreadSelectorEntry';

  {
  hThread ���ʱ��ϢѰ����̵߳ľ�����þ��������е� THREAD_QUERY_INFORMATION �� THREAD_QUERY_LIMITED_INFORMATION ����Ȩ
  }
  function GetThreadTimes(hThread: THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime:
      TFileTime): BOOL; stdcall; external kernel32 name 'GetThreadTimes';

  //���������߳�
  // Sleep��SwitchToThread����
  {
  �������Ƿ���ʱ��Ƭ���������л������ϵ�һ��˵����Sleep(0)�����ڿɵ��ȵ�ͬ�ȼ����߸����ȼ����߳������ң�
  ��SwitchToThread����ȫϵͳ��Χ�������ȼ���Ҳ���ܻᱻ����
  }
  function SwitchToThread: BOOL; stdcall; external kernel32 name 'SwitchToThread';

  (*
  ��һ�������¼�����ʱ��Windows��ͣ�����Խ��̣��������� ���������ġ�
  ���ڽ��̱���ͣ���У����ǿ���ȷ����������������ݽ����ֲ��䡣
  ������GetThreadContext����ȡ�������������ݣ�����Ҳ������GetThreadContext ���޸Ľ�������������
  *)
  function GetThreadContext(AThread: THandle; var lpContext: TContext): BOOL; stdcall; external kernel32 name 'GetThreadContext';
  function SetThreadContext(AThread: THandle; const lpContext: TContext): BOOL; stdcall; external kernel32 name 'SetThreadContext';
  function CreateRemoteThread(AProcess: THandle; lpThreadAttributes: Pointer;
    dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer;
    dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall; external kernel32 name 'CreateRemoteThread';

  { *************** some thing abount fiber **************************** }
  function CreateFiber(dwStackSize: DWORD; lpStartAddress: TFNFiberStartRoutine;
    lpParameter: Pointer): Pointer; stdcall; external kernel32 name 'CreateFiber';
  function DeleteFiber(lpFiber: Pointer): BOOL; stdcall; external kernel32 name 'DeleteFiber';
  function ConvertThreadToFiber(lpParameter: Pointer): BOOL; stdcall; external kernel32 name 'ConvertThreadToFiber';
  function SwitchToFiber(lpFiber: Pointer): BOOL; stdcall; external kernel32 name 'SwitchToFiber';
  
  // win2008/Vista support
  function QueryFullProcessImageNameA(AProcess: THandle; dwFlags: DWORD;
    lpExeName: PAnsiChar; var lpdwSize: DWORD): BOOL; stdcall; external kernel32 name 'QueryFullProcessImageNameA';

  {
    һ���߳��ڲ��ĸ����������ö��ܷ��ʡ��������̲߳��ܷ��ʵı���
    ����Ϊstatic memory local to a thread �ֲ߳̾���̬������
    ����Ҫ�µĻ�����ʵ�֡������TLS

    Ϊ��ǰ�̶߳�̬����һ���ڴ�����ʹ��LocalAlloc()�������ã���Ȼ���ָ������ڴ������ָ�����TLS������Ӧ�Ĳ���(ʹ��TlsSetValue()��������)
  }
  function TlsAlloc: DWORD; stdcall; external kernel32 name 'TlsAlloc';

type                     
  TwDLLKernel_ProcThread  = record
    { *************** some thing abount process **************************** }
    CreateProcessA: function (lpApplicationName: PAnsiChar; lpCommandLine: PAnsiChar;
      lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
      bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
      lpCurrentDirectory: PAnsiChar; const lpStartupInfo: TStartupInfoA;
      var lpProcessInfo: TProcessInfo): BOOL; stdcall;
    TerminateProcess: function (AProcess: THandle; uExitCode: UINT): BOOL; stdcall;
    GetCurrentProcess: function : THandle; stdcall;
    GetCurrentProcessId: function : DWORD; stdcall;
    OpenProcess: function (dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwProcessId: DWORD): THandle; stdcall;
    ReadProcessMemory: function (AProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
      nSize: DWORD; var lpNumberOfBytesRead: DWORD): BOOL; stdcall;
    WriteProcessMemory: function (AProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
      nSize: DWORD; var lpNumberOfBytesWritten: DWORD): BOOL; stdcall;

    GetProcessHeap: function : THandle; stdcall;
    GetProcessHeaps: function (NumberOfHeaps: DWORD; var ProcessHeaps: THandle): DWORD; stdcall;
    GetProcessTimes: function (AProcess: THandle; var lpCreationTime,
        lpExitTime, lpKernelTime, lpUserTime: TFileTime): BOOL; stdcall;
    GetProcessVersion: function (AProcessId: DWORD): DWORD; stdcall;
    GetProcessWorkingSetSize: function (AProcess: THandle; var lpMinimumWorkingSetSize,
        lpMaximumWorkingSetSize: DWORD): BOOL; stdcall;

    SetProcessWorkingSetSize: function (AProcess: THandle; dwMinSize, dwMaxSize: DWORD): BOOL; stdcall;

    { *************** some thing abount thread **************************** }
    CreateThread: function (lpThreadAttributes: Pointer;
      dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine;
      lpParameter: Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall;
    SuspendThread: function (AThread: THandle): DWORD; stdcall;
    ResumeThread: function (AThread: THandle): DWORD; stdcall;
    TerminateThread: function (AThread: THandle; dwExitCode: DWORD): BOOL; stdcall;
    ExitThread: procedure (dwExitCode: DWORD); stdcall;
    GetCurrentThread: function : THandle; stdcall;
    GetCurrentThreadId: function : DWORD; stdcall;

    // ����ĳһ���߳�ֻ��������һ��CPU��
    (*���磬������4���̺߳�4�����õ�CPU���������߳�1��ռCPU 0��������3���߳�ֻ��������CPU 1��CPU 2��CPU 3�ϣ��������±��룺
    SetThreadAffinityMask(hThread0, 0x00000001);
    SetThreadAffinityMask(hThread1, 0x0000000E);
    SetThreadAffinityMask(hThread2, 0x0000000E);
    SetThreadAffinityMask(hThread3, 0x0000000E);
    *)
    SetThreadAffinityMask: function (AThread: THandle; dwThreadAffinityMask: DWORD): DWORD; stdcall;

    (*
    ���һ��Ҫ����
    �ú����ĵڶ�����������λ�������ݣ�����һ��0��31��32λϵͳ����0��63��64λϵͳ����������
    ������ָ����ѡ��CPU��Ҳ���Դ���MAXIMUM_PROCESSORS������ǰû�������CPU
    *)
    SetThreadIdealProcessor: function (AThread: THandle; dwIdealProcessor: DWORD): BOOL; stdcall;

    { ��ȡһ�����жϽ��̵��˳����� }
    GetExitCodeProcess: function (AProcess: THandle; var lpExitCode: DWORD): BOOL; stdcall;
    { ��ȡһ������ֹ�̵߳��˳����� �߳���δ�жϣ�����Ϊ����STILL_ACTIVE }
    GetExitCodeThread: function (AThread: THandle; var lpExitCode: DWORD): BOOL; stdcall;

    // ���Ե���GetProcessAffinityMask������ȡ��һ��������Ե��������Ϣ
    GetProcessAffinityMask: function (AProcess: THandle; var lpProcessAffinityMask, lpSystemAffinityMask: DWORD): BOOL; stdcall;
    // ����һ���ض��Ľ���ֻ��������CPU��һ���Ӽ���
    // ����Ҫ���ҵ��̰߳󶨵�cpu0����cpu2��cpu3�ϣ������������SetProcessAffinityMask(::GetCurrentProcrss( ) , 13L);
    SetProcessAffinityMask: function (AProcess: THandle; dwProcessAffinityMask: DWORD): BOOL; stdcall;


    SetProcessPriorityBoost: function (AThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall;
    GetProcessPriorityBoost: function (AThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall;
    SetProcessShutdownParameters: function (dwLevel, dwFlags: DWORD): BOOL; stdcall;

    GetThreadLocale: function : LCID; stdcall;
    SetThreadLocale: function (Locale: LCID): BOOL; stdcall;

    GetThreadPriority: function (AThread: THandle): Integer; stdcall;
    SetThreadPriority: function (AThread: THandle; nPriority: Integer): BOOL; stdcall;

    GetThreadPriorityBoost: function (AThread: THandle; var DisablePriorityBoost: Bool): BOOL; stdcall;
    SetThreadPriorityBoost: function (AThread: THandle; DisablePriorityBoost: Bool): BOOL; stdcall;
    GetThreadSelectorEntry: function (AThread: THandle; dwSelector: DWORD; var lpSelectorEntry: TLDTEntry): BOOL; stdcall;
    GetThreadTimes: function (AThread: THandle; var lpCreationTime, lpExitTime, lpKernelTime, lpUserTime: TFileTime): BOOL; stdcall;

    //���������߳�
    // Sleep��SwitchToThread����
    SwitchToThread: function : BOOL; stdcall;

    (*
    ��һ�������¼�����ʱ��Windows��ͣ�����Խ��̣��������� ���������ġ�
    ���ڽ��̱���ͣ���У����ǿ���ȷ����������������ݽ����ֲ��䡣
    ������GetThreadContext����ȡ�������������ݣ�����Ҳ������GetThreadContext ���޸Ľ�������������
    *)
    GetThreadContext: function (AThread: THandle; var lpContext: TContext): BOOL; stdcall;
    SetThreadContext: function (AThread: THandle; const lpContext: TContext): BOOL; stdcall;
    CreateRemoteThread: function (AProcess: THandle; lpThreadAttributes: Pointer;
      dwStackSize: DWORD; lpStartAddress: TFNThreadStartRoutine; lpParameter: Pointer;
      dwCreationFlags: DWORD; var lpThreadId: DWORD): THandle; stdcall;

    { *************** some thing abount fiber **************************** }
    CreateFiber: function (dwStackSize: DWORD; lpStartAddress: TFNFiberStartRoutine;
      lpParameter: Pointer): Pointer; stdcall;
    DeleteFiber: function (lpFiber: Pointer): BOOL; stdcall;
    ConvertThreadToFiber: function (lpParameter: Pointer): BOOL; stdcall;
    SwitchToFiber: function (lpFiber: Pointer): BOOL; stdcall;
  end;
  
implementation

(*
  //CreateProcess CREATE_SUSPENDED ���peb
  Context.ContextFlags := CONTEXT_FULL or CONTEXT_DEBUG_REGISTERS;
  function GetThreadContext(hThread: THandle; var lpContext: TContext): BOOL; stdcall;
  ResumeThread(lpProcessInfo.hThread) ;
*)
end.
