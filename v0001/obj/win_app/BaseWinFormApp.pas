unit BaseWinFormApp;

interface

uses
  Forms,
  BaseApp,
  BaseForm,
  BaseWinApp;

type               
  PBaseWinFormAppData = ^TBaseWinFormAppData;
  TBaseWinFormAppData = record

  end;
  
  TBaseWinFormApp = class(TBaseWinApp)
  protected     
    fBaseWinFormAppData: TBaseWinFormAppData;  
  public                
    constructor Create(AppClassId: AnsiString); override;
    function Initialize: Boolean; override;      
    procedure Run; override;
  end;
               
  TWinFormAppClass = class of TBaseWinFormApp;
         
  TBaseWinFormAppAgent = class(TBaseWinAppAgent)
  protected
  public          
    constructor Create(AHostApp: TBaseApp); override;
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;    
  end;
  
var
  GlobalBaseWinFormApp: TBaseWinFormApp = nil;
                   
  procedure SimpleRunWinFormApp(AFormClass: TBaseFormClass; AppClass: TWinFormAppClass = nil);

implementation
                  
procedure SimpleRunWinFormApp(AFormClass: TBaseFormClass; AppClass: TWinFormAppClass = nil);
var
  tmpForm: TfrmBase;
begin
  if nil = AFormClass then
    exit;
  if nil = GlobalBaseWinFormApp then
  begin
    if nil = AppClass then
    begin
      GlobalBaseWinFormApp := TBaseWinFormApp.Create(AFormClass.ClassName);
    end else
    begin
      GlobalBaseWinFormApp := AppClass.Create(AppClass.ClassName);
    end;
    try
      if GlobalBaseWinFormApp.Initialize then
      begin
        Application.CreateForm(AFormClass, tmpForm);
        tmpForm.Initialize(GlobalBaseWinFormApp);
        GlobalBaseWinFormApp.Run;
      end;
      GlobalBaseWinFormApp.RunStatus := RunStatus_RequestShutdown;
      GlobalBaseWinFormApp.Finalize;
    finally         
      GlobalBaseWinFormApp.RunStatus := RunStatus_Shutdown;
      GlobalBaseWinFormApp.Free;
    end;
  end;
end;

{ TBaseWinFormApp }
                   
constructor TBaseWinFormApp.Create(AppClassId: AnsiString);
begin
  inherited Create(AppClassId);
  FillChar(fBaseWinFormAppData, SizeOf(fBaseWinFormAppData), 0);
  GlobalBaseWinFormApp := Self;
end;

function TBaseWinFormApp.Initialize: Boolean;
begin
  Result := inherited Initialize;
  Application.Initialize;
  Application.MainFormOnTaskBar := true;
end;

procedure TBaseWinFormApp.Run;
begin
  Application.Run;
end;

constructor TBaseWinFormAppAgent.Create(AHostApp: TBaseApp);
begin
  inherited Create(AHostApp);
end;
    
function TBaseWinFormAppAgent.Initialize: Boolean; 
begin
  Result := inherited Initialize;
  if Result then
  begin
    Application.Initialize;
    Application.MainFormOnTaskBar := true;
  end;
end;

procedure TBaseWinFormAppAgent.Finalize; 
begin
  inherited;
end;

procedure TBaseWinFormAppAgent.Run; 
begin
  inherited;
  Application.Run;
end;    

end.
