unit uPlayer;

interface

uses
  System.Classes,
  FMX.Types, FMX.Objects,

  uBase, uRoom;

type
  TPlayer = class(TBaseGameClass)
  const
    velocity = 10;
  private
    _collectedMapPieces: integer;
  public
    currentRoom: TRoom;
    constructor create(AOwner: TComponent; screenObject: TRectangle); overload;
    procedure addMappiece;
    function countMappieces: integer;
    procedure resetMappieces;
  end;

implementation

{ TPlayer initialization }
constructor TPlayer.create(AOwner: TComponent; screenObject: TRectangle);
begin
  inherited create(AOwner, screenObject);

  self._collectedMapPieces := 0;
end;

{ add mappiece to collected mappieces }
procedure TPlayer.addMappiece;
begin
  self._collectedMapPieces := self._collectedMapPieces + 1;
end;

function TPlayer.countMappieces: integer;
begin
  result := self._collectedMapPieces;
end;

procedure TPlayer.resetMappieces;
begin
  self._collectedMapPieces := 0;
end;

end.
