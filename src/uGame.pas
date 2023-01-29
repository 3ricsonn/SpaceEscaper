unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Math,
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
    DebugConsole: TRectangle;
    MapLabel: TLabel;
    InventoryLabel: TLabel;
    MapPieceRectangle1: TRectangle;
    MapPieceRectangle2: TRectangle;
    procedure FormCreate(Sender: TObject);
    function createrooms: TRoom;
    procedure GameLoopTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    function generateRandomPosition(objectWidth: single; objectHeight: single;
      refRoom: TRoom): TPosition;
    procedure Reset;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  ROOM_PLAYER_PADDING = 10;
  DOOR_SIZE = 125;
  DOOR_FRAME_SIZE = 80;

var
  GameForm: TGameForm;
  eventHandler: TEventHandler;
  player: TPlayer;

implementation

{$R *.fmx}
{$R *.Surface.fmx MSWINDOWS}
{$R *.Windows.fmx MSWINDOWS}

{ TGameForm initialisation }
procedure TGameForm.FormCreate(Sender: TObject);
begin
  randomize;

  // prepare GUI
  self.ImageContainer.Visible := False;
  self.MapPieceRectangle1.Visible := False;
  self.MapPieceRectangle2.Visible := False;
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
  piece1, piece2: integer;
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

  // distribute mappieces
  piece1 := random(15);
  piece2 := random(15);
  while piece1 = piece2 do
    piece2 := random(15);

  // place first mappiece
  case piece1 of
    1:
      Abstellkammer1.setmappiece;
    2:
      hallway1.setmappiece;
    3:
      Abstellkammer2.setmappiece;
    4:
      Bibliothek.setmappiece;
    5:
      hallway6.setmappiece;
    6:
      hallway2.setmappiece;
    7:
      hallway3.setmappiece;
    8:
      hallway4.setmappiece;
    9:
      hallway7.setmappiece;
    10:
      Krankenstation.setmappiece;
    11:
      hallway5.setmappiece;
    12:
      Laderampe.setmappiece;
    13:
      Abstellkammer3.setmappiece;
    14:
      Schlafsaal2.setmappiece;
    15:
      Schlafsaal1.setmappiece;
  end;

  // place second mappiece
  case piece2 of
    1:
      Abstellkammer1.setmappiece;
    2:
      hallway1.setmappiece;
    3:
      Abstellkammer2.setmappiece;
    4:
      Bibliothek.setmappiece;
    5:
      hallway6.setmappiece;
    6:
      hallway2.setmappiece;
    7:
      hallway3.setmappiece;
    8:
      hallway4.setmappiece;
    9:
      hallway7.setmappiece;
    10:
      Krankenstation.setmappiece;
    11:
      hallway5.setmappiece;
    12:
      Laderampe.setmappiece;
    13:
      Abstellkammer3.setmappiece;
    14:
      Schlafsaal2.setmappiece;
    15:
      Schlafsaal1.setmappiece;
  end;

  // TODO: Draw mappieces in rooms
  { *self.MapPieceRectangle1.Position := self.generateRandomPosition
    (self.MapPieceRectangle1.width, self.MapPieceRectangle1.height, hallway2);
    self.MapPieceRectangle1.Parent := hallway2;
    self.MapPieceRectangle1.ClipParent := True;

    self.MapPieceRectangle2.Position := self.generateRandomPosition
    (self.MapPieceRectangle2.width, self.MapPieceRectangle2.height);* }
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
begin
  { update players position }

  // ~~ Debbing information ~~
  if (player.currentRoom.getmappiece) then
  begin
    self.MapLabel.Text := '1';
  end
  else
  begin
    self.MapLabel.Text := '0';
  end;

  self.InventoryLabel.Text := IntToStr(player.countMappieces);

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
        ((player.currentRoom.getneighbour(west) <> nil) and
        (player.Position.y + player.size.height <=
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height - ROOM_PLAYER_PADDING) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.size.height -
        DOOR_FRAME_SIZE))) then
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
        ((player.currentRoom.getneighbour(west) <> nil) and
        (player.Position.y + player.size.height <=
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height - ROOM_PLAYER_PADDING) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.size.height -
        DOOR_FRAME_SIZE))) then
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
    if (player.Position.x < self.RoomGridLayout.Position.x +
      player.currentRoom.Position.x) then
    // switch current Room to entered room (western neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(west);
    end
  end;

  // == move right ==
  if (eventHandler.RightButton) then
  begin
    // determine if player of map have to be moved
    if (player.Position.x + player.size.Width + player.velocity <
      ScreenLayout.Position.x + ScreenLayout.Width) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x + player.size.Width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.size.Width - ROOM_PLAYER_PADDING) or
        ((player.currentRoom.getneighbour(east) <> nil) and
        (player.Position.y + player.size.height <=
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height - ROOM_PLAYER_PADDING) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.size.height -
        DOOR_FRAME_SIZE))) then
      begin
        // palyer moves
        player.setToX(player.Position.x + player.velocity);
      end

      else
      // player hits wall
      begin
        player.setToX(player.currentRoom.Position.x +
          player.currentRoom.size.Width + self.RoomGridLayout.Position.x -
          player.size.Width - ROOM_PLAYER_PADDING)
      end;
    end

    else
    // map is to be moeved
    begin
      player.setToX(ScreenLayout.Position.x + ScreenLayout.Width -
        player.size.Width);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x + player.size.Width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.size.Width - ROOM_PLAYER_PADDING) or
        ((player.currentRoom.getneighbour(east) <> nil) and
        (player.Position.y + player.size.height <=
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.size.height - ROOM_PLAYER_PADDING) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.size.height -
        DOOR_FRAME_SIZE))) then
      begin
        // map moves
        self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x -
          player.velocity;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.x := player.Position.x + player.size.Width
          - player.currentRoom.Position.x - player.currentRoom.size.Width +
          ROOM_PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.x > self.RoomGridLayout.Position.x +
      player.currentRoom.Position.x + player.currentRoom.size.Width) then
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
        ((player.currentRoom.getneighbour(north) <> nil) and
        (player.Position.x + player.size.Width <= player.currentRoom.Position.x
        + player.currentRoom.size.Width + self.RoomGridLayout.Position.x -
        ROOM_PLAYER_PADDING) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.size.Width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.size.Width -
        DOOR_FRAME_SIZE))) then
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
        ((player.currentRoom.getneighbour(north) <> nil) and
        (player.Position.x + player.size.Width <= player.currentRoom.Position.x
        + player.currentRoom.size.Width + self.RoomGridLayout.Position.x -
        ROOM_PLAYER_PADDING) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.size.Width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.size.Width -
        DOOR_FRAME_SIZE))) then
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
    if (player.Position.y < self.RoomGridLayout.Position.y +
      player.currentRoom.Position.y) then
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
        ((player.currentRoom.getneighbour(south) <> nil) and
        (player.Position.x + player.size.Width <= player.currentRoom.Position.x
        + player.currentRoom.size.Width + self.RoomGridLayout.Position.x -
        ROOM_PLAYER_PADDING) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.size.Width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.size.Width -
        DOOR_FRAME_SIZE))) then
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
        ((player.currentRoom.getneighbour(south) <> nil) and
        (player.Position.x + player.size.Width <= player.currentRoom.Position.x
        + player.currentRoom.size.Width + self.RoomGridLayout.Position.x -
        ROOM_PLAYER_PADDING) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.size.Width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.size.Width -
        DOOR_FRAME_SIZE))) then
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
      player.currentRoom.Position.y + player.currentRoom.size.height) then
    // switch current Room to entered room (southern neighbour)
    begin
      player.currentRoom := player.currentRoom.getneighbour(south);
    end
  end;

  // == user event ==
  if (eventHandler.EventButton) then
  begin
    // if map piece in room
    if (player.currentRoom.getmappiece()) then
    // pickup map piece: add player collection and delete from room
    begin
      player.currentRoom.deletemappiece;
      player.addMappiece;
    end;
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

{ Userinput: Key released }
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

{ Generate random position within the current room }
function TGameForm.generateRandomPosition(objectWidth: single;
  objectHeight: single; refRoom: TRoom): TPosition;
var
  pos: TPosition;
  point: TPointF;
begin
  { *point := TPointF.create(FRamdomRange(self.RoomGridLayout.Position.x +
    player.currentRoom.Position.x + ROOM_PLAYER_PADDING,
    self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
    player.currentRoom.size.width - objectWidth - ROOM_PLAYER_PADDING),
    FRamdomRange(self.RoomGridLayout.Position.y + player.currentRoom.Position.y
    + ROOM_PLAYER_PADDING, self.RoomGridLayout.Position.y +
    player.currentRoom.Position.y + player.currentRoom.size.height -
    objectHeight - ROOM_PLAYER_PADDING)); * }
  point := TPointF.create(FRamdomRange(ROOM_PLAYER_PADDING,
    refRoom.size.Width - objectWidth - ROOM_PLAYER_PADDING),
    FRamdomRange(ROOM_PLAYER_PADDING, refRoom.size.height - objectHeight -
    ROOM_PLAYER_PADDING));
  pos := TPosition.create(point);

  result := pos;
end;

{ Resets Game State }
procedure TGameForm.Reset;
begin
  // center player
  player.setToPosition(self.HUDLayout.Width / 2 - player.size.Width / 2,
    self.HUDLayout.height / 2 - player.size.height / 2);

  // center start room
  self.RoomGridLayout.Position.x := self.ScreenLayout.Position.x +
    self.ScreenLayout.Width / 2 - self.RoomRectangle10.Width / 2 -
    self.RoomRectangle10.Width;
  self.RoomGridLayout.Position.y := self.ScreenLayout.Position.y +
    self.ScreenLayout.height / 2 - self.RoomRectangle10.height / 2 - 2 *
    self.RoomRectangle10.height;
end;

end.
