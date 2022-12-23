unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,

  UBase, uPlayer;

type
  TGameForm = class(TForm)
    HUDLayout: TLayout;
    PlayerCharacter: TRectangle;
    ScreenLayout: TLayout;
    GameLoop: TTimer;
    KeyLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GameLoopTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameForm: TGameForm;
  eventHandler: TEventHandler;
  player: TPlayer;

implementation

{$R *.fmx}

procedure TGameForm.FormCreate(Sender: TObject);
begin
  player := TPlayer.create(self, self.PlayerCharacter);
  player.reset;

  KeyLabel.Text := '';
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
begin
  { update players position }
  // move left
  if (eventHandler.LeftButton) then
  begin
    if (player.Position.x - player.velocity > ScreenLayout.Position.x) then
    begin
      player.setToX(player.Position.x - player.velocity);
    end
    else
    begin
      player.setToX(ScreenLayout.Position.x);
    end;
  end;

  // move right
  if (eventHandler.RightButton) then
  begin
    if (player.Position.x + player.size.width + player.velocity <
      ScreenLayout.Position.x + ScreenLayout.width) then
    begin
      player.setToX(player.Position.x + player.velocity);
    end
    else
    begin
      player.setToX(ScreenLayout.Position.x + ScreenLayout.width -
        player.size.width);
    end;
  end;

  // move down
  if (eventHandler.UpButton) then
  begin
    if (player.Position.y - player.velocity > ScreenLayout.Position.y) then
    begin
      player.setToY(player.Position.y - player.velocity);
    end
    else
    begin
      player.setToY(ScreenLayout.Position.y);
    end;
  end;

  // move up
  if (eventHandler.DownButton) then
  begin
    if (player.Position.y + player.velocity + player.size.Height <
      ScreenLayout.Position.y + ScreenLayout.Height) then
    begin
      player.setToY(player.Position.y + player.velocity);
    end
    else
    begin
      player.setToY(ScreenLayout.Position.y + ScreenLayout.Height -
        player.size.Height);
    end;
  end;

  if (eventHandler.EventButton) then
  begin
    player.reset;
  end;
end;

{ Input procedures }
procedure TGameForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case KeyChar of
    'W', 'w':
      begin
        eventHandler.UpButton := True;
        KeyLabel.Text := 'W';
      end;
    'A', 'a':
      begin
        eventHandler.LeftButton := True;
        KeyLabel.Text := 'A';
      end;
    'S', 's':
      begin
        eventHandler.DownButton := True;
        KeyLabel.Text := 'S';
      end;
    'D', 'd':
      begin
        eventHandler.RightButton := True;
        KeyLabel.Text := 'D';
      end;
    'E', 'e':
      begin
        eventHandler.EventButton := True;
        KeyLabel.Text := 'E';
      end;
  end;
end;

procedure TGameForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  case KeyChar of
    'W', 'w':
      begin
        eventHandler.UpButton := False;
      end;
    'A', 'a':
      begin
        eventHandler.LeftButton := False;
      end;
    'S', 's':
      begin
        eventHandler.DownButton := False;
      end;
    'D', 'd':
      begin
        eventHandler.RightButton := False;
      end;
    'E', 'e':
      begin
        eventHandler.EventButton := False;
      end;
  end;
  KeyLabel.Text := '';
end;

end.
