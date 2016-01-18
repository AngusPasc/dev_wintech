unit BaseRun;

interface

type        
  // LogicSessionStep
  PProcStep           = ^TProcStep;
  TProcStep           = record
    MainStep          : integer;
    ChildStep         : integer;
    StepIParam        : integer;
    StepPParam        : Pointer;
  end;

  // application has many sessions at same time
  PLogicSession       = ^TLogicSession;
  TLogicSession       = record
    CurrentStep       : PProcStep;
  end;

  PLogicBaseStep      = ^TLogicBaseStep;
  TLogicBaseStep      = record
    StepType          : Integer;
  end;

  PLogicStep1         = ^TLogicStep1;
  TLogicStep1         = record
    Base              : TLogicBaseStep;
    NextStep          : PLogicBaseStep;
  end;
  
  PLogicStep2         = ^TLogicStep2;
  TLogicStep2         = record
    Base              : TLogicBaseStep;
    NextStep1         : PLogicBaseStep;
    NextStep2         : PLogicBaseStep;    
  end;
  // logic model
  PLogicModel         = ^TLogicModel;
  TLogicModel         = record
    // ���
    FirstStep         : PLogicBaseStep;
  end;

  TThreadRunStatus    = record
    // һ�µĲ������� �̵߳ļ��
    RunStep           : Cardinal;
    RunStepBeginTick  : Cardinal;
    RunLoopBeginTick  : Cardinal;
    LoopCondition     : Cardinal; // While while 1 = loopcondition do
                               // loopcondition := 1; Repeat Until 0 = loopcondition;
    LoopForMax        : Cardinal; // for i := 0 to LoopMax
    LoopCounter       : Cardinal; // for
  end;

implementation

end.
