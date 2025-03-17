unit UCXPSet;

interface
uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.ComCtrls,  Vcl.Forms,
  Vcl.Menus, Messages, Commctrl, Vcl.ExtCtrls, Vcl.StdCtrls, vcl.Buttons;
type
  TUCXPContainer = (xccForm, xccFrame, xccToolbar, xccCoolbar, xccControlbar, xccPanel,
                  xccScrollBox, xccGroupBox, xccTabSheet, xccPageScroller);
  TUCXPContainers = set of TUCXPContainer;

  TUCXPControl = (xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo,
                xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcCheckBox, xcRadioButton,
                xcButton, xcBitBtn, xcSpeedButton, xcPanel, xcGroupBox);

  TUCXPControls = set of TUCXPControl;

  TUCXPSet = class(TPersistent)
  private
    FFont: TFont;
    FColor: TColor;
    FIconBackColor: TColor;
    FMenuBarColor: TColor;
    FCheckedColor: TColor;
    FSeparatorColor: TColor;
    FSelectBorderColor: TColor;
    FSelectColor: TColor;
    FDisabledColor: TColor;
    FSelectFontColor: TColor;
    FIconWidth: integer;
    FDrawSelect: boolean;
    FUseSystemColors: boolean;


    FOverrideOwnerDraw: boolean;
    FGradient: boolean;
    FFlatMenu: boolean;
    FAutoDetect: boolean;
    FXPContainers: TUCXPContainers;
    FXPControls: TUCXPControls;
    FGrayLevel: byte;
    FDimLevel: byte;
    FBitBtnColor: TColor;

    procedure SetFont(const Value: TFont);
    procedure SetMenuBarColor(const Value: TColor);
    procedure SetUseSystemColors(const Value: boolean);
    procedure SetOverrideOwnerDraw(const Value: boolean);
    procedure SetXPContainers(const Value: TUCXPContainers);
    procedure SetXPControls(const Value: TUCXPControls);
  protected
  public
    constructor Create(AOwner: TComponent);// override;
    procedure Assign(Source: TPersistent);override;
    destructor Destroy; override;
  published
    property DimLevel: Byte read FDimLevel write FDimLevel;
    property GrayLevel: Byte read FGrayLevel write FGrayLevel;
    property Font: TFont read FFont write SetFont;
    property Color: TColor read FColor write FColor;
    property IconBackColor: TColor read FIconBackColor write FIconBackColor;
    property MenuBarColor: TColor read FMenuBarColor write SetMenuBarColor;
    property SelectColor: TColor read FSelectColor write FSelectColor;
    property SelectBorderColor: TColor read FSelectBorderColor write FSelectBorderColor;
    property SelectFontColor: TColor read FSelectFontColor write FSelectFontColor;
    property DisabledColor: TColor read FDisabledColor write FDisabledColor;
    property SeparatorColor: TColor read FSeparatorColor write FSeparatorColor;
    property CheckedColor: TColor read FCheckedColor write FCheckedColor;
    property IconWidth: integer read FIconWidth write FIconWidth;
    property DrawSelect: boolean read FDrawSelect write FDrawSelect;
    property UseSystemColors: boolean read FUseSystemColors write SetUseSystemColors;
    property OverrideOwnerDraw: boolean read FOverrideOwnerDraw write SetOverrideOwnerDraw;
    property Gradient: boolean read FGradient write FGradient;
    property FlatMenu: boolean read FFlatMenu write FFlatMenu;
    property AutoDetect: boolean read FAutoDetect write FAutoDetect;
    property XPContainers: TUCXPContainers read FXPContainers write SetXPContainers
      default [xccForm, xccFrame, xccToolbar, xccCoolbar, xccControlbar, xccPanel,
                  xccScrollBox, xccGroupBox, xccTabSheet, xccPageScroller];
    property XPControls :TUCXPControls read FXPControls write SetXPControls
      default [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo,
               xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcCheckBox, xcRadioButton,
               xcButton, xcBitBtn, xcSpeedButton, xcPanel, xcGroupBox];

    property BitBtnColor: TColor read FBitBtnColor write FBitBtnColor;


  end;

procedure GetSystemMenuFont(Font: TFont);

implementation


{ TUCXPSet }

procedure TUCXPSet.Assign(Source: TPersistent);
begin
  if Source is TUCXPSet then
  begin
    Self.AutoDetect := TUCXPSet(Source).AutoDetect;
    Self.BitBtnColor := TUCXPSet(Source).BitBtnColor;

    Self.CheckedColor := TUCXPSet(Source).CheckedColor;
    Self.Color := TUCXPSet(Source).Color;
    Self.DimLevel := TUCXPSet(Source).DimLevel;
    Self.DisabledColor := TUCXPSet(Source).DisabledColor;
    Self.DrawSelect := TUCXPSet(Source).DrawSelect;
    Self.FlatMenu := TUCXPSet(Source).FlatMenu;
    Self.Font := TUCXPSet(Source).Font;
    Self.Gradient := TUCXPSet(Source).Gradient;
    Self.GrayLevel := TUCXPSet(Source).GrayLevel;
    Self.IconBackColor := TUCXPSet(Source).IconBackColor;
    Self.IconWidth := TUCXPSet(Source).IconWidth;
    Self.MenuBarColor := TUCXPSet(Source).FMenuBarColor;
    Self.OverrideOwnerDraw := TUCXPSet(Source).OverrideOwnerDraw;
    Self.SelectBorderColor := TUCXPSet(Source).SelectBorderColor;
    Self.SelectColor := TUCXPSet(Source).SelectColor;
    Self.SelectFontColor := TUCXPSet(Source).SelectFontColor;
    Self.SeparatorColor := TUCXPSet(Source).SeparatorColor;
    Self.UseSystemColors :=  TUCXPSet(Source).UseSystemColors;
    Self.XPContainers := TUCXPSet(Source).XPContainers;
    Self.XPControls := TUCXPSet(Source).XPControls;
  end else inherited;
end;

constructor TUCXPSet.Create(AOwner: TComponent);
begin
  inherited Create;//(AOwner);
{  if csDesigning in ComponentState then
  begin}

    FFont := TFont.Create;
    GetSystemMenuFont(FFont);

    FUseSystemColors := true;

    FColor := clBtnFace;
    FIconBackColor := clBtnFace;
    FSelectColor := clHighlight;
    FSelectBorderColor := clHighlight;
    FMenuBarColor := clBtnFace;
    FDisabledColor := clInactiveCaption;
    FSeparatorColor := clBtnFace;
    FCheckedColor := clHighlight;
    FSelectFontColor := FFont.Color;
    FGrayLevel := 10;
    FDimLevel := 30;
    FIconWidth := 24;
    FDrawSelect := true;
    XPContainers := [xccForm, xccFrame, xccToolbar, xccCoolbar, xccControlbar, xccPanel,
                    xccScrollBox, xccGroupBox, xccTabSheet, xccPageScroller];
    XPControls := [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo,
                  xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcCheckBox, xcRadioButton,
                  xcButton, xcBitBtn, xcSpeedButton, xcPanel, xcGroupBox];


    FBitBtnColor := clBtnFace;
//  end;

end;


destructor TUCXPSet.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

procedure TUCXPSet.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
//  Windows.DrawMenuBar(FForm.Handle); qmd
end;

procedure TUCXPSet.SetMenuBarColor(const Value: TColor);
begin
  FMenuBarColor := Value;
//  Windows.DrawMenuBar(FForm.Handle); qmd
end;

procedure TUCXPSet.SetOverrideOwnerDraw(const Value: boolean);
begin
  FOverrideOwnerDraw := Value;
{  if FActive then  qmd
    Active := True;}
end;

procedure TUCXPSet.SetUseSystemColors(const Value: boolean);
begin
  FUseSystemColors := Value;
//  Windows.DrawMenuBar(FForm.Handle); qmd
end;

procedure TUCXPSet.SetXPContainers(const Value: TUCXPContainers);
begin
  if Value <> FXPContainers then
  begin
{    if FActive then
    begin
      FActive := false;
      InitItems(FForm, false, true);
      FActive := true;
      FXPContainers := Value;
      InitItems(FForm, true, true);
    end;}
  end;
  FXPContainers := Value;
end;

procedure TUCXPSet.SetXPControls(const Value: TUCXPControls);
begin
  if Value <> FXPControls then
  begin
{    if FActive then
    begin
      FActive := false;
      InitItems(FForm, false, true);
      FActive := true;
      FXPControls := Value;
      InitItems(FForm, true, true);
    end;}
  end;
  FXPControls := Value;
end;

//generic
procedure GetSystemMenuFont(Font: TFont);
var
  FNonCLientMetrics: TNonCLientMetrics;
begin
  FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics,0) then
  begin
    Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfMenuFont);
    Font.Color := clMenuText;

    //if Font.Name = 'MS Sans Serif' then
    //begin
    //  Font.Name := 'Tahoma';
    //  Font.Charset := DEFAULT_CHARSET;
    //end;

  end;
end;



end.
