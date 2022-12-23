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
  self.setToPosition(375 - self.size.width/2, 250 - self.size.height/2);
end;

end.