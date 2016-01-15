unit dll_kernel32_sysobj;

interface
                  
uses
  atmcmbaseconst, winconst, wintype;

const                 
  MAXIMUM_WAIT_OBJECTS = 64;
type
  TWOHandleArray = array[0..MAXIMUM_WAIT_OBJECTS - 1] of THandle;
  PWOHandleArray = ^TWOHandleArray;
                 
  PRTLCriticalSection = ^TRTLCriticalSection;
  PRTLCriticalSectionDebug = ^TRTLCriticalSectionDebug;
  TRTLCriticalSectionDebug = record
    Type_18: Word;
    CreatorBackTraceIndex: Word;
    CriticalSection: PRTLCriticalSection;
    ProcessLocksList: TListEntry;
    EntryCount: DWORD;
    ContentionCount: DWORD;
    Spare: array[0..1] of DWORD;
  end;

  TRTLCriticalSection = record
    DebugInfo: PRTLCriticalSectionDebug;
    LockCount: Longint;
    RecursionCount: Longint;
    OwningThread: THandle;
    LockSemaphore: THandle;
    Reserved: DWORD;
  end;

  { *************** some thing abount system object **************************** }
  function WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD): DWORD; stdcall; external kernel32 name 'WaitForSingleObject';
  function WaitForSingleObjectEx(hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'WaitForSingleObjectEx';
  function WaitForMultipleObjects(nCount: DWORD; lpHandles: PWOHandleArray;
    bWaitAll: BOOL; dwMilliseconds: DWORD): DWORD; stdcall; external kernel32 name 'WaitForMultipleObjects';
  function WaitForMultipleObjectsEx(nCount: DWORD; lpHandles: PWOHandleArray;
    bWaitAll: BOOL; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'WaitForMultipleObjectsEx';

(*
http://blog.163.com/dhp_blog/blog/static/110635385200972881139158/
�첽���̵���(apcs)ʵ�ַ�����

  �첽���̵��ã�callback�ص���������һ��Overlapped I/O���֮��ϵͳ���øûص�������
  OS�����ź�״̬��(�豸���)���Ż���ûص������������кܶ�APCS�ȴ������ˣ���������
  ���I/O����Ĵ����룬�����ֽ�����Overlapped�ṹ�ĵ�ַ��
  
  ����������������ź�״̬��
  1�� SleepEx
  2�� WaitForSingleObjectEx
  3�� WaitForMultipleObjectEx
  4�� SignalObjectAndWait
  5�� MsgWaitForMultipleObjectsEx
*)
  function SignalObjectAndWait(hObjectToSignal: THandle; hObjectToWaitOn: THandle;
    dwMilliseconds: DWORD; bAlertable: BOOL): BOOL; stdcall; external kernel32 name 'SignalObjectAndWait';
    
  procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'InitializeCriticalSection';
  procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'DeleteCriticalSection';
  procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'EnterCriticalSection';
  procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall; external kernel32 name 'LeaveCriticalSection';

  function CreateMutexA(lpMutexAttributes: PSecurityAttributes; bInitialOwner: Integer; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateMutexA';
  {
    dwDesiredAccess:
      MUTEX_ALL_ACCESS    0x1F0001
      MUTEX_MODIFY_STATE  0x0001
      CreateMutex ����һ���������
      WaitForSingleObject �õȴ������ŶӵȺ�
      ReleaseMutex �ͷ�ӵ��Ȩ
      CloseHandle ����ͷŻ������
      http://www.birdol.com/page/50
  AppMutexHandle := CreateMutex(nil, False, AMutexName);
  Result := GetLastError <> ERROR_ALREADY_EXISTS;
//  if not Result then
//  begin
//    ReleaseMutex(AppMutexHandle);
//  end;
  }
  function OpenMutexA(dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'OpenMutexA';
  function ReleaseMutex(hMutex: THandle): BOOL; stdcall; external kernel32 name 'ReleaseMutex';
  function CreateEventA(lpEventAttributes: PSecurityAttributes;
    bManualReset, bInitialState: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateEventA';
  function OpenEventA(dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'OpenEventA';
  function SetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'SetEvent';
  function ResetEvent(hEvent: THandle): BOOL; stdcall; external kernel32 name 'ResetEvent';
  function CreateSemaphoreA(lpSemaphoreAttributes: PSecurityAttributes;
    lInitialCount, lMaximumCount: Longint; lpName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateSemaphoreA';

  function OpenSemaphoreA(dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall;
    external kernel32 name 'OpenSemaphoreA';
  function ReleaseSemaphore(hSemaphore: THandle; lReleaseCount: Longint;
    lpPreviousCount: Pointer): BOOL; stdcall; external kernel32 name 'ReleaseSemaphore';

                          
  function ConnectNamedPipe(hNamedPipe: THandle; lpOverlapped: POverlapped): BOOL; stdcall; external kernel32 name 'ConnectNamedPipe';
  function DisconnectNamedPipe(hNamedPipe: THandle): BOOL; stdcall; external kernel32 name 'DisconnectNamedPipe';
  function WaitNamedPipeA(lpNamedPipeName: PAnsiChar; nTimeOut: DWORD): BOOL; stdcall; external kernel32 name 'WaitNamedPipeA';
  function CreateNamedPipeA(lpName: PAnsiChar;
    dwOpenMode, dwPipeMode, nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWORD;
    lpSecurityAttributes: PSecurityAttributes): THandle; stdcall; external kernel32 name 'CreateNamedPipeA';
  function CallNamedPipeA(lpNamedPipeName: PAnsiChar; lpInBuffer: Pointer;
    nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
    var lpBytesRead: DWORD; nTimeOut: DWORD): BOOL; stdcall; external kernel32 name 'CallNamedPipeA';

type
  TwDLLKernel_SysObj  = record
    //---------------------------------------     
    WaitForSingleObject: function (hHandle: THandle; dwMilliseconds: DWORD): DWORD; stdcall;
    WaitForSingleObjectEx: function (hHandle: THandle; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall;
    WaitForMultipleObjects: function (nCount: DWORD; lpHandles: PWOHandleArray; bWaitAll: BOOL; dwMilliseconds: DWORD): DWORD; stdcall;
    WaitForMultipleObjectsEx: function (nCount: DWORD; lpHandles: PWOHandleArray; WaitAll: BOOL; dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall;
    SignalObjectAndWait: function (hObjectToSignal: THandle; hObjectToWaitOn: THandle; wMilliseconds: DWORD; bAlertable: BOOL): BOOL; stdcall;
    //---------------------------------------     
    InitializeCriticalSection: procedure (var lpCriticalSection: TRTLCriticalSection); stdcall;
    DeleteCriticalSection: procedure (var lpCriticalSection: TRTLCriticalSection); stdcall;
    EnterCriticalSection: procedure (var lpCriticalSection: TRTLCriticalSection); stdcall;
    LeaveCriticalSection: procedure (var lpCriticalSection: TRTLCriticalSection); stdcall;
    //---------------------------------------     
    CreateMutex: function (lpMutexAttributes: PSecurityAttributes; bInitialOwner: BOOL; lpName: PAnsiChar): THandle; stdcall;
    OpenMutex: function (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall;
    ReleaseMutex: function (hMutex: THandle): BOOL; stdcall;
    //---------------------------------------     
    CreateEvent: function (lpEventAttributes: PSecurityAttributes; bManualReset, bInitialState: BOOL; lpName: PAnsiChar): THandle; stdcall;
    OpenEvent: function (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall;
    SetEvent: function (hEvent: THandle): BOOL; stdcall;
    ResetEvent: function (hEvent: THandle): BOOL; stdcall;
    //---------------------------------------     
    CreateSemaphore: function (lpSemaphoreAttributes: PSecurityAttributes; lInitialCount, lMaximumCount: Longint; lpName: PAnsiChar): THandle; stdcall;
    OpenSemaphore: function (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpName: PAnsiChar): THandle; stdcall;
    ReleaseSemaphore: function (hSemaphore: THandle; lReleaseCount: Longint; lpPreviousCount: Pointer): BOOL; stdcall;
    //---------------------------------------     
    ConnectNamedPipe: function (hNamedPipe: THandle; lpOverlapped: POverlapped): BOOL; stdcall;
    DisconnectNamedPipe: function (hNamedPipe: THandle): BOOL; stdcall;
    WaitNamedPipe: function (lpNamedPipeName: PAnsiChar; nTimeOut: DWORD): BOOL; stdcall;
    CreateNamedPipe: function (lpName: PAnsiChar; dwOpenMode, dwPipeMode, nMaxInstances, nOutBufferSize, nInBufferSize, nDefaultTimeOut: DWORD;
        lpSecurityAttributes: PSecurityAttributes): THandle; stdcall;
    CallNamedPipe: function (lpNamedPipeName: PAnsiChar; lpInBuffer: Pointer; nInBufferSize: DWORD; lpOutBuffer: Pointer; nOutBufferSize: DWORD;
        var lpBytesRead: DWORD; nTimeOut: DWORD): BOOL; stdcall;
    //---------------------------------------     
  end;

implementation

end.
