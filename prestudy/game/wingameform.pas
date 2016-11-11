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
  public
    { Public declarations }
  end;

var
  frmWinGame: TfrmWinGame;

implementation

{$R *.dfm}

  
procedure TfrmWinGame.btn1Click(Sender: TObject);
var
  tmpCards_Mj: PCards_Mj;
  i: integer;
begin
  tmpCards_Mj := CheckOutCards_Mj;
  ShuffleCards(PCards(tmpCards_Mj));
  mmo1.lines.BeginUpdate;
  try
    mmo1.lines.Clear;
    for i := Low(tmpCards_Mj.Card) to High(tmpCards_Mj.Card) do
    begin
      mmo1.lines.Add(IntToStr(i) + ':' + IntToStr(tmpCards_Mj.Card[i].CardId) + '/' + IntToStr(tmpCards_Mj.Card[i].CardPos));
    end;
  finally
    mmo1.lines.EndUpdate;
  end;
//
end;

end.
