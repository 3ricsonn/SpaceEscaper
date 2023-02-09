unit uStartAnimation;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Layouts;

type
  TStartAnimationFrame = class(TFrame)
    BackgroundImageRectangle: TRectangle;
    ImageContainer: TLayout;
    FirstFrameRect: TRectangle;
    SecondFrameRect: TRectangle;
    FourthFrameRect: TRectangle;
    ThirdFrameRect: TRectangle;
    ControlsFrameRectangle: TRectangle;
    procedure resetFrame;
    procedure _changeToFrame(index: integer);
    procedure bindBitmapToBackground(image: TRectangle);
  private
    state: integer;
  public
    function changeFrame: boolean;
  end;

implementation

{$R *.fmx}

procedure TStartAnimationFrame.resetFrame;
begin
  self.state := 0;
  self.bindBitmapToBackground(self.FirstFrameRect);
end;

function TStartAnimationFrame.changeFrame: boolean;
begin
  self.state := self.state + 1;
  self._changeToFrame(self.state);

  if self.state < 5 then
  begin
    result := False;
  end
  else
  begin
    result := True;
  end;
end;

procedure TStartAnimationFrame._changeToFrame(index: integer);
begin
  case index of
    0:
      self.bindBitmapToBackground(self.FirstFrameRect);
    1:
      self.bindBitmapToBackground(self.SecondFrameRect);
    2:
      self.bindBitmapToBackground(self.ThirdFrameRect);
    3:
      self.bindBitmapToBackground(self.ControlsFrameRectangle);
    4:
      self.bindBitmapToBackground(self.FourthFrameRect);
  end;
end;

procedure TStartAnimationFrame.bindBitmapToBackground(image: TRectangle);
begin
  self.BackgroundImageRectangle.Stroke.Kind := TBrushKind.Bitmap;
  self.BackgroundImageRectangle.Fill.Kind := TBrushKind.Bitmap;
  self.BackgroundImageRectangle.Fill.Bitmap.Bitmap.Assign(image.Fill.Bitmap.Bitmap);
end;

end.
