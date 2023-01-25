program SpaceEscaper;

uses
  System.StartUpCopy,
  FMX.Forms,
  uGame in 'src\uGame.pas' {GameForm},
  uPlayer in 'src\uPlayer.pas' {$R *.res},
  uBase in 'src\uBase.pas',
  uRoom in 'src\uRoom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;

end.
