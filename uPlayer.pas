unit uPlayer;

interface

uses
  System.Classes,
  FMX.Types, FMX.Objects;

type

  _TSize = record
    width: real;
    Height: real;
  end;

  _TPos = record
    x: real;
    y: real;
  end;

  TEventHandler = record
    LeftButton: Boolean;
    RightButton: Boolean;
    UpButton: Boolean;
    DownButton: Boolean;
    screenpos: _TPos;
    screensize: _TSize;
  end;

  TPlayer = class(TFMXObject)
  const
    velocity = 10;
  private
    screenObject: TRectangle;
    Position: _TPos;
  public
    constructor create(AOwner: TComponent;
      bindScreenObject: TRectangle); overload;
    procedure update(eventHandler: TEventHandler);

  end;

implementation

constructor TPlayer.create(AOwner: TComponent; bindScreenObject: TRectangle);
begin
  inherited create(AOwner);
  self.screenObject := bindScreenObject;
end;

procedure TPlayer.update(eventHandler: TEventHandler);
begin
  // move left
  if (eventHandler.LeftButton) then
  begin
    if (self.screenObject.Position.x - self.velocity > eventHandler.screenpos.x)
    then
    begin
      self.screenObject.Position.x := self.screenObject.Position.x -
        self.velocity;
    end
    else
    begin
      self.screenObject.Position.x := eventHandler.screenpos.x;
    end;
  end;

  // move right
  if (eventHandler.RightButton) then
  begin
    if (self.screenObject.Position.x + self.screenObject.width + self.velocity <
      eventHandler.screenpos.x + eventHandler.screensize.width) then
    begin
      self.screenObject.Position.x := self.screenObject.Position.x +
        self.velocity;
    end
    else
    begin
      self.screenObject.Position.x := eventHandler.screenpos.x +
        eventHandler.screensize.width - self.screenObject.width;
    end;
  end;

  // move down
  if (eventHandler.UpButton) then
  begin
    if (self.screenObject.Position.y - self.velocity > eventHandler.screenpos.y)
    then
    begin
      self.screenObject.Position.y := self.screenObject.Position.y -
        self.velocity;
    end
    else
    begin
      self.screenObject.Position.y := eventHandler.screenpos.y;
    end;
  end;

  // move up
  if (eventHandler.DownButton) then
  begin
    if (self.screenObject.Position.y + self.velocity + self.screenObject.Height
      < eventHandler.screenpos.y + eventHandler.screensize.Height) then
    begin
      self.screenObject.Position.y := self.screenObject.Position.y +
        self.velocity;
    end
    else
    begin
      self.screenObject.Position.y := eventHandler.screenpos.y +
        eventHandler.screensize.Height - self.screenObject.Height;
    end;
  end;

end;

end.
