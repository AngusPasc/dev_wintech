unit BaseApp;

interface

uses
  BasePath;

const
  RunStatus_AppCreated    = 1;

  RunStatus_Init_Start    = 11;
  RunStatus_Init_Succ     = 12;
  RunStatus_Init_Fail     = 13;

  RunStatus_Active        = 21;
  RunStatus_Suspend       = 22; // 待定；悬而不决

  RunStatus_RequestShutdown = 31;
  RunStatus_Finalize      = 32;
  RunStatus_Shutdown      = 33;

  RunMode_Normal          = 2;
  RunMode_Release         = 3;
  RunMode_Debug           = 4;

  //RunMode_BaseAppEx       = 10;
  // 关闭 log
  LogMode_None            = 1;
  LogMode_Normal          = 2;   
  LogMode_Exception       = 4;

type                    
  TBaseAppPath = class;
  TBaseAppAgent = class;
  
  PBaseAppData      = ^TBaseAppData;
  TBaseAppData      = packed record
    RunStatus       : Word;
    RunMode         : Word;
    LogMode         : Word;
    AppAgent        : TBaseAppAgent;
    AppClassId      : AnsiString;
  end;

  TBaseApp = class
  protected
    fBaseAppData: TBaseAppData; 
    function GetPath: TBaseAppPath; virtual;
    function GetBaseAppData: PBaseAppData;
  public
    constructor Create(AppClassId: AnsiString); virtual;
    destructor Destroy; override;

    function Initialize: Boolean; virtual;
    procedure Finalize; virtual;
    procedure Run; virtual;
    procedure Terminate; virtual;
    property BaseAppData: PBaseAppData read GetBaseAppData;
    property RunStatus: Word read fBaseAppData.RunStatus write fBaseAppData.RunStatus;
    property RunMode: Word read fBaseAppData.RunMode write fBaseAppData.RunMode;
    property LogMode: Word read fBaseAppData.LogMode write fBaseAppData.LogMode;
    property Path: TBaseAppPath read GetPath;
    property AppAgent: TBaseAppAgent read fBaseAppData.AppAgent write fBaseAppData.AppAgent;
  end;

  TBaseAppAgentData = record
    HostApp: TBaseApp;
  end;
  
  TBaseAppAgent = class
  protected
    fBaseAppAgentData: TBaseAppAgentData;
  public
    constructor Create(AHostApp: TBaseApp); virtual;
    function Initialize: Boolean; virtual;
    procedure Finalize; virtual;
    procedure Run; virtual;    
    property HostApp: TBaseApp read fBaseAppAgentData.HostApp;
  end;

  TBaseAppObjData = record
    App: TBaseApp;
  end;
  
  TBaseAppObj = class
  protected
    fBaseAppObjData: TBaseAppObjData;
  public
    constructor Create(App: TBaseApp); virtual;
  end;
           
  TBaseAppPathData = record
    App: TBaseApp;
  end;
  
  TBaseAppPath = class(TBasePath)
  protected     
    fBaseAppPathData: TBaseAppPathData;
  public          
    constructor Create(App: TBaseApp); virtual;
  end;
  
  TBaseAppClass = class of TBaseApp;
    
var
  GlobalBaseApp: TBaseApp = nil;

{
  RunApp(TzsHelperApp, 'zshelperApp', TBaseApp(GlobalApp));
}
  function RunApp(AppClass: TBaseAppClass; AppClassId: AnsiString; var AGlobalApp: TBaseApp): TBaseApp;

implementation

function RunApp(AppClass: TBaseAppClass; AppClassId: AnsiString; var AGlobalApp: TBaseApp): TBaseApp;
begin
  GlobalBaseApp := AppClass.Create(AppClassId);
  try    
    AGlobalApp := GlobalBaseApp;
    Result := GlobalBaseApp;
    if GlobalBaseApp.Initialize then
    begin
      GlobalBaseApp.Run;
    end;                  
    GlobalBaseApp.RunStatus := RunStatus_RequestShutdown;
    GlobalBaseApp.Finalize;
  finally                
    GlobalBaseApp.RunStatus := RunStatus_Shutdown;
    GlobalBaseApp.Free;
  end;
end;
              
{ TBaseApp }
                         
constructor TBaseApp.Create(AppClassId: AnsiString);
begin
  GlobalBaseApp := Self;
  FillChar(fBaseAppData, SizeOf(fBaseAppData), 0);
  fBaseAppData.AppClassId := AppClassId; 
  fBaseAppData.RunStatus := RunStatus_AppCreated;
  fBaseAppData.RunMode := RunMode_Normal;
end;

destructor TBaseApp.Destroy;
begin
  inherited;
end;

function TBaseApp.GetPath: TBaseAppPath;
begin
  Result := nil;
end;

function TBaseApp.Initialize: Boolean;
begin
  Result := true;
  fBaseAppData.RunStatus := RunStatus_Init_Start;
end;

procedure TBaseApp.Finalize;
begin
end;

function TBaseApp.GetBaseAppData: PBaseAppData;
begin
  Result := @fBaseAppData;
end;

procedure TBaseApp.Run;
begin
  fBaseAppData.RunStatus := RunStatus_Active;
end;

procedure TBaseApp.Terminate;
begin
end;
{ TBaseAppObj }

constructor TBaseAppObj.Create(App: TBaseApp);
begin
  FillChar(fBaseAppObjData, SizeOf(fBaseAppObjData), 0);
  fBaseAppObjData.App := App;
end;

{ TBaseAppPath }

constructor TBaseAppPath.Create(App: TBaseApp);
begin
  FillChar(fBaseAppPathData, SizeOf(fBaseAppPathData), 0);
  fBaseAppPathData.App := App;
end;

{ TBaseAppAgent }

constructor TBaseAppAgent.Create(AHostApp: TBaseApp);
begin
  FillChar(fBaseAppAgentData, SizeOf(fBaseAppAgentData), 0);
  fBaseAppAgentData.HostApp := AHostApp;
end;

function TBaseAppAgent.Initialize: Boolean;
begin
  Result := True;
end;

procedure TBaseAppAgent.Finalize;
begin
end;

procedure TBaseAppAgent.Run;
begin
  fBaseAppAgentData.HostApp.RunStatus := RunStatus_Active;
end;

end.
