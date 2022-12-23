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
    _picturePath: string;
    function _readPos: _TPos;
    function _readSize: _TSize;
    procedure bindBitmapToObject(Bitmap: TBitmap);
  public
    constructor create(AOwner: TComponent; screenObject: TRectangle); overload;
    procedure setImage(imagePath: string);
    procedure setToPosition(x: single; y: single);
    procedure setToX(x: single);
    procedure setToY(y: single);
    property Position: _TPos read _readPos;
    property Size: _TSize read _readSize;
  end;

implementation

{ * TBaseGameClass * }
constructor TBaseGameClass.create(AOwner: TComponent; screenObject: TRectangle);
begin
  inherited create(AOwner);
  self._screenObject := screenObject;
  screenObject.TagObject := self;
end;

function TBaseGameClass._readPos: _TPos;
begin
  result.x := self._screenObject.Position.x;
  result.y := self._screenObject.Position.y;
end;

function TBaseGameClass._readSize: _TSize;
begin
  result.width := self._screenObject.width;
  result.height := self._screenObject.height;
end;

procedure TBaseGameClass.setToPosition(x: single; y: single);
begin
  self._screenObject.Position.x := x;
  self._screenObject.Position.y := y;
end;

procedure TBaseGameClass.setToX(x: single);
begin
  self._screenObject.Position.x := x;
end;

procedure TBaseGameClass.setToY(y: single);
begin
  self._screenObject.Position.y := y;
end;

procedure TBaseGameClass.bindBitmapToObject(Bitmap: TBitmap);
begin
end;

procedure TBaseGameClass.setImage(imagePath: string);
begin
end;
end.
