unit win.timer;

interface

uses
  Windows;
  // Windows��7�ֶ�ʱ��
  {
    1. WM_TIMER SetTimer ���ȷǳ���
        ��С��ʱ���Ƚ�Ϊ30ms CPUռ�õ�
        �Ҷ�ʱ����Ϣ�ڶ��������ϵͳ�е����ȼ��ܵ� ���ܵõ���ʱ��Ӧ
    2. sleep
    3. COleDateTime
    4. GetTickCount
        ��msΪ��λ�ļ��������������ʱ����
        ���ȱ�WM_TIMER��Ϣӳ���
        �ڽ϶̵Ķ�ʱ�����ʱ���Ϊ15ms
    5. DWORD timeGetTime(void) ��ý�嶨ʱ������
        ��ʱ�� ��Ϊms��
    6. timeSetEvent() ��ý�嶨ʱ��
        ������ʱ����Ϊms�� ���øú�������ʵ�������Եĺ�������
    7. QueryPerformanceFrequency()��
       QueryPerformanceCounter()
       ���ھ�ȷ��Ҫ����ߵĶ�ʱ���� ��Ӧ��ʹ��
       �䶨ʱ������1΢�룬������CPU�Ȼ��������й�
  }
           
type
  { �߾��� ��ʱ�� }
  PPerfTimer    = ^TPerfTimer;
  TPerfTimer    = record
    Frequency   : Int64;
    Start       : Int64;
    Stop        : Int64;
  end;

  PWinTimer     = ^TWinTimer;
  TWinTimer     = record
    Wnd         : HWND;    
    TimerID     : UINT;
    EventID     : UINT;
    Elapse      : UINT;
    TimerFunc   : TFNTimerProc;
  end;
  
  procedure PerfTimerStart(APerfTimer: PPerfTimer);

  function PerfTimerReadValue(APerfTimer: PPerfTimer): Int64;
  function PerfTimerReadNanoSeconds(APerfTimer: PPerfTimer): AnsiString;
  function PerfTimerReadMilliSeconds(APerfTimer: PPerfTimer): AnsiString;
  function PerfTimerReadSeconds(APerfTimer: PPerfTimer): AnsiString;
                         
  function GetTickCount: Cardinal;
  
  procedure StartWinTimer(ATimer: PWinTimer);
  procedure EndWinTimer(ATimer: PWinTimer);

implementation

uses
  Sysutils;
  
procedure PerfTimerStart(APerfTimer: PPerfTimer);
begin
  Windows.QueryPerformanceCounter(APerfTimer.Start);
end;

function PerfTimerReadValue(APerfTimer: PPerfTimer): Int64;
begin
  QueryPerformanceCounter(APerfTimer.Stop);
  QueryPerformanceFrequency(APerfTimer.Frequency);
  Assert(APerfTimer.Frequency > 0);
  Result := Round(1000000 * (APerfTimer.Stop - APerfTimer.Start) / APerfTimer.Frequency);
end;

function PerfTimerReadNanoseconds(APerfTimer: PPerfTimer): string;
begin
  QueryPerformanceCounter(APerfTimer.Stop);
  QueryPerformanceFrequency(APerfTimer.Frequency);
  Assert(APerfTimer.Frequency > 0);

  Result := IntToStr(Round(1000000 * (APerfTimer.Stop - APerfTimer.Start) / APerfTimer.Frequency));
end;

function PerfTimerReadMilliseconds(APerfTimer: PPerfTimer): string;
begin
  QueryPerformanceCounter(APerfTimer.Stop);
  QueryPerformanceFrequency(APerfTimer.Frequency);
  Assert(APerfTimer.Frequency > 0);

  Result := FloatToStrF(1000 * (APerfTimer.Stop - APerfTimer.Start) / APerfTimer.Frequency, ffFixed, 15, 3);
end;

function PerfTimerReadSeconds(APerfTimer: PPerfTimer): String;
begin
  QueryPerformanceCounter(APerfTimer.Stop);
  QueryPerformanceFrequency(APerfTimer.Frequency);
  Result := FloatToStrF((APerfTimer.Stop - APerfTimer.Start) / APerfTimer.Frequency, ffFixed, 15, 3);
end;

function GetTickCount: Cardinal;
begin
  Result := Windows.GetTickCount;
end;

procedure StartWinTimer(ATimer: PWinTimer);
begin
  ATimer.TimerID := Windows.SetTimer(ATimer.Wnd, ATimer.EventID, ATimer.Elapse, ATimer.TimerFunc);
end;

procedure EndWinTimer(ATimer: PWinTimer);
begin
  Windows.KillTimer(ATimer.Wnd, ATimer.TimerId);
end;

end.
