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

  _TPosition = class
  private
    coreClass: TRectangle;
    function readX: single;
    procedure writeX(x: single);
    function readY: single;
    procedure writeY(y: single);
  public
    property x: single read readX write writeX;
    property y: single read readY write writeY;
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
    procedure setToPosition(x: single; y: single);
    procedure setImage(imagePath: string);
    //property Position: TPosition read _screenObject.Position
    //  write _screenObject.Position;
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

procedure TBaseGameClass.bindBitmapToObject(Bitmap: TBitmap);
begin
end;

procedure TBaseGameClass.setImage(imagePath: string);
begin
end;



function _TPosition.readX: Single;
begin
  result := self.coreClass.Position.X;
end;

procedure _TPosition.writeX(x: Single);
begin
  self.coreClass.Position.x := x;
end;

function _TPosition.readY: Single;
begin
  result := self.coreClass.Position.Y;
end;

procedure _TPosition.writeY(y: Single);
begin
  self.coreClass.Position.y := y;
end;

end.
