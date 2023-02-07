program SpaceEscaper;

uses
  System.StartUpCopy,
  FMX.Forms,
  uGame in 'src\uGame.pas' {GameForm},
  uPlayer in 'src\uPlayer.pas' {$R *.res},
  uBase in 'src\uBase.pas',
  uRoom in 'src\uRoom.pas',
  uMapDistributionTest in 'tests\uMapDistributionTest.pas',
  uEndingSuccess in 'forms\uEndingSuccess.pas' {SuccessEndingFrame: TFrame},
  uEndingFailure in 'forms\uEndingFailure.pas' {FailureEndingFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;

end.
