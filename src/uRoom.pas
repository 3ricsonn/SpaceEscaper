unit uRoom;

interface

uses
  System.Types,
  FMX.Types, FMX.Objects,

  uBase;

type
  direction = (north, east, south, west);

  TRoom = class(TBaseGameClass)
  private
    neighbourN: TRoom;
    neighbourS: TRoom;
    neighbourE: TRoom;
    neighbourW: TRoom;
    mappiece: TRectangle;
  public
    function getmappiece: TRectangle;
    procedure setmappiece(screenObject: TRectangle; grid_pos: TPosition);
    procedure deletemappiece;
    function getneighbour(d: direction): TRoom;
    procedure setneighbour(nN, nS, nE, nW: TRoom);
  end;

const
  MAP_PIECE_PADDING = 50;

implementation

{ get map piece from room }
function TRoom.getmappiece: TRectangle;
begin
  result := mappiece;
end;

{ place mappiece in room }
procedure TRoom.setmappiece(screenObject: TRectangle; grid_pos: TPosition);
var
  point: TPointF;
begin
  self.mappiece := screenObject;

  point := TPointF.create(FRamdomRange(grid_pos.x + self.Position.x +
    MAP_PIECE_PADDING, grid_pos.x + self.Position.x + self.Size.width -
    self.mappiece.width - MAP_PIECE_PADDING),
    FRamdomRange(grid_pos.y + self.Position.y + MAP_PIECE_PADDING,
    +grid_pos.y + self.Position.y + self.Size.height - self.mappiece.height -
    MAP_PIECE_PADDING));
  self.mappiece.Position := TPosition.create(point);
end;

{ Get neighbour based on given direction }
function TRoom.getneighbour(d: direction): TRoom;
begin
  result := nil;
  case d of
    north:
      result := neighbourN;
    south:
      result := neighbourS;
    east:
      result := neighbourE;
    west:
      result := neighbourW;
  end;
end;

{ Set neighbores in all directions }
procedure TRoom.setneighbour(nN, nS, nE, nW: TRoom);
begin
  neighbourN := nN;
  neighbourS := nS;
  neighbourE := nE;
  neighbourW := nW;
end;

{ Remove mappiece from room }
procedure TRoom.deletemappiece;
begin
  if mappiece <> nil then
  begin
    self.mappiece.Visible := False;
    mappiece := nil;
  end;
end;

end.
