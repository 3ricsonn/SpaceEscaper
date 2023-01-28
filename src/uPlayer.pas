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
    collectedMapPieces: integer;
  public
    currentRoom: TRoom;
    constructor create(AOwner: TComponent; screenObject: TRectangle); overload;
    procedure addMappiece;
  end;

implementation

{ TPlayer initialization }
constructor TPlayer.create(AOwner: TComponent; screenObject: TRectangle);
begin
  inherited create(AOwner, screenObject);

  self.collectedMapPieces := 0;
end;

{ add mappiece to collected mappieces }
procedure TPlayer.addMappiece;
begin
  self.collectedMapPieces := self.collectedMapPieces + 1;
end;

end.
