unit win.thread;

interface

uses
  BaseThread;

type
  PSysWinThread       = ^TSysWinThread;
  TSysWinThread       = record
    Core              : TSysThread;        
    OleInitStatus     : Integer; // CoInitialize(nil);
  end;
(*//
  Sleep(0)��ʱ��Ƭֻ���ø����ȼ���ͬ����ߵ��̣߳� 
  SwitchToThread()��ֻҪ�пɵ����̣߳��������ȼ��ϵͣ�Ҳ���������
//*)

implementation

end.
