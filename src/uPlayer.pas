unit uPlayer;

interface

uses
  System.Classes,
  uRoom,
  FMX.Types, FMX.Objects,

  uBase;

type
  TPlayer = class(TBaseGameClass)
  const
    velocity = 10;
  private
    collectedMapPieces: integer;
  public
    currentRoom: TRoom;
    constructor create(AOwner: TComponent; screenObject: TRectangle); overload;
    procedure reset;
    procedure addMappiece;

  end;

implementation

constructor TPlayer.create(AOwner: TComponent; screenObject: TRectangle);
begin
  inherited create(AOwner, screenObject);

  self.collectedMapPieces := 0;
end;

procedure TPlayer.reset;
begin
  self.setToPosition(375 - self.size.width / 2, 250 - self.size.height / 2);
end;

procedure TPlayer.addMappiece;
begin
  self.collectedMapPieces := self.collectedMapPieces + 1;
end;

end.
