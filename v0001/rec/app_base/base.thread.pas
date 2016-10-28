unit base.thread;

interface

uses
  base.run;
               
type
  PSysThread          = ^TSysThread;
  TSysThread          = record
    ThreadHandle      : THandle;
    ThreadId          : Cardinal;
    IsActiveStatus    : Integer; 
    RunStatus         : TThreadRunStatus;
  end;
  
  TUIThread           = record
    Base              : ^TSysThread;          
  end;
                
  TNetThread          = record
    Base              : ^TSysThread;          
  end;

  // store
  TDBThread           = record
    Base              : ^TSysThread;          
  end;
  
  TBusiThread         = record
    Base              : ^TSysThread;
  end;

implementation

end.
