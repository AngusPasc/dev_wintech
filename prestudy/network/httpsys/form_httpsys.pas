unit form_httpsys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  win.httpsys;

var
  LibHttpSys: TLibHttpSys = (
    Module: 0
  );

procedure TForm1.btn1Click(Sender: TObject);
begin
  HttpApiInitialize(@LibHttpSys);
  if 0 <> LibHttpSys.Module then
    exit;
end;

end.
