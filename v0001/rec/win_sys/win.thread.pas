unit win.thread;

interface

uses
  base.thread;

type
  PSysWinThread       = ^TSysWinThread;
  
  TThreadProc         = function(AThread: PSysWinThread): HRESULT; stdcall;

  TSysWinThread       = record
    Core              : TSysThread;        
    OleInitStatus     : Integer; // CoInitialize(nil);
    ThreadProc        : TThreadProc;
    ExitCode          : Integer;
  end;
(*//
  Sleep(0)��ʱ��Ƭֻ���ø����ȼ���ͬ����ߵ��̣߳� 
  SwitchToThread()��ֻҪ�пɵ����̣߳��������ȼ��ϵͣ�Ҳ���������
//*)

  procedure ThreadStart(AThread: PSysWinThread);
  procedure ThreadShutdown(AThread: PSysWinThread);
  procedure ThreadPause(AThread: PSysWinThread);
  procedure ThreadResume(AThread: PSysWinThread);

implementation

uses
  Windows;

procedure ThreadStart(AThread: PSysWinThread);
begin
  AThread.Core.ThreadHandle := Windows.CreateThread(nil, 0, @AThread.ThreadProc, AThread, CREATE_SUSPENDED, AThread.Core.ThreadId);
  Windows.ResumeThread(AThread.Core.ThreadHandle);
end;

procedure ThreadShutdown(AThread: PSysWinThread);
begin
  Windows.TerminateThread(AThread.Core.ThreadHandle, AThread.ExitCode);
end;

procedure ThreadPause(AThread: PSysWinThread);
begin
  Windows.SuspendThread(AThread.Core.ThreadHandle);
end;

procedure ThreadResume(AThread: PSysWinThread);
begin
  Windows.ResumeThread(AThread.Core.ThreadHandle);
end;

end.
