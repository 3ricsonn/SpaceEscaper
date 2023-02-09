unit uBase;

interface

uses
  System.Classes,
  FMX.Types, FMX.Objects, FMX.Graphics;

type
  TEventHandler = record
    LeftButton: Boolean;
    RightButton: Boolean;
    UpButton: Boolean;
    DownButton: Boolean;
    EventButton: Boolean;
    ProcedeButton: Boolean;
  end;

  _TPos = record
    x: single;
    y: single;
  end;

  _TSize = record
    width: single;
    height: single;
  end;

  TBaseGameClass = class(TFMXObject)
  private
    _screenObject: TRectangle;
    function _readPos: _TPos;
    function _readSize: _TSize;
  public
    constructor create(AOwner: TComponent; screenObject: TRectangle);
      reintroduce;
    procedure bindBitmapToObject(image: TRectangle);
    procedure setToPosition(x: single; y: single);
    procedure setToX(x: single);
    procedure setToY(y: single);
    property Position: _TPos read _readPos;
    property Size: _TSize read _readSize;
  end;

function FRamdomRange(a: single; b: single): single;

implementation

// generate random number in an given interval
function FRamdomRange(a: single; b: single): single;
var
  r: single;
begin
  randomize;
  r := random;
  result := a + (b - a) * r;
end;

{ TBaseGameClass initialisation }
constructor TBaseGameClass.create(AOwner: TComponent; screenObject: TRectangle);
begin
  inherited create(AOwner);
  self._screenObject := screenObject;
  screenObject.TagObject := self;
end;

{ Get Screen Objects Position }
function TBaseGameClass._readPos: _TPos;
begin
  result.x := self._screenObject.Position.x;
  result.y := self._screenObject.Position.y;
end;

{ Get Screen Objects Dimensions }
function TBaseGameClass._readSize: _TSize;
begin
  result.width := self._screenObject.width;
  result.height := self._screenObject.height;
end;

{ Set Screen Objects Position }
procedure TBaseGameClass.setToPosition(x: single; y: single);
begin
  self._screenObject.Position.x := x;
  self._screenObject.Position.y := y;
end;

{ Set Screen Objects x-Value }
procedure TBaseGameClass.setToX(x: single);
begin
  self._screenObject.Position.x := x;
end;

{ Set Screen Objects y-Value }
procedure TBaseGameClass.setToY(y: single);
begin
  self._screenObject.Position.y := y;
end;

procedure TBaseGameClass.bindBitmapToObject(image: TRectangle);
begin
  self._screenObject.Stroke.Kind := TBrushKind.Bitmap;
  self._screenObject.Fill.Kind := TBrushKind.Bitmap;
  self._screenObject.Fill.Bitmap.Bitmap.Assign(image.Fill.Bitmap.Bitmap);
end;

end.
