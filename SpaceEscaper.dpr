program SpaceEscaper;

uses
  System.StartUpCopy,
  FMX.Forms,
  uGame in 'uGame.pas' {GameForm},
  uPlayer in 'uPlayer.pas' {$R *.res};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;

end.
