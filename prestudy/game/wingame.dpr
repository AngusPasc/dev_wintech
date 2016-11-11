program wingame;

uses
  Forms,
  wingameform in 'wingameform.pas' {frmWinGame},
  define_MaJiang in 'define_MaJiang.pas',
  utils_cards in 'utils_cards.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmWinGame, frmWinGame);
  Application.Run;
end.
