program SpaceEscaper;

uses
  System.StartUpCopy,
  FMX.Forms,
  uGame in 'src\uGame.pas' {GameForm},
  uPlayer in 'src\uPlayer.pas' {$R *.res},
  uBase in 'src\uBase.pas',
  uRoom in 'src\uRoom.pas',
  uMapDistributionTest in 'tests\uMapDistributionTest.pas',
  uEndingFailure in 'frames\uEndingFailure.pas' {FailureEndingFrame: TFrame},
  uEndingSuccess in 'frames\uEndingSuccess.pas' {SuccessEndingFrame: TFrame},
  uHUD in 'frames\uHUD.pas' {HUDFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;

end.
