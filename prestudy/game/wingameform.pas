unit wingameform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, utils_cards;

type
  TfrmWinGame = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    fCards_Mj: PCards_Mj;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  end;

var
  frmWinGame: TfrmWinGame;

implementation

{$R *.dfm}

uses
  define_MaJiang;
            
constructor TfrmWinGame.Create(Owner: TComponent);
begin
  inherited;
  fCards_Mj := nil;
end;

procedure TfrmWinGame.btn1Click(Sender: TObject);
var
  i: integer;
  tmpStr: string;
begin
  if nil = fCards_Mj then
  begin
    fCards_Mj := CheckOutCards_Mj;
  end;
  //ShuffleCards(PCards(fCards_Mj));
  mmo1.lines.BeginUpdate;
  try
    mmo1.lines.Clear;
    for i := Low(fCards_Mj.Card) to High(fCards_Mj.Card) do
    begin
      tmpStr := IntToStr(i) + ':' + IntToStr(fCards_Mj.Card[i].CardId) + #9;
      tmpStr := tmpStr + '[' + GetMJCaption(fCards_Mj.Card[i].CardId) + ']';
      tmpStr := tmpStr + '/' + #32#32#32 + IntToStr(fCards_Mj.Card[i].CardPos);
      mmo1.lines.Add(tmpStr);
    end;
  finally
    mmo1.lines.EndUpdate;
  end;
end;

end.
