unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,

  UBase, uPlayer, uRoom,
  uEndingSuccess, uEndingFailure, uHUD, uStartAnimation,
  uMapDistributionTest;

type
  TStages = (START_ANIMATION, GAME, ENDING_SUCCESS, ENDING_FAILURE);

  TGameForm = class(TForm)
    ItemsLayout: TLayout;
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
    ImageRoomDoorLeftRightDown: TRectangle;
    ImageContainer: TLayout;
    ImageRoomDoorLeft: TRectangle;
    ImageRoomDoorRight: TRectangle;
    ImageRoomDoorUp: TRectangle;
    ImageRoomDoorDown: TRectangle;
    ImageRoomDoorUpDown: TRectangle;
    ImageRoomDoorLeftUpDown: TRectangle;
    ImageRoomDoorLeftUp: TRectangle;
    ImageRoomDoorRightDown: TRectangle;
    ImageRoomDoorLeftRightUpDown: TRectangle;
    DebugConsole: TRectangle;
    MapLabel: TLabel;
    InventoryLabel: TLabel;
    MapPieceRectangle1: TRectangle;
    MapPieceRectangle2: TRectangle;
    PlayerLayout: TLayout;
    PlayerCharacter: TRectangle;
    FailureEndingFrame: TFailureEndingFrame;
    SuccessEndingFrame: TSuccessEndingFrame;
    EndingTimer: TTimer;
    ImageRoomStart: TRectangle;
    StartAnimationFrame: TStartAnimationFrame;
    HUDFrame: THUDFrame;
    procedure FormCreate(Sender: TObject);
    procedure ChangeStage(stageName: TStages);
    procedure PrepareAndStartGame;
    procedure HideHUD;
    function createrooms: TRoom;
    procedure GameLoopTimer(Sender: TObject);
    procedure updateStartAnimation;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure EndingTimerTick(Sender: TObject);
  private
    roomItems: array [0 .. 1] of TRectangle;
    timeCounter: integer;
    stage: TStages;
  public
    { Public declarations }
  end;

const
  PLAYER_PADDING = 10;
  MAP_PIECE_PADDING = 30;
  DOOR_SIZE = 125;
  DOOR_FRAME_SIZE = 85;
  INTERACTION_RADIUS = 100;
  ESCAPE_TIME = 60; // in seconds

  // Debugging flags
  DEBUGGING = False; // set to false to turn of debugging mode
  TEST_MAP_DIST = False; // set to false to turn of map distribution test

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

  // create item list distributed through the maze
  self.roomItems[0] := self.MapPieceRectangle1;
  self.roomItems[1] := self.MapPieceRectangle2;

  // prepare GUI
  self.ImageContainer.Visible := False;
  self.KeyLabel.Text := '';

  if not DEBUGGING then
  begin
    self.MapPieceRectangle1.Visible := False;
    self.MapPieceRectangle2.Visible := False;
    self.DebugConsole.Visible := False;
  end;

  // create and initialise player
  player := TPlayer.create(self, self.PlayerCharacter);

  self.ChangeStage(START_ANIMATION);

  if DEBUGGING and TEST_MAP_DIST then
  begin
    if (testMapDistribution(player.currentRoom)) then
    begin
      showMessage('Map Distribution Successful');
    end
    else
    begin
      showMessage('Map Distribution failed');
    end;
  end;
end;

procedure TGameForm.ChangeStage(stageName: TStages);
begin
  self.stage := stageName;
  case stageName of
    START_ANIMATION:
      begin
        self.HideHUD;
        self.StartAnimationFrame.Visible := True;
        self.StartAnimationFrame.resetFrame;
      end;
    GAME:
      self.PrepareAndStartGame;
    ENDING_SUCCESS:
      begin
        self.HideHUD;
        self.SuccessEndingFrame.Visible := True;
      end;
    ENDING_FAILURE:
      begin
        self.HideHUD;
        FailureEndingFrame.Visible := True;
      end;
  end;
end;

{ disable and hide game elements }
procedure TGameForm.HideHUD;
begin
  // disable timer
  self.GameLoop.Enabled := False;
  self.EndingTimer.Enabled := False;

  // hide HUD
  self.HUDFrame.Visible := False;

  // hide game elements
  self.PlayerLayout.Visible := False;
  self.ItemsLayout.Visible := False;
  self.RoomGridLayout.Visible := False;
end;

{ Resets Game State }
procedure TGameForm.PrepareAndStartGame;
begin
  self.GameLoop.Enabled := True;
  self.EndingTimer.Enabled := True;
  self.timeCounter := 0;
  self.HUDFrame.TimerLabel.Text := '60s';

  self.HUDFrame.Visible := True;
  self.FailureEndingFrame.Visible := False;
  self.SuccessEndingFrame.Visible := False;
  self.StartAnimationFrame.Visible := False;

  // re show game elements
  self.PlayerLayout.Visible := True;
  self.ItemsLayout.Visible := True;
  self.RoomGridLayout.Visible := True;

  // center player
  player.setToPosition(self.PlayerLayout.width / 2 - player.Size.width / 2,
    self.PlayerLayout.height / 2 - player.Size.height / 2);
  player.resetMappieces;

  // center start room
  self.RoomGridLayout.Position.x := self.ScreenLayout.Position.x +
    self.ScreenLayout.width / 2 - self.RoomRectangle10.width / 2 -
    self.RoomRectangle10.width;
  self.RoomGridLayout.Position.y := self.ScreenLayout.Position.y +
    self.ScreenLayout.height / 2 - self.RoomRectangle10.height / 2 - 2 *
    self.RoomRectangle10.height;

  // create rooms
  player.currentRoom := self.createrooms();
end;

{ Create Roomlayout of Labyrinth }
function TGameForm.createrooms: TRoom;
var
  Abstellkammer1, hallway1, Abstellkammer2, Bibliothek, hallway6, hallway2,
    hallway3, hallway4, hallway7, Schaltzentrale, Krankenstation, hallway5,
    Laderampe, Abstellkammer3, Schlafsaal2, Schlafsaal1: TRoom;
  last_piece, piece, i: integer;
begin
  // create rooms
  // first row
  Abstellkammer1 := TRoom.create(self, self.RoomRectangle1);
  Abstellkammer1.bindBitmapToObject(self.ImageRoomDoorRight);

  hallway1 := TRoom.create(self, self.RoomRectangle2);
  hallway1.bindBitmapToObject(self.ImageRoomDoorLeftRightDown);

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
  hallway3.bindBitmapToObject(self.ImageRoomDoorLeftRightDown);

  hallway4 := TRoom.create(self, self.RoomRectangle8);
  hallway4.bindBitmapToObject(self.ImageRoomDoorLeftUpDown);

  // third row
  hallway7 := TRoom.create(self, self.RoomRectangle9);
  hallway7.bindBitmapToObject(self.ImageRoomDoorUpDown);

  Schaltzentrale := TRoom.create(self, self.RoomRectangle10);
  Schaltzentrale.bindBitmapToObject(self.ImageRoomStart);

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
  last_piece := 0;
  for i := low(self.roomItems) to High(self.roomItems) do
  begin
    repeat
      piece := random(15)
    until (last_piece <> piece) and (piece <> 0);

    case piece of
      1:
        Abstellkammer1.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
      2:
        hallway1.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      3:
        Abstellkammer2.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
      4:
        Bibliothek.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      5:
        hallway6.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      6:
        hallway2.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      7:
        hallway3.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      8:
        hallway4.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      9:
        hallway7.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      10:
        Krankenstation.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
      11:
        hallway5.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      12:
        Laderampe.setmappiece(self.roomItems[i], self.RoomGridLayout.Position);
      13:
        Abstellkammer3.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
      14:
        Schlafsaal2.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
      15:
        Schlafsaal1.setmappiece(self.roomItems[i],
          self.RoomGridLayout.Position);
    end;

    last_piece := piece
  end;
end;

{ Game Loop }
procedure TGameForm.GameLoopTimer(Sender: TObject);
var
  i: integer;
begin
  { update players position }

  // ~~ Debbing information ~~
  if (player.currentRoom.getmappiece <> nil) then
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
    // determine if player or map have to be moved
    if (player.Position.x - player.velocity > self.ScreenLayout.Position.x) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x - player.velocity > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + PLAYER_PADDING) or
        ((player.currentRoom.getneighbour(west) <> nil) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.Size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.Size.height -
        DOOR_FRAME_SIZE))) then
      // move player
      begin
        // determine if player hits door frame
        if (not(player.Position.y + player.Size.height >
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height) or
          (player.Position.x - player.velocity > self.RoomGridLayout.Position.x
          + player.currentRoom.Position.x + DOOR_FRAME_SIZE)) then
        begin
          player.setToX(player.Position.x - player.velocity);
        end;
      end

      else
      // player hits a wall
      begin
        player.setToX(player.currentRoom.Position.x +
          self.RoomGridLayout.Position.x + PLAYER_PADDING);
      end;
    end

    else
    // map is to be moved
    begin
      player.setToX(ScreenLayout.Position.x);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x - player.velocity > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + PLAYER_PADDING) or
        ((player.currentRoom.getneighbour(west) <> nil) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.Size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.Size.height -
        DOOR_FRAME_SIZE))) then
      // move map
      begin
        // determine if player hits door frame
        if (not(player.Position.y + player.Size.height >
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height) or
          (player.Position.x - player.velocity > self.RoomGridLayout.Position.x
          + player.currentRoom.Position.x + DOOR_FRAME_SIZE)) then
        begin
          self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x +
            player.velocity;

          for i := low(self.roomItems) to High(self.roomItems) do
            self.roomItems[i].Position.x := self.roomItems[i].Position.x +
              player.velocity;
        end;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.x := player.Position.x -
          player.currentRoom.Position.x - PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.x < self.RoomGridLayout.Position.x +
      player.currentRoom.Position.x) then
    // switch current Room to entered room (western neighbour)
    begin

      // hide map piece in left room
      if (player.currentRoom.getmappiece <> nil) and not DEBUGGING then
      begin
        player.currentRoom.getmappiece().Visible := False;
      end;

      player.currentRoom := player.currentRoom.getneighbour(west);

      // show map piece in entered room
      if (player.currentRoom.getmappiece <> nil) then
      begin
        player.currentRoom.getmappiece().Visible := True;
      end;
    end
  end;

  // == move right ==
  if (eventHandler.RightButton) then
  begin
    // determine if player or map have to be moved
    if (player.Position.x + player.Size.width + player.velocity <
      ScreenLayout.Position.x + ScreenLayout.width) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.x + player.Size.width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.Size.width - PLAYER_PADDING) or
        (player.currentRoom.getneighbour(east) <> nil) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.Size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.Size.height -
        DOOR_FRAME_SIZE)) then
      // player moves
      begin
        // determine if player hits door frame
        if (not(player.Position.y + player.Size.height >
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height) or
          (player.Position.x + player.Size.width + player.velocity <
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width - DOOR_FRAME_SIZE)) then
        begin
          player.setToX(player.Position.x + player.velocity);
        end;
      end

      else
      // player hits wall
      begin
        player.setToX(player.currentRoom.Position.x +
          player.currentRoom.Size.width + self.RoomGridLayout.Position.x -
          player.Size.width - PLAYER_PADDING)
      end;
    end

    else
    // map is to be moved
    begin
      player.setToX(ScreenLayout.Position.x + ScreenLayout.width -
        player.Size.width);
      // determine if player reached room boundary or if room has adjacent neighbour
      if (player.Position.x + player.Size.width + player.velocity <
        self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
        player.currentRoom.Size.width - PLAYER_PADDING) or
        (player.currentRoom.getneighbour(east) <> nil) and
        ((player.Position.y > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + DOOR_FRAME_SIZE) and
        (player.Position.y + player.Size.height < self.RoomGridLayout.Position.y
        + player.currentRoom.Position.y + player.currentRoom.Size.height -
        DOOR_FRAME_SIZE)) then
      // map moves
      begin
        // determine if player hits door frame
        if (not(player.Position.y + player.Size.height >
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height) or
          (player.Position.x + player.Size.width + player.velocity <
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width - DOOR_FRAME_SIZE)) then
        begin
          self.RoomGridLayout.Position.x := self.RoomGridLayout.Position.x -
            player.velocity;

          for i := low(self.roomItems) to High(self.roomItems) do
            self.roomItems[i].Position.x := self.roomItems[i].Position.x -
              player.velocity;
        end;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.x := player.Position.x + player.Size.width
          - player.currentRoom.Position.x - player.currentRoom.Size.width +
          PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.x > self.RoomGridLayout.Position.x +
      player.currentRoom.Position.x + player.currentRoom.Size.width) then
    // switch current Room to entered room (eastern neighbour)
    begin
      // hide map piece in left room
      if (player.currentRoom.getmappiece <> nil) and not DEBUGGING then
      begin
        player.currentRoom.getmappiece().Visible := False;
      end;

      player.currentRoom := player.currentRoom.getneighbour(east);

      // show map piece in entered room
      if (player.currentRoom.getmappiece <> nil) then
      begin
        player.currentRoom.getmappiece().Visible := True;
      end;
    end
  end;

  // == move up ==
  if (eventHandler.UpButton) then
  begin
    // determine if player or map have to be moved
    if (player.Position.y - player.velocity > ScreenLayout.Position.y) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y - player.velocity > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + PLAYER_PADDING) or
        (player.currentRoom.getneighbour(north) <> nil) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.Size.width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.Size.width -
        DOOR_FRAME_SIZE)) then
      // move player
      begin
        // determine if player hits door frame
        if (not(player.Position.x + player.Size.width >
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width) or (player.Position.y - player.velocity
          > self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          DOOR_FRAME_SIZE)) then
        begin
          player.setToY(player.Position.y - player.velocity);
        end;
      end

      else
      // player hits a wall
      begin
        player.setToY(player.currentRoom.Position.y +
          self.RoomGridLayout.Position.y + PLAYER_PADDING);
      end;
    end

    else
    // map is to be moved
    begin
      player.setToY(ScreenLayout.Position.y);
      // determine if player reached room boundary or if room has adjacent neighbour
      if (player.Position.y - player.velocity > self.RoomGridLayout.Position.y +
        player.currentRoom.Position.y + PLAYER_PADDING) or
        (player.currentRoom.getneighbour(north) <> nil) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.Size.width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.Size.width -
        DOOR_FRAME_SIZE)) then
      // move map
      begin
        // determine if player hits door frame
        if (not(player.Position.x + player.Size.width >
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width) or (player.Position.y - player.velocity
          > self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          DOOR_FRAME_SIZE)) then
        begin
          self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y +
            player.velocity;

          for i := low(self.roomItems) to High(self.roomItems) do
            self.roomItems[i].Position.y := self.roomItems[i].Position.y +
              player.velocity;
        end;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.y := player.Position.y -
          player.currentRoom.Position.y - PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.y < self.RoomGridLayout.Position.y +
      player.currentRoom.Position.y) then
    // switch current Room to entered room (northern neighbour)
    begin
      // hide map piece in left room
      if (player.currentRoom.getmappiece <> nil) and not DEBUGGING then
      begin
        player.currentRoom.getmappiece().Visible := False;
      end;

      player.currentRoom := player.currentRoom.getneighbour(north);

      // show map piece in entered room
      if (player.currentRoom.getmappiece <> nil) then
      begin
        player.currentRoom.getmappiece().Visible := True;
      end;
    end
  end;

  // == move down ==
  if (eventHandler.DownButton) then
  begin
    // determine if player or map have to be moved
    if (player.Position.y + player.velocity + player.Size.height <
      ScreenLayout.Position.y + ScreenLayout.height) then
    // player has to be moved
    begin
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y + player.Size.height + player.velocity <
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.Size.height - PLAYER_PADDING) or
        (player.currentRoom.getneighbour(south) <> nil) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.Size.width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.Size.width -
        DOOR_FRAME_SIZE)) then
      // move player
      begin
        // determine of player hits door frame
        if (not(player.Position.x + player.Size.width >
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width) or
          (player.Position.y + player.Size.height + player.velocity <
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height - DOOR_FRAME_SIZE)) then
        begin
          player.setToY(player.Position.y + player.velocity);
        end;
      end

      else
      // player hits a wall
      begin
        player.setToY(player.currentRoom.Position.y +
          self.RoomGridLayout.Position.y + player.currentRoom.Size.height -
          player.Size.height - PLAYER_PADDING);
      end;
    end

    else
    // map is to be moved
    begin
      player.setToY(ScreenLayout.Position.y + ScreenLayout.height -
        player.Size.height);
      // determine if player reached room boundry or if room has adjacent neighbour
      if (player.Position.y + player.Size.height + player.velocity <
        self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
        player.currentRoom.Size.height - PLAYER_PADDING) or
        (player.currentRoom.getneighbour(south) <> nil) and
        ((player.Position.x > self.RoomGridLayout.Position.x +
        player.currentRoom.Position.x + DOOR_FRAME_SIZE) and
        (player.Position.x + player.Size.width < self.RoomGridLayout.Position.x
        + player.currentRoom.Position.x + player.currentRoom.Size.width -
        DOOR_FRAME_SIZE)) then
      // move map
      begin
        // determine if player hits door frame
        if (not(player.Position.x + player.Size.width >
          self.RoomGridLayout.Position.x + player.currentRoom.Position.x +
          player.currentRoom.Size.width) or
          (player.Position.y + player.Size.height + player.velocity <
          self.RoomGridLayout.Position.y + player.currentRoom.Position.y +
          player.currentRoom.Size.height - DOOR_FRAME_SIZE)) then
        begin
          self.RoomGridLayout.Position.y := self.RoomGridLayout.Position.y -
            player.velocity;

          for i := low(self.roomItems) to High(self.roomItems) do
            self.roomItems[i].Position.y := self.roomItems[i].Position.y -
              player.velocity;
        end;
      end

      else
      // player hits wall
      begin
        self.RoomGridLayout.Position.y := player.Position.y + player.Size.height
          - player.currentRoom.Position.y - player.currentRoom.Size.height +
          PLAYER_PADDING;
      end;
    end;

    // determine if player left room
    if (player.Position.y > self.RoomGridLayout.Position.y +
      player.currentRoom.Position.y + player.currentRoom.Size.height) then
    // switch current Room to entered room (southern neighbour)
    begin
      // hide map piece in left room
      if (player.currentRoom.getmappiece <> nil) and not DEBUGGING then
      begin
        player.currentRoom.getmappiece().Visible := False;
      end;

      player.currentRoom := player.currentRoom.getneighbour(south);

      // show map piece in entered room
      if (player.currentRoom.getmappiece <> nil) then
      begin
        player.currentRoom.getmappiece().Visible := True;
      end;

    end
  end;

  // == user event ==
  if (eventHandler.EventButton) then
  begin
    // if map piece in room and the player stands close to the map piece
    if (player.currentRoom.getmappiece() <> nil) and
      (INTERACTION_RADIUS >= sqrt(sqr(player.currentRoom.getmappiece()
      .Position.y + player.currentRoom.getmappiece().height / 2 -
      (player.Position.y + player.Size.height / 2)) +
      sqr(player.currentRoom.getmappiece().Position.x +
      player.currentRoom.getmappiece().width / 2 - (player.Position.x +
      player.Size.width / 2)))) then
    // pickup map piece: add player collection and delete from room
    begin
      player.currentRoom.deletemappiece;
      player.addMappiece;
      self.HUDFrame.CollectionLabel.Text :=
        IntToStr(player.countMappieces) + '/2';

      if player.countMappieces = 2 then
      begin
        self.ChangeStage(ENDING_SUCCESS);
      end;
    end;
  end;
end;

procedure TGameForm.updateStartAnimation;
var
  finished: boolean;
begin
  finished := self.StartAnimationFrame.changeFrame;

  if finished then
  begin
    self.ChangeStage(GAME);
  end
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
  if (KeyChar = #32) then
  begin;
    if (self.stage = START_ANIMATION) then
    begin
      self.updateStartAnimation;
    end
    else if (self.stage = ENDING_SUCCESS) or (self.stage = ENDING_FAILURE) then
    begin
      self.ChangeStage(GAME);
    end;
  end;
end;

{ Userinput: Key released }
procedure TGameForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  finished: boolean;
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

procedure TGameForm.EndingTimerTick(Sender: TObject);

begin
  self.timeCounter := self.timeCounter + 1;
  self.HUDFrame.TimerLabel.Text :=
    IntToStr(ESCAPE_TIME - self.timeCounter) + 's';

  if self.timeCounter = ESCAPE_TIME then
  begin
    self.ChangeStage(ENDING_FAILURE);
  end;
end;

end.
