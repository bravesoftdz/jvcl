{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvPoweredBy.pas, released on 2005-03-30.

The Initial Developer of the Original Code is Robert Marquardt (robert_marquardt att gmx dott de)
Portions created by Robert Marquardt are Copyright (C) 2005 Robert Marquardt.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvPoweredBy;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows, Classes, Graphics, Controls,
  JvComponent;

type
  TJvPoweredBy = class(TJvGraphicControl)
  private
    FImage: TBitmap;
    FURL: string;
    {$IFDEF VisualCLX}
    FAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean);
    {$ENDIF VisualCLX}
  protected
    procedure Paint; override;
    procedure Click; override;
    {$IFDEF VisualCLX}
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    {$ENDIF VisualCLX}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property URL: string read FURL write FURL;
    property Image: TBitmap read FImage;
  end;

  // In a sense this component is silly :-). By using it the JVCL gets used.
  // Therefore it gets an exception from the MPL rule of mentioning the JVCL if using a JVCL component.

  TJvPoweredByJCL = class(TJvPoweredBy)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    {$IFDEF VCL}
    property DragCursor;
    property DragKind;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property Constraints;
    property Cursor default crHandPoint;
    property DragMode;
    property Height default 31;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Width default 195;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TJvPoweredByJVCL = class(TJvPoweredBy)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoSize;
    {$IFDEF VCL}
    property DragCursor;
    property DragKind;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF VCL}
    property Constraints;
    property Cursor default crHandPoint;
    property DragMode;
    property Height default 31;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property URL;
    property Visible;
    property Width default 209;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  JvJCLUtils, JvResources;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvPoweredBy.res}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
{$R ../Resources/JvPoweredBy.res}
{$ENDIF UNIX}

const
  cPoweredByJCL = 'JvPoweredByJCL';
  cPoweredByJVCL = 'JvPoweredByJVCL';

//=== { TJvPoweredBy } =======================================================

constructor TJvPoweredBy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImage := TBitmap.Create;
  {$IFDEF VisualCLX}
  FAutoSize := True;
  {$ENDIF VisualCLX}
  Cursor := crHandPoint;
end;

destructor TJvPoweredBy.Destroy;
begin
  FImage.Free;
  inherited Destroy;
end;

procedure TJvPoweredBy.Paint;
var
  DestRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(ClientRect);
  end;
  SrcRect := Rect(0, 0, FImage.Width, FImage.Height);
  {$IFDEF VCL}
  DestRect := SrcRect;
  {$ENDIF VCL}
  {$IFDEF VisualCLX}
  DestRect := Bounds(Left, Top, Width, Height);
  {$ENDIF VisualCLX}
  OffsetRect(DestRect, (ClientWidth - FImage.Width) div 2, (ClientHeight - FImage.Height) div 2);
  with Canvas do
  begin
    CopyMode := cmSrcCopy;
    CopyRect({$IFDEF VisualCLX} Canvas, {$ENDIF} DestRect, FImage.Canvas, SrcRect);
  end;
end;

procedure TJvPoweredBy.Click;
begin
  if not Assigned(OnClick) then
    OpenObject(URL)
  else
    inherited Click;
end;

procedure TJvPoweredBy.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  {$IFDEF COMPILER6_UP}
  if AutoSize and (Align in [alNone, alCustom]) then
  {$ELSE}
  if AutoSize and (Align = alNone) then
  {$ENDIF COMPILER6_UP}
    inherited SetBounds(ALeft, ATop, FImage.Width, FImage.Height)
  else
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

{$IFDEF VisualCLX}
procedure TJvPoweredBy.SetAutoSize(Value: Boolean);
begin
  if Value <> FAutoSize then
  begin
    FAutoSize := Value;
    if FAutoSize then
      SetBounds(Left, Top, Width, Height);
  end;
end;
{$ENDIF VisualCLX}

//=== { TJvPoweredByJCL } ====================================================

constructor TJvPoweredByJCL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImage.LoadFromResourceName(HInstance, cPoweredByJCL);
  FURL := RsURLPoweredByJCL;
  Width := 195;
  Height := 31;
end;

//=== { TJvPoweredByJVCL } ===================================================

constructor TJvPoweredByJVCL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImage.LoadFromResourceName(HInstance, cPoweredByJVCL);
  FURL := RsURLPoweredByJVCL;
  Width := 209;
  Height := 31;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

