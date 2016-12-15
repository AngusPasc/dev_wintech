unit wingameform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, utils_cards, ExtCtrls, define_card,
  define_Poker, define_MaJiang, poker_ddz;

type
  TFormData_WinGame = record
    Cards_Mj: PCards_Mj;
    Cards_Poker: PCards_Poker2;
    DDZRoundSession: PDDZRoundSession;
  end;
  
  TfrmWinGame = class(TForm)
    btnMjTest: TButton;
    mmo1: TMemo;
    btnPokerTest: TButton;
    pnlDDZ: TPanel;
    btnDDZ1: TButton;
    btnPlayer1: TButton;
    btnPlayer2: TButton;
    btnPlayer3: TButton;
    edtCard1: TEdit;
    edtCard2: TEdit;
    edtCard3: TEdit;
    procedure btnMjTestClick(Sender: TObject);
    procedure btnPokerTestClick(Sender: TObject);
    procedure btnDDZ1Click(Sender: TObject);
    procedure btnPlayer2Click(Sender: TObject);
    procedure btnPlayer1Click(Sender: TObject);
    procedure btnPlayer3Click(Sender: TObject);
  private
    { Private declarations }
    fFormData_WinGame: TFormData_WinGame;     
    procedure LogCards(ACards: PCards; AMode: Integer);
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
  end;

var
  frmWinGame: TfrmWinGame;

implementation

{$R *.dfm}


constructor TfrmWinGame.Create(Owner: TComponent);
begin
  inherited;
  FillChar(fFormData_WinGame, SizeOf(fFormData_WinGame), 0);
end;

procedure TfrmWinGame.btnMjTestClick(Sender: TObject);
var
  i: integer;
  tmpStr: string;
begin
  if nil = fFormData_WinGame.Cards_Mj then
  begin
    fFormData_WinGame.Cards_Mj := CheckOutCards_Mj;
  end;                             
  InitCards(PCards(fFormData_WinGame.Cards_Mj));
  //ShuffleCards(PCards(fCards_Mj));   
  LogCards(PCards(fFormData_WinGame.Cards_Mj), 2);
end;

procedure TfrmWinGame.LogCards(ACards: PCards; AMode: Integer); 
var
  i: integer;
  tmpStr: string;
begin
  mmo1.lines.BeginUpdate;
  try
    mmo1.lines.Clear;        
    for i := FirstCardIndex to FirstCardIndex + ACards.CardCount - 1 do
    begin
      tmpStr := '';
      if 1 = AMode then
      begin
        tmpStr := IntToStr(i) + ':' + IntToStr(ACards.Card[i].CardId) + #9;
        tmpStr := tmpStr + '[' + GetPokerCaption(ACards.Card[i].CardId) + ']';
        tmpStr := tmpStr + '/' + #32#32#32 + IntToStr(ACards.Card[i].CardPos);
      end;
      if 2 = AMode then
      begin
        tmpStr := IntToStr(i) + ':' + IntToStr(ACards.Card[i].CardId) + #9;
        tmpStr := tmpStr + '[' + GetMJCaption(ACards.Card[i].CardId) + ']';
        tmpStr := tmpStr + '/' + #32#32#32 + IntToStr(ACards.Card[i].CardPos);
      end;
      if '' <> tmpStr then
        mmo1.lines.Add(tmpStr);
    end;
  finally
    mmo1.lines.EndUpdate;
  end;
end;

procedure TfrmWinGame.btnPokerTestClick(Sender: TObject);
begin
  if nil = fFormData_WinGame.Cards_Poker then
  begin
    fFormData_WinGame.Cards_Poker := CheckOutCards_Poker2;
  end;                
  InitCards(PCards(fFormData_WinGame.Cards_Poker));
  //ShuffleCards(PCards(fFormData_WinGame.Cards_Poker));

  LogCards(PCards(fFormData_WinGame.Cards_Poker), 1);
end;

procedure TfrmWinGame.btnDDZ1Click(Sender: TObject);
begin
// DDZ Step1 -- Ï´ÅÆ
//     Step2 -- ·¢ÅÆ
//     Step3 -- ÇÀ×¯
//     Step4 -- Round
  if nil = fFormData_WinGame.DDZRoundSession then
  begin
    fFormData_WinGame.DDZRoundSession := CheckOutDDZRoundSession;
  end;
  if nil = fFormData_WinGame.DDZRoundSession.Cards_Poker then
  begin
    fFormData_WinGame.DDZRoundSession.Cards_Poker := CheckOutCards_Poker1;
    InitCards(PCards(fFormData_WinGame.DDZRoundSession.Cards_Poker));
    ShuffleCards(PCards(fFormData_WinGame.DDZRoundSession.Cards_Poker));
    LogCards(PCards(fFormData_WinGame.DDZRoundSession.Cards_Poker), 1);
  end;
end;

procedure TfrmWinGame.btnPlayer1Click(Sender: TObject);
begin
//
end;

procedure TfrmWinGame.btnPlayer2Click(Sender: TObject);
begin
//
end;

procedure TfrmWinGame.btnPlayer3Click(Sender: TObject);
begin
//
end;

end.
