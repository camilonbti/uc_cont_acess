unit LoginWindow_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vcl.Buttons,
  Vcl.ExtCtrls, math, System.Variants, jpeg, JvExExtCtrls, JvImage,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus,
  cxButtons, cxLabel;

type
  TLoginWindow = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    btOK: TBitBtn;
    BtCancela: TBitBtn;
    Panel4: TPanel;
    JvImage1: TJvImage;
    btOK1: TImage;
    Image7: TImage;
    lbEsqueci: TLabel;
    Panel1: TPanel;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    Panel5: TPanel;
    btnEntrar: TcxButton;
    btnSair: TcxButton;
    Panel6: TPanel;
    lblVersao: TcxLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure EditUsuarioChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EditSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure EditUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure Image7Click(Sender: TObject);
    procedure btOK1Click(Sender: TObject);
    procedure btnEntrarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);

  private

  end;

var
  LoginWindow: TLoginWindow;

implementation
uses UCBase;
{$R *.dfm}
function GetLocalComputerName: string;              //BGM
var                                                 //BGM
  Count: DWORD;                                     //BGM
  Buffer: string;                                   //BGM
begin                                               //BGM
  Count := MAX_COMPUTERNAME_LENGTH + 1;             //BGM
  SetLength(Buffer, Count);                         //BGM
  if GetComputerName(PChar(Buffer), Count) then     //BGM
    SetLength(Buffer, StrLen(PChar(Buffer)))        //BGM
  else                                              //BGM
    Buffer := '';                                   //BGM
  Result := Buffer;                                 //BGM
end;                                                //BGM

function GetLocalUserName: string;
var
  Count: DWORD;
  Buffer: string;
begin
  Count := 254;
  SetLength(Buffer, Count);
  if GetUserName(PChar(Buffer), Count) then
    SetLength(Buffer, StrLen(PChar(Buffer)))
  else
    Buffer := '';
  Result := Buffer;
end;

procedure TLoginWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Application.ProcessMessages;
    action := caFree;
  except
    on Exc:Exception do
      halt;
  end;
end;

procedure TLoginWindow.FormShow(Sender: TObject);
var
  x , y, w, h : Integer;
begin
//  w := Max(ImgTop.Width, ImgLeft.Width+PLogin.Width);
//  w := Max(w, ImgBottom.Width);
//  h := Max(ImgLeft.Height + ImgTop.Height + ImgBottom.Height , ImgTop.Height + PLogin.Height + ImgBottom.Height);

//c  Width := w;
//c  Height := h+28;

  // Topo
 // PTop.Height := ImgTop.Height;
 // ImgTop.AutoSize := False;
 // ImgTop.Align := alClient;
 // ImgTop.Center := True;

  //Centro
  //PLeft.Width := ImgLeft.Width;
  //ImgLeft.AutoSize := False;
  //ImgLeft.Align := alClient;
  //ImgLeft.Center := True;

  //Bottom
  //PBottom.Height := ImgBottom.Height;
  //ImgBottom.AutoSize := False;
  //ImgBottom.Align := alClient;
  //ImgBottom.Center := True;

  //PTop.visible := ImgTop.Picture <> nil;
  //PLeft.visible :=  ImgLeft.Picture <> nil;
  //PBottom.Visible := ImgBottom.Picture <> nil;

//c  x := (Screen.Width div 2) - (Width div 2);
//c  y := (Screen.Height div 2) - (Height div 2);
//c  top := y;
//c  Left := x;

  if TUserControl(Owner).Login.GetLoginName = lnUserName then EditUsuario.Text     := GetLocalUserName;
  if TUserControl(Owner).Login.GetLoginName = lnMachineName then EditUsuario.Text  := GetLocalComputerName;
  if TUserControl(Owner).Login.GetLoginName <> lnNone then EditSenha.SetFocus;
//  EditUsuario.Text := GetLocalComputerName;   //BGM

  lblVersao.Caption :=  'Versão: '+ GetVersionApp(ExtractFilePath(ParamStr(0))+ExtractFileName(Application.Exename));
  EditUsuario.SetFocus;

end;

procedure TLoginWindow.EditUsuarioChange(Sender: TObject);
begin
//  lbEsqueci.Enabled :=  length(EditUsuario.Text) > 0;
end;

procedure TLoginWindow.FormActivate(Sender: TObject);
begin
  Application.ProcessMessages;
  if EditUsuario.Text = '' then
    EditUsuario.SetFocus
  else
    EditSenha.SetFocus;
  Update;
end;

procedure TLoginWindow.EditSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    if (EditUsuario.Text <> '') and (EditSenha.Text <> '') then
    Begin
      btOK.Click;
      exit;
    end;
    KEY:=#0;
    PERFORM(WM_NEXTDLGCTL,0,0);
    if (KEY=#27) then
    Begin
      KEY:=#0;
      PERFORM(WM_NEXTDLGCTL,1,0);
    end;
  end;
end;

procedure TLoginWindow.EditUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    KEY:=#0;
    PERFORM(WM_NEXTDLGCTL,0,0);
  end;  
  if (KEY=#27) then
    Begin
      KEY:=#0;
      PERFORM(WM_NEXTDLGCTL,1,0);
    end;
end;

procedure TLoginWindow.Image7Click(Sender: TObject);
begin
  try
    Application.Terminate;
  except
    on Exc:Exception do
      halt;
  end;
end;

procedure TLoginWindow.btnEntrarClick(Sender: TObject);
begin
  try
    btOK.Click;
  except
    on Exc:Exception do
      halt
  end;
end;

procedure TLoginWindow.btnSairClick(Sender: TObject);
begin
  try
    Application.Terminate;
  except
    halt;
  end;
end;

procedure TLoginWindow.btOK1Click(Sender: TObject);
begin
   btOK.Click;
end;

end.
