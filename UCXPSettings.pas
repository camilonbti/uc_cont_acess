{
Class UCXPSettings:
Based on XPMenu 3.1 for Delphi

XPMenu for Delphi
Author: Khaled Shagrouni
URL: http://www.shagrouni.com/english/software/xpmenu.html
e-mail: khaled@shagrouni.com

Version 3.1 - 22.02.2004



XPMenu is a Delphi component to mimic Office XP menu and toolbar style.
Copyright (C) 2001, 2003 Khaled Shagrouni.

This component is FREEWARE with source code. I still hold the copyright, but
you can use it for whatever you like: freeware, shareware or commercial software.
If you have any ideas for improvement or bug reports, don't hesitate to e-mail
me <khaled@shagrouni.com> (Please state the XPMenu version and OS information).

--------------------------------------------------------------------------------
changes by QmD 30/11/2003 - qmd@usercontrol.com.br
* Add BitBtnColor / BitBtnSelectColor by QmD 30/11/2003 - qmd@usercontrol.com.br
* BitBtn Button multi-line corrected
* 29/03/2004 - XPmenu 2.21 incorporated in User Control Package. Class renamed to UCXPMenu to prevent conflicts (http://usercontrol.sourceforge.net)

changes by fduenas 29/12/2004 - fduenas@outm.net, fduenas@flashmail.com
* XPMenu.pas 3.1 Ported to UCXPStyle.pas by Francisco Dueñas fduenas@outm.net.
* File UCXPMenu.pas renamed to UCXPStyle.pas
* Class UCXPSet renamed to UCXPSettings
* File UCXPSet.pas renamed to UCXPSettings.pas

}
{$IFDEF VER130}
{$DEFINE VER5U}
{$ENDIF}

{$IFDEF VER140}
{$DEFINE VER5U}
{$DEFINE VER6U}
{$ENDIF}

{$IFDEF VER150}
{$DEFINE VER5U}
{$DEFINE VER6U}
{$DEFINE VER7U}
{$ENDIF}

unit UCXPSettings;

interface
uses
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  vcl.ComCtrls, Vcl.Forms, Vcl.Menus, Commctrl, Vcl.ExtCtrls, Vcl.StdCtrls, vcl.Buttons;

type
  TUCXPContainer = (xccForm, xccFrame, xccToolbar, xccCoolbar, xccControlbar, xccPanel,
                  xccScrollBox, xccGroupBox, xccTabSheet, xccPageScroller);
  TUCXPContainers = set of TUCXPContainer;

  TUCXPControl = (xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo, xcListBox,
                  xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcMiscEdit, xcCheckBox,
                  xcRadioButton, xcButton, xcBitBtn, xcSpeedButton, xcUpDown, xcPanel,
                  xcGroupBox, xcTreeView, xcListView, xcProgressBar, xcHotKey);
                  {xcStringGrid, xcDrawGrid, xcDBGrid)}

  TUCXPControls = set of TUCXPControl;

  TUCXPSettings = class(TPersistent)
  private
    {from UCXPStyle class}
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
    FColorsChanged: boolean; // +jt
    {END from UCXPStyle class}

    {from UCXPStyle class}
    FOverrideOwnerDraw: boolean;
    FGradient: boolean;
    FFlatMenu: boolean;
    FAutoDetect: boolean;
    FUCXPContainers: TUCXPContainers;
    FUCXPControls: TUCXPControls;
    FGrayLevel: byte;
    FDimLevel: byte;
    FDrawMenuBar: boolean;
    FUseDimColor: boolean;
    {END from UCXPStyle class}

    FBitBtnColor: TColor; //qmd

    {from UCXPStyle class}
    procedure SetFont(const Value: TFont);
    procedure SetColor(const Value: TColor);
    procedure SetIconBackColor(const Value: TColor);
    procedure SetMenuBarColor(const Value: TColor);
    procedure SetCheckedColor(const Value: TColor);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetSelectColor(const Value: TColor);
    procedure SetSelectBorderColor(const Value: TColor);
    procedure SetSeparatorColor(const Value: TColor);
    procedure SetSelectFontColor(const Value: TColor);
    procedure SetIconWidth(const Value: integer);
    procedure SetDrawSelect(const Value: boolean);
    procedure SetUseSystemColors(const Value: boolean);

    procedure SetOverrideOwnerDraw(const Value: boolean);
    procedure SetGradient(const Value: boolean);
    procedure SetFlatMenu(const Value: boolean);
    procedure SetDrawMenuBar(const Value: boolean);
    procedure SetUseDimColor(const Value: boolean);
    procedure SetAutoDetect(const Value: boolean);
    procedure SetUCXPContainers(const Value: TUCXPContainers);
    procedure SetUCXPControls(const Value: TUCXPControls);
    {END from UCXPStyle class}
    procedure SetBitBtnColor( const Value: TColor);
    procedure SetColorsChanged(const Value: boolean);

  protected
  public
    constructor Create(AOwner: TComponent);// override;
    procedure Assign(Source: TPersistent);override;
    destructor Destroy; override;
  published
    { from UCXPStyle class}
    property DimLevel: Byte read FDimLevel write FDimLevel;
    property GrayLevel: Byte read FGrayLevel write FGrayLevel;
    property Font: TFont read FFont write SetFont;
    property Color: TColor read FColor write SetColor;
    property DrawMenuBar: boolean read FDrawMenuBar write SetDrawMenuBar;
    property IconBackColor: TColor read FIconBackColor write SetIconBackColor;
    property MenuBarColor: TColor read FMenuBarColor write SetMenuBarColor;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property SelectBorderColor: TColor read FSelectBorderColor
     write SetSelectBorderColor;
    property SelectFontColor: TColor read FSelectFontColor
     write SetSelectFontColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property SeparatorColor: TColor read FSeparatorColor
     write SetSeparatorColor;
    property CheckedColor: TColor read FCheckedColor write SetCheckedColor;
    property IconWidth: integer read FIconWidth write SetIconWidth;
    property DrawSelect: boolean read FDrawSelect write SetDrawSelect;
    property UseSystemColors: boolean read FUseSystemColors
     write SetUseSystemColors;
    property UseDimColor: boolean read FUseDimColor write SetUseDimColor;
    property OverrideOwnerDraw: boolean read FOverrideOwnerDraw
     write SetOverrideOwnerDraw;
    property Gradient: boolean read FGradient write SetGradient;
    property FlatMenu: boolean read FFlatMenu write SetFlatMenu;
    property AutoDetect: boolean read FAutoDetect write SetAutoDetect;

    property XPContainers: TUCXPContainers read FUCXPContainers write SetUCXPContainers
      default [xccForm, xccFrame, xccToolbar, xccCoolbar, xccControlbar, xccPanel,
                  xccScrollBox, xccGroupBox, xccTabSheet, xccPageScroller];
    property XPControls :TUCXPControls read FUCXPControls write SetUCXPControls
      default [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo, xcListBox,
               xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcMiscEdit, xcCheckBox,
               xcRadioButton, xcButton, xcBitBtn, xcSpeedButton, xcUpDown, xcPanel,
               xcGroupBox, xcTreeView, xcListView, xcProgressBar, xcHotKey];
               {xcStringGrid, xcDrawGrid, xcDBGrid];}

    { END from UCXPStyle class}
    property BitBtnColor: TColor read FBitBtnColor write SetBitBtnColor; {qmd}
    property ColorsChanged: boolean read FColorsChanged write SetColorsChanged;

  end;

procedure GetSystemMenuFont(Font: TFont);

implementation


{ TUCXPSettings }

procedure TUCXPSettings.Assign(Source: TPersistent);
begin
  if Source is TUCXPSettings then
  begin
    {Based on UCXPStyle.Create method}
    Self.Font  := TUCXPSettings(Source).Font;
    Self.Color := TUCXPSettings(Source).Color;
    Self.IconBackColor := TUCXPSettings(Source).IconBackColor;
    Self.MenuBarColor := TUCXPSettings(Source).MenuBarColor;
    Self.CheckedColor := TUCXPSettings(Source).CheckedColor;
    Self.SeparatorColor := TUCXPSettings(Source).SeparatorColor;
    Self.SelectBorderColor := TUCXPSettings(Source).SelectBorderColor;
    Self.SelectColor := TUCXPSettings(Source).SelectColor;
    Self.DisabledColor := TUCXPSettings(Source).DisabledColor;
    Self.SelectFontColor := TUCXPSettings(Source).SelectFontColor;
    Self.IconWidth := TUCXPSettings(Source).IconWidth;
    Self.DrawSelect := TUCXPSettings(Source).DrawSelect;
    Self.UseSystemColors := TUCXPSettings(Source).UseSystemColors;

    Self.OverrideOwnerDraw := TUCXPSettings(Source).OverrideOwnerDraw;
    Self.Gradient := TUCXPSettings(Source).Gradient;
    Self.FlatMenu := TUCXPSettings(Source).FlatMenu;
    Self.AutoDetect := TUCXPSettings(Source).AutoDetect;
    Self.XPContainers := TUCXPSettings(Source).XPContainers;
    Self.XPControls := TUCXPSettings(Source).XPControls;
    Self.GrayLevel := TUCXPSettings(Source).GrayLevel;
    Self.DimLevel := TUCXPSettings(Source).DimLevel;
    Self.DrawMenuBar := TUCXPSettings(Source).DrawMenuBar;
    Self.UseDimColor := TUCXPSettings(Source).UseDimColor;
    {END from UCXPStyle class}

    Self.BitBtnColor := TUCXPSettings(Source).BitBtnColor; //qmd


  end else inherited;
end;

constructor TUCXPSettings.Create(AOwner: TComponent);
begin
  inherited Create;//(AOwner);
{  if csDesigning in ComponentState then
  begin}
    {FROM to UCXPSettings}
    FFont := TFont.Create;

    {$IFDEF VER5U}
     FFont.Assign(Screen.MenuFont);
    {$ELSE}
     GetSystemMenuFont(FFont);
    {$ENDIF}

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
    XPControls := [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcCombo, xcListBox,
                   xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcMiscEdit, xcCheckBox,
                   xcRadioButton, xcButton, xcBitBtn, xcSpeedButton, xcUpDown, xcPanel,
                   xcGroupBox, xcTreeView, xcListView, xcProgressBar, xcHotKey];
                  {xcStringGrid, xcDrawGrid, xcDBGrid];}

    {END FROM to UCXPSettings}
    FBitBtnColor := clBtnFace;
//  end;

end;


destructor TUCXPSettings.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

{END from UCXPStyle}
procedure TUCXPSettings.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  //Windows.DrawMenuBar(FForm.Handle);

end;

procedure TUCXPSettings.SetColor(const Value: TColor);
begin
  FColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetIconBackColor(const Value: TColor);
begin
  FIconBackColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetMenuBarColor(const Value: TColor);
begin
  FMenuBarColor := Value;
  FColorsChanged := true; // +jt
  //Windows.DrawMenuBar(FForm.Handle);
end;

procedure TUCXPSettings.SetCheckedColor(const Value: TColor);
begin
  FCheckedColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetSeparatorColor(const Value: TColor);
begin
  FSeparatorColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetSelectBorderColor(const Value: TColor);
begin
  FSelectBorderColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetSelectColor(const Value: TColor);
begin
  FSelectColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetSelectFontColor(const Value: TColor);
begin
  FSelectFontColor := Value;
  FColorsChanged := true; // +jt
end;

procedure TUCXPSettings.SetIconWidth(const Value: integer);
begin
  FIconWidth := Value;
end;

procedure TUCXPSettings.SetDrawSelect(const Value: boolean);
begin
  FDrawSelect := Value;
end;

procedure TUCXPSettings.SetOverrideOwnerDraw(const Value: boolean);
begin
  FOverrideOwnerDraw := Value;
  {
  if FActive then
    Active := True;
  }
end;

procedure TUCXPSettings.SetUseSystemColors(const Value: boolean);
begin
  FUseSystemColors := Value;
  {Windows.DrawMenuBar(FForm.Handle);}
end;

procedure TUCXPSettings.SetGradient(const Value: boolean);
begin
  FGradient := Value;
end;

procedure TUCXPSettings.SetFlatMenu(const Value: boolean);
begin
  FFlatMenu := Value;
end;

procedure TUCXPSettings.SetUCXPContainers(const Value: TUCXPContainers);
begin
  if Value <> FUCXPContainers then
  begin
    {if FActive then
    begin
      FActive := false;
      InitItems(FForm, false, true);
      FActive := true;
      FUCXPContainers := Value;
      InitItems(FForm, true, true);
    end;}
  end;
  FUCXPContainers := Value;

end;

procedure TUCXPSettings.SetUCXPControls(const Value: TUCXPControls);
begin
  if Value <> FUCXPControls then
  begin
   { if FActive then
    begin
      FActive := false;
      InitItems(FForm, false, true);
      FActive := true;
      FUCXPControls := Value;
      InitItems(FForm, true, true);
    end;}
  end;
  FUCXPControls := Value;

end;

procedure TUCXPSettings.SetDrawMenuBar(const Value: boolean);
begin
  FDrawMenuBar := Value;
end;

procedure TUCXPSettings.SetUseDimColor(const Value: boolean);
begin
  FUseDimColor := Value;
end;

procedure TUCXPSettings.SetAutoDetect(const Value: boolean);
begin
  FAutoDetect := Value;
end;
{END from UCXPStyle}
procedure TUCXPSettings.SetBitBtnColor( const Value: TColor);
begin
 FBitBtnColor := Value;
end;

procedure TUCXPSettings.SetColorsChanged(const Value: boolean);
begin
  FColorsChanged := Value;
end;

//generic
procedure GetSystemMenuFont(Font: TFont);
var
  FNonCLientMetrics: TNonCLientMetrics;
begin
//  FNonCLientMetrics.cbSize := Sizeof(TNonCLientMetrics);
//  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @FNonCLientMetrics,0) then
//  begin
//    Font.Handle := CreateFontIndirect(FNonCLientMetrics.lfMenuFont);
//    Font.Color := clMenuText;
//  end;
end;


end.
