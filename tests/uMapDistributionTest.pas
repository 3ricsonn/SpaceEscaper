unit uMapDistributionTest;

interface

uses
  System.Types,
  FMX.Types, FMX.Objects,
  uRoom;

function testMapDistribution(startRoom: TRoom): Boolean;
procedure __mapInRoom(room: TRoom; index: integer);

var
  foundMapPieces: array [1 .. 2] of TRectangle;
  roomgrid: array [1 .. 16] of Boolean;

implementation

function testMapDistribution(startRoom: TRoom): Boolean;
begin
  if startRoom.getneighbour(north) <> nil then
  begin
    __mapInRoom(startRoom.getneighbour(north), 10 - 4);
  end;

  if startRoom.getneighbour(east) <> nil then
  begin
    __mapInRoom(startRoom.getneighbour(east), 10 + 1);
  end;

  if startRoom.getneighbour(south) <> nil then
  begin
    __mapInRoom(startRoom.getneighbour(south), 10 + 4);
  end;

  if startRoom.getneighbour(west) <> nil then
  begin
    __mapInRoom(startRoom.getneighbour(west), 10 - 1);
  end;

  if ((foundMapPieces[1] <> nil) and (foundMapPieces[2] <> nil)) then
  begin
    result := True;
  end
  else
  begin
    result := False;
  end;
end;

procedure __mapInRoom(room: TRoom; index: integer);
begin

  if (foundMapPieces[1] = nil) then
  begin
    foundMapPieces[1] := room.getmappiece;
  end
  else if (foundMapPieces[2] = nil) then
  begin
    foundMapPieces[2] := room.getmappiece;
  end;

  roomgrid[index] := True;

  if (room.getneighbour(north) <> nil) then
  begin
    if not(roomgrid[index - 4]) then
    begin
      __mapInRoom(room.getneighbour(north), index - 4);
    end
  end;

  if (room.getneighbour(east) <> nil) then
  begin
    if not(roomgrid[index + 1]) then
    begin
      __mapInRoom(room.getneighbour(east), index + 1);
    end
  end;

  if (room.getneighbour(south) <> nil) then
  begin
    if not(roomgrid[index + 4]) then
    begin
      __mapInRoom(room.getneighbour(south), index + 4);
    end
  end;

  if (room.getneighbour(west) <> nil) then
  begin
    if not(roomgrid[index - 1]) then
    begin
      __mapInRoom(room.getneighbour(west), index - 1);
    end
  end;
end;

end.
