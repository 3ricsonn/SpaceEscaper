unit uRoom;

interface

type
  direction = (north, east, south, west);

  TRoom = class
  private
    neighbourN: TRoom;
    neighbourS: TRoom;
    neighbourE: TRoom;
    neighbourW: TRoom;
    mappiece: boolean;
  public
    function getmappiece: boolean;
    function getneighbour(d: direction): TRoom;
    procedure setneighbour(nN, nS, nE, nW: TRoom);
    procedure deletemappiece;
  end;

implementation

function TRoom.getmappiece: boolean;
begin
  result := mappiece;
end;

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

procedure TRoom.setneighbour(nN, nS, nE, nW: TRoom);
begin
  neighbourN := nN;
  neighbourS := nS;
  neighbourE := nE;
  neighbourW := nW;
end;

procedure TRoom.deletemappiece;
begin
  if mappiece = true then
    mappiece := false;
end;

end.
