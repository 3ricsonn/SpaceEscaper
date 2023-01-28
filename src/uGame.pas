unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,

  UBase, uPlayer, uRoom;

type
  TGameForm = class(TForm)
    HUDLayout: TLayout;
    PlayerCharacter: TRectangle;
    ScreenLayout: TLayout;
    GameLoop: TTimer;
    KeyLabel: TLabel; // Debbing purpose
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
    function createrooms: TRoom;
    procedure GameLoopTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Reset;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ROOM_PLAYER_PADDING = 10;

var
  GameForm: TGameForm;
  eventHandler: TEventHandler;
  player: TPlayer;

implementation

{$R *.fmx}

{ TGameForm initialisation }
procedure TGameForm.FormCreate(Sender: TObject);
begin
  // prepare GUI
  self.ImageContainer.Visible := False;
  self.KeyLabel.Text := '';

  // create and initialise player
  player := TPlayer.create(self, self.PlayerCharacter);
  player.currentRoom := self.createrooms();

  // move to start position
  self.Reset;
end;

{ Create Roomlayout of Labyrinth }
function TGameForm.createrooms: TRoom;
var
  Abstellkammer1, hallway1, Abstellkammer2, Bibliothek, hallway6, hallway2,
    hallway3, hallway4, hallway7, Schaltzentrale, Krankenstation, hallway5,
    Laderampe, Abstellkammer3, Schlafsaal2, Schlafsaal1: TRoom;
begin
  // create rooms
  // first row
  Abstellkammer1 := TRoom.create(self, self.RoomRectangle1);
  Abstellkammer1.bindBitmapToObject(self.ImageRoomDoorRight);

  hallway1 := TRoom.create(self, self.RoomRectangle2);
  // hallway1.bindBitmapToObject(self.ImageRoomDoorLeftRightDown)

  Abstellkammer2 := TRoom.create(self, self.RoomRectangle3);
  Abstellkammer2.bindBitmapToObject(self.ImageRoomDoorLeft);

  Bibliothek := TRoom.create(self, self.RoomRectangle4);
  Bibliothek.bindBitmapToObject(self.ImageRoomDoorDown);

  // second row
  hallway6 := TRoom.create(self, self.RoomRectangle5);
  hallway6.bindBitmapToObject(self.ImageRoomDoorRightDown);

  hallway2 := TRoom.create(self, self.RoomRectangle6);
  hallway2.bindBitmapToObject(self.ImageRoomDoorLeftRightUpDown);

  hallway3 := TRoom.create(self, self.RoomRectangle7);
  // hallway3.bindBitmapToObject(self.ImageRoomDoorLeftRightDown);

  hallway4 := TRoom.create(self, self.RoomRectangle8);
  hallway4.bindBitmapToObject(self.ImageRoomDoorLeftUpDown);

  // third row
  hallway7 := TRoom.create(self, self.RoomRectangle9);
  hallway7.bindBitmapToObject(self.ImageRoomDoorUpDown);

  Schaltzentrale := TRoom.create(self, self.RoomRectangle10);
  // Schaltzentrale.bindBitmapToObject(self.ImageRoomDoorRightUpDown);

  Krankenstation := TRoom.create(self, self.RoomRectangle11);
  Krankenstation.bindBitmapToObject(self.ImageRoomDoorLeftUp);

  hallway5 := TRoom.create(self, self.RoomRectangle12);
  hallway5.bindBitmapToObject(self.ImageRoomDoorUpDown);

  // fourth row
  Laderampe := TRoom.create(self, self.RoomRectangle13);
  Laderampe.bindBitmapToObject(self.ImageRoomDoorUp);

  Abstellkammer3 := TRoom.create(self, self.RoomRectangle14);
  Abstellkammer3.bindBitmapToObject(self.ImageRoomDoorUp);

  Schlafsaal2 := TRoom.create(self, self.RoomRectangle15);
  Schlafsaal2.bindBitmapToObject(self.ImageRoomDoorRight);

  Schlafsaal1 := TRoom.create(self, self.RoomRectangle16);
  Schlafsaal1.bindBitmapToObject(self.ImageRoomDoorLeftUp);

  // set neighbours
  Abstellkammer1.setneighbour(NIL, NIL, hallway1, NIl);
  hallway1.setneighbour(NIL, hallway2, Abstellkammer2, Abstellkammer1);
  Abstellkammer2.setneighbour(NIL, NIL, NIL, hallway1);
  Bibliothek.setneighbour(NIL, hallway4, NIL, NIL);

  hallway6.setneighbour(NIL, hallway7, hallway2, NIL);
  hallway2.setneighbour(hallway1, Schaltzentrale, hallway3, hallway6);
  hallway3.setneighbour(NIL, Krankenstation, hallway4, hallway2);
  hallway4.setneighbour(Bibliothek, hallway5, NIL, hallway3);

  hallway7.setneighbour(hallway6, Laderampe, NIL, NIL);
  Schaltzentrale.setneighbour(hallway2, Abstellkammer3, Krankenstation, NIL);
  Krankenstation.setneighbour(hallway3, NIL, NIL, Schaltzentrale);
  hallway5.setneighbour(hallway4, Schlafsaal1, NIL, NIL);

  Laderampe.setneighbour(hallway7, NIL, NIL, NIL);
  Abstellkammer3.setneighbour(Schaltzentrale, NIL, NIL, NIL);
  Schlafsaal2.setneighbour(NIL, NIL, Schlafsaal1, NIL);
  Schlafsaal1.setneighbour(hallway5, NIL, NIL, Schlafsaal2);

  result := Schaltzentrale;
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
begin
  { update players position }

  // TODO: fix Wall-Glitch (Part of player can go through walls -.-)

  // == move left ==
  if (eventHandler.LeftButton) then
  begin
    // determine if player of map have to be moved
    if (player.Position.x - player.velocity > self.ScreenLayout.Position.x) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x - player.velocity > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(west) <> nil) then
      // move player
      begin
        player.setToX(player.Position.x - player.velocity);
      end

      else
      // player hits a wall
      begin
        player.setToX(player.currentRoom.Position.x +
          self.RoomGridLayout.Position.x + ROOM_PLAYER_PADDING);
      end;
    end

    else
    // map is to be moeved
    begin
      player.setToX(ScreenLayout.Position.x);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x - player.velocity > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(west) <> nil) then
      // move map
      begin
        self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x +
          player.velocity;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.x := player.Position.x -
          player.currentRoom.Position.x - ROOM_PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.x + player.size.width - player.velocity <
      self.RoomGridLayout.Position.x + player.currentRoom.Position.x) and
      (player.currentRoom.getneighbour(west) <> nil) then
    // switch current Room to entered room (western neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(west);
    end
  end;

  // == move right ==
  if (eventHandler.RightButton) then
  begin
    // determine if player of map have to be moved
    if (player.Position.x + player.size.width + player.velocity <
      ScreenLayout.Position.x + ScreenLayout.width) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x + player.size.width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.size.width - ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(east) <> nil) then
      begin
        // palyer moves
        player.setToX(player.Position.x + player.velocity);
      end

      else
      // player hits wall
      begin
        player.setToX(player.currentRoom.Position.x +
          player.currentRoom.size.width + self.RoomGridLayout.Position.x -
          player.size.width - ROOM_PLAYER_PADDING)
      end;
    end

    else
    // map is to be moeved
    begin
      player.setToX(ScreenLayout.Position.x + ScreenLayout.width -
        player.size.width);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x + player.size.width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.size.width - ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(east) <> nil) then
      begin
        // map moves
        self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x -
          player.velocity;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.x := player.Position.x + player.size.width
          - player.currentRoom.Position.x - player.currentRoom.size.width +
          ROOM_PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.x > self.RoomGridLayout.Position.x +
      player.currentRoom.Position.x + player.currentRoom.size.width) then
    // switch current Room to entered room (eastern neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(east);
    end
  end;

  // == move up ==
  if (eventHandler.UpButton) then
  begin
    // determine if player of map have to be moved
    if (player.Position.y - player.velocity > ScreenLayout.Position.y) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y - player.velocity > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(north) <> nil) then
      // move player
      begin
        player.setToY(player.Position.y - player.velocity);
      end

      else
      // player hits a wall
      begin
        player.setToY(player.currentRoom.Position.y +
          self.RoomGridLayout.Position.y + ROOM_PLAYER_PADDING);
      end;
    end

    else
    // map is to be moeved
    begin
      player.setToY(ScreenLayout.Position.y);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y - player.velocity > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(north) <> nil) then
      // move map
      begin
        self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y +
          player.velocity;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.y := player.Position.y -
          player.currentRoom.Position.y - ROOM_PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.y + player.size.height < self.RoomGridLayout.Position.y
      + player.currentRoom.Position.y) and
      (player.currentRoom.getneighbour(north) <> nil) then
    // switch current Room to entered room (northern neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(north);
    end
  end;

  // == move down ==
  if (eventHandler.DownButton) then
  begin
    // determine if player of map have to be moved
    if (player.Position.y + player.velocity + player.size.height <
      ScreenLayout.Position.y + ScreenLayout.height) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y + player.size.height + player.velocity <
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height - ROOM_PLAYER_PADDING) or
        (player.currentRoom.getneighbour(south) <> nil) then
      begin
        // move player
        player.setToY(player.Position.y + player.velocity);
      end

      else
      // player hits a wall
      begin
        player.setToY(player.currentRoom.Position.y +
          self.RoomGridLayout.Position.y + player.currentRoom.size.height -
          player.size.height - ROOM_PLAYER_PADDING);
      end;
    end

    else
    // map is to be moeved
    begin
      player.setToY(ScreenLayout.Position.y + ScreenLayout.height -
        player.size.height);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y + player.size.height + player.velocity <
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height) or
        (player.currentRoom.getneighbour(south) <> nil) then
      begin
        // move map
        self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y -
          player.velocity;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.y := player.Position.y + player.size.height
          - player.currentRoom.Position.y - player.currentRoom.size.height +
          ROOM_PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.y > self.RoomGridLayout.Position.y +
      player.currentRoom.Position.y + player.currentRoom.size.height) and
      (player.currentRoom.getneighbour(south) <> nil) then
    // switch current Room to entered room (southern neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(south);
    end
  end;

  // == user event ==
  if (eventHandler.EventButton) then
  begin
    // resets the game back to start
    self.Reset;
  end;
end;

{ Userinput: Key pushed down }
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

{ USerinput: Key released }
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

{ Resets Game State }
procedure TGameForm.Reset;
begin
  // center player
  player.setToPosition(self.HUDLayout.width / 2 - player.size.width / 2,
    self.HUDLayout.height / 2 - player.size.height / 2);

  // center start room
  self.RoomGridLayout.Position.x := self.ScreenLayout.Position.x +
    self.ScreenLayout.width / 2 - self.RoomRectangle10.width / 2 -
    self.RoomRectangle10.width;
  self.RoomGridLayout.Position.y := self.ScreenLayout.Position.y +
    self.ScreenLayout.height / 2 - self.RoomRectangle10.height / 2 - 2 *
    self.RoomRectangle10.height;
end;

end.
