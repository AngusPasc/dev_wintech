unit dll_kernel32_time;

interface
                
uses
  atmcmbaseconst, winconst, wintype;

  { *************** some thing abount system time **************************** }
  // ��ȡ���صĵ�ǰϵͳ���ں�ʱ��
  procedure GetLocalTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetLocalTime';
  function SetLocalTime(const lpSystemTime: TSystemTime): BOOL; stdcall; external kernel32 name 'SetLocalTime';
  
  function GetTickCount: DWORD; stdcall; external kernel32 name 'GetTickCount';

  function SetSystemTime(const lpSystemTime: TSystemTime): BOOL; stdcall; external kernel32 name 'SetSystemTime';
  // ���뵱ǰϵͳʱ�䣬���ʱ����õ��ǡ�Эͬ����ʱ�䡱����UTC��Ҳ����GMT����ʽ
  procedure GetSystemTime(var lpSystemTime: TSystemTime); stdcall; external kernel32 name 'GetSystemTime';

  // ��ʱ���һ��У׼ֵʹ�ڲ�ϵͳʱ����һ���ⲿ��ʱ���ź�Դͬ��
  function SetSystemTimeAdjustment(dwTimeAdjustment: DWORD; bTimeAdjustmentDisabled: BOOL): BOOL; stdcall; external kernel32 name 'SetSystemTimeAdjustment';
  // �ڲ�ϵͳʱ����һ���ⲿ��ʱ���ź�Դͬ��
  function GetSystemTimeAdjustment(var lpTimeAdjustment, lpTimeIncrement: DWORD; var lpTimeAdjustmentDisabled: BOOL): BOOL; stdcall; external kernel32 name 'GetSystemTimeAdjustment';

  procedure Sleep(dwMilliseconds: DWORD); stdcall; external kernel32 name 'Sleep';
  function SleepEx(dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall; external kernel32 name 'SleepEx';
  function CreateWaitableTimerA(lpTimerAttributes: PSecurityAttributes; bManualReset: BOOL;
      lpTimerName: PAnsiChar): THandle; stdcall; external kernel32 name 'CreateWaitableTimerA';
  function OpenWaitableTimerA(dwDesiredAccess: DWORD; bInheritHandle: BOOL;
      lpTimerName: PAnsiChar): THandle; stdcall; external kernel32 name 'OpenWaitableTimerA';
  function SetWaitableTimer(hTimer: THandle; var lpDueTime: TLargeInteger; lPeriod: Longint;
      pfnCompletionRoutine: TFNTimerAPCRoutine; lpArgToCompletionRoutine: Pointer;
      fResume: BOOL): BOOL; stdcall; external kernel32 name 'SetWaitableTimer';
  function CancelWaitableTimer(hTimer: THandle): BOOL; stdcall; external kernel32 name 'CancelWaitableTimer';

  function DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'DosDateTimeToFileTime';
  function LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'LocalFileTimeToFileTime';
  function SetFileTime(AFile: THandle; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall; external kernel32 name 'SetFileTime';

  function FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL; stdcall; external kernel32 name 'FileTimeToSystemTime';
  function SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall; external kernel32 name 'SystemTimeToFileTime';
  
type                
  TwDLLKernel_Time  = record
    GetLocalTime: procedure (var lpSystemTime: TSystemTime); stdcall;
    SetLocalTime: function (const lpSystemTime: TSystemTime): BOOL; stdcall;
    GetTickCount: function : DWORD; stdcall;
    SetSystemTime: function (const lpSystemTime: TSystemTime): BOOL; stdcall;
    GetSystemTime: procedure (var lpSystemTime: TSystemTime); stdcall;
    SetSystemTimeAdjustment: function (dwTimeAdjustment: DWORD; bTimeAdjustmentDisabled: BOOL): BOOL; stdcall;
    GetSystemTimeAdjustment: function (var lpTimeAdjustment, lpTimeIncrement: DWORD; var lpTimeAdjustmentDisabled: BOOL): BOOL; stdcall;
    Sleep: procedure (dwMilliseconds: DWORD); stdcall;
    SleepEx: function (dwMilliseconds: DWORD; bAlertable: BOOL): DWORD; stdcall;
    CreateWaitableTimer: function (lpTimerAttributes: PSecurityAttributes; bManualReset: BOOL; lpTimerName: PAnsiChar): THandle; stdcall;
    OpenWaitableTimer: function (dwDesiredAccess: DWORD; bInheritHandle: BOOL; lpTimerName: PAnsiChar): THandle; stdcall;
    SetWaitableTimer: function (hTimer: THandle; var lpDueTime: TLargeInteger; lPeriod: Longint;
        pfnCompletionRoutine: TFNTimerAPCRoutine; lpArgToCompletionRoutine: Pointer; fResume: BOOL): BOOL; stdcall;
    CancelWaitableTimer: function (hTimer: THandle): BOOL; stdcall;
    DosDateTimeToFileTime: function (wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall;
    LocalFileTimeToFileTime: function (const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall;
    SetFileTime: function (AFile: THandle; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
  end;

implementation

end.
