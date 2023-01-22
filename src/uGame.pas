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
    RoomGridLayout: TGridPanelLayout;
    RoomRectangle1: TRectangle;
    RoomRectangle2: TRectangle;
    RoomRectangle3: TRectangle;
    RoomRectangle4: TRectangle;
    RoomRectangle5: TRectangle;
    RoomRectangle6: TRectangle;
    RoomRectangle7: TRectangle;
    RoomRectangle8: TRectangle;
    RoomRectangle9: TRectangle;
    RoomRectangle10: TRectangle;
    RoomRectangle11: TRectangle;
    RoomRectangle12: TRectangle;
    RoomRectangle13: TRectangle;
    RoomRectangle14: TRectangle;
    RoomRectangle15: TRectangle;
    RoomRectangle16: TRectangle;
    ImageRoomDoorDown: TRectangle;
    ImageContainer: TLayout;
    ImageRoomDoorLeft: TRectangle;
    ImageRoomDoorRight: TRectangle;
    ImageRoomDoorUp: TRectangle;
    ImageRoomDoorLeftDown: TRectangle;
    ImageRoomDoorUpDown: TRectangle;
    ImageRoomDoorLeftUpDown: TRectangle;
    ImageRoomDoorLeftRight: TRectangle;
    ImageRoomDoorLeftUp: TRectangle;
    ImageRoomDoorRightDown: TRectangle;
    ImageRoomDoorRightUp: TRectangle;
    ImageRoomDoorLeftRightUpDown: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure GameLoopTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure setImagetoRectangle(image: TRectangle; rectangle: TRectangle);
    procedure Reset;
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
  self.ImageContainer.Visible := False;

  player := TPlayer.create(self, self.PlayerCharacter);
  self.Reset;

  // set room distribution
  self.setImagetoRectangle(self.ImageRoomDoorRight, self.RoomRectangle1);
  //self.setImagetoRectangle(self.ImageRoomDoorLeftRightDown, self.RoomRectangle2);
  self.setImagetoRectangle(self.ImageRoomDoorLeft, self.RoomRectangle3);
  self.setImagetoRectangle(self.ImageRoomDoorDown, self.RoomRectangle4);
  self.setImagetoRectangle(self.ImageRoomDoorRightDown, self.RoomRectangle5);
  self.setImagetoRectangle(self.ImageRoomDoorLeftRightUpDown, self.RoomRectangle6);
  //self.setImagetoRectangle(self.ImageRoomDoorLeftRightDown, self.RoomRectangle7);
  self.setImagetoRectangle(self.ImageRoomDoorLeftUpDown, self.RoomRectangle8);
  self.setImagetoRectangle(self.ImageRoomDoorUpDown, self.RoomRectangle9);
  //self.setImagetoRectangle(self.ImageRoomDoorRightUpDown, self.RoomRectangle10);
  self.setImagetoRectangle(self.ImageRoomDoorLeftUp, self.RoomRectangle11);
  self.setImagetoRectangle(self.ImageRoomDoorUpDown, self.RoomRectangle12);
  self.setImagetoRectangle(self.ImageRoomDoorUp, self.RoomRectangle13);
  self.setImagetoRectangle(self.ImageRoomDoorUp, self.RoomRectangle14);
  self.setImagetoRectangle(self.ImageRoomDoorRight, self.RoomRectangle15);
  self.setImagetoRectangle(self.ImageRoomDoorLeftUp, self.RoomRectangle16);

  self.KeyLabel.Text := '';
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
begin
  { update players position }
  // TODO: Außenwand durch Raum Wand erstetzen

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
      if (player.Position.x - player.velocity > self.RoomGridLayout.Position.x)
      then
      begin
        self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x +
          player.velocity;
      end;
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
      if (player.Position.x + player.size.width + player.velocity <
        self.RoomGridLayout.Position.x + self.RoomGridLayout.width) then
      begin
        self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x -
          player.velocity;
      end;
    end;
  end;

  // move up
  if (eventHandler.UpButton) then
  begin
    if (player.Position.y - player.velocity > ScreenLayout.Position.y) then
    begin
      player.setToY(player.Position.y - player.velocity);
    end
    else
    begin
      player.setToY(ScreenLayout.Position.y);
      if (player.Position.y - player.velocity > self.RoomGridLayout.Position.y)
      then
      begin
        self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y +
          player.velocity;
      end;
    end;
  end;

  // move down
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
      if (player.Position.y + player.size.Height + player.velocity <
        self.RoomGridLayout.Position.y + self.RoomGridLayout.Height) then
      begin
        self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y -
          player.velocity;
      end;
    end;
  end;

  if (eventHandler.EventButton) then
  begin
    self.Reset;
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

procedure TGameForm.setImagetoRectangle(image: TRectangle;
  rectangle: TRectangle);
begin
  rectangle.Stroke.Kind := TBrushKind.Bitmap;
  rectangle.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  rectangle.Fill.Kind := TBrushKind.Bitmap;
  rectangle.Fill.Bitmap.Bitmap.Assign(image.Fill.Bitmap.Bitmap);
end;

procedure TGameForm.Reset;
begin
  player.Reset;

  self.RoomGridLayout.Position.x := self.ScreenLayout.Position.x +
    self.ScreenLayout.width / 2 - self.RoomRectangle10.width / 2 -
    self.RoomRectangle10.width;
  self.RoomGridLayout.Position.y := self.ScreenLayout.Position.y +
    self.ScreenLayout.Height / 2 - self.RoomRectangle10.Height / 2 - 2 *
    self.RoomRectangle10.Height;
end;

end.
