unit BaseWinTimer;

interface

uses
  Windows;
  
type
  PWinTimer = ^TWinTimer;
  TWinTimer = record
    WndHandle: HWND;
    TimerID: UINT;
    Elapse: UINT;
    TimerProc: TFNTimerProc;
  end;

  PWinWaitableTimer = ^TWinWaitableTimer;
  TWinWaitableTimer = record
    Handle  : THandle;
  end;

implementation
     
procedure InitializeTimer(ATimer: PWinTimer);
begin
  ATimer.TimerID := Windows.SetTimer(ATimer.WndHandle, ATimer.TimerID, ATimer.Elapse, ATimer.TimerProc);
end;

(*
    �����ɵȴ���ʱ����Windows�ڲ��߳�ͬ���ķ�ʽ֮һ
    ���ļ򵥽������ʹ����һ�ں˶�������߳�ͬ��
*)

procedure InitializeWaitableTimer(ATimer: PWinWaitableTimer);
begin
   ATimer.Handle := CreateWaitableTimer(nil, true, '');
   //CreateWaitableTimer������ɺ��ں˶�����δ����״̬����Ҫʹ��API
   //SetWaitableTimer(ATimer.Handle,
     // pDueTime�ǵ�һ�δ���ʱ�� UTCʱ��
   //);
end;

end.
