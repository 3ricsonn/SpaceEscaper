unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts,

  uPlayer, FMX.Controls.Presentation, FMX.StdCtrls;

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
  self.PlayerCharacter.TagObject := player;

  KeyLabel.Text := '';
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
begin
  eventHandler.screensize.width := screenLayout.Width;
  eventHandler.screensize.height := screenLayout.Height;

  eventHandler.screenpos.x := screenLayout.Position.x;
  eventHandler.screenpos.y := screenLayout.Position.y;

  player.update(eventHandler);
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
  end;
  KeyLabel.Text := '';
end;

end.
