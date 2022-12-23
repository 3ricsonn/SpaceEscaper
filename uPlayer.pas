unit uPlayer;

interface

uses
  System.Classes,
  FMX.Types, FMX.Objects,

  uBase;

type
  TPlayer = class(TBaseGameClass)
  const
    velocity = 10;
  private
  public
    collectiedCardPieces: integer;
    procedure reset;

  end;

implementation

procedure TPlayer.reset;
begin
  self.setToPosition(350 - self.size.width, 250 - self.size.height);
end;

end.
