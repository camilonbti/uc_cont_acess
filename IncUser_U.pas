unit IncUser_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, System.Variants, Data.DB, Vcl.Dialogs, vcl.Buttons,
  Vcl.ExtCtrls, Vcl.StdCtrls, UCBase, vcl.DBCtrls, UCXPStyle;

type
  TIncUser = class(TForm)
    Panel1: TPanel;
    LbDescricao: TLabel;
    Image1: TImage;
    Panel3: TPanel;
    btGravar: TBitBtn;
    btCancela: TBitBtn;
    Panel2: TPanel;
    lbNome: TLabel;
    EditNome: TEdit;
    lbLogin: TLabel;
    EditLogin: TEdit;
    lbEmail: TLabel;
    EditEmail: TEdit;
    ckPrivilegiado: TCheckBox;
    lbPerfil: TLabel;
    ComboPerfil: TDBLookupComboBox;
    btlimpa: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCancelaClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
    function GetNewIdUser : Integer;
    procedure btlimpaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FAltera : Boolean;
    UCComponent : TUserControl;
  end;

implementation

uses CadUser_U;

{$R *.dfm}

procedure TIncUser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TIncUser.btCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TIncUser.btGravarClick(Sender: TObject);
var
  FNovasenha, FNome, FLogin, FEmail  : String;
  FNewIdUser, FPerfil : integer;
  FPriv : Boolean;
begin
  btGravar.Enabled := False;

  with UCComponent do
  begin
    if not FAltera then
    begin // inclui user
      FNovasenha := LowerCase(Copy(Encrypt(FormatDateTime('zzzmm',Now), EncryptKey),2,6));
      if not Inputquery(Format(Settings.ResetPassword.WindowCaption,[EditLogin.Text]), Settings.ResetPassword.LabelPassword, FNovaSenha) then
      begin
        MessageDlg(Settings.CommonMessages.BlankPassword, mtWarning, [mbOK], 0);
        FNovasenha := '';
      end;
      FNewIdUser := GetNewIdUser;
      FNome := EditNome.Text;
      FLogin := EditLogin.Text;
      FEmail := EditEmail.Text;
      if ComboPerfil.KeyValue = null then FPerfil := 0 else FPerfil := ComboPerfil.KeyValue;
      FPriv := ckPrivilegiado.Checked;

      AddUser(FLogin, FNovaSenha, FNome, FEmail, FPerfil, FPriv);

      {$IFDEF Ver130}
      {$ELSE}
      if (Assigned(MailUserControl)) and (MailUserControl.AdicionaUsuario.Ativo ) then
        try
          MailUserControl.EnviaEmailAdicionaUsuario(FNome, FLogin, Encrypt(FNovaSenha, EncryptKey) , FEmail, IntToStr(FPerfil), EncryptKey);
        except
          on E : Exception do Log(e.Message, llWarning);
        end;
      {$ENDIF}
    end else begin // alterar user
      FNewIdUser := TCadUser(Self.Owner).DSCadUser.FieldByName('IdUser').asInteger;
      FNome := EditNome.Text;
      FLogin := EditLogin.Text;
      FEmail := EditEmail.Text;
      if ComboPerfil.KeyValue = null then FPerfil := 0 else FPerfil := ComboPerfil.KeyValue;
      FPriv := ckPrivilegiado.Checked;
      ChangeUser(FNewIdUser, FLogin, FNome, FEmail, FPerfil, FPriv);

      {$IFDEF Ver130}
      {$ELSE}
      if (Assigned(MailUserControl)) and (MailUserControl.AlteraUsuario.Ativo ) then
        try
          MailUserControl.EnviaEmailAlteraUsuario(FNome, FLogin, TCadUser(Self.Owner).DSCadUser.FieldByName('senha').asString, FEmail, IntToStr(FPerfil), EncryptKey);
        except
          on E : Exception do Log(e.Message, 2);
        end;
      {$ENDIF}
    end;
  end;
  TCadUser(Owner).DSCadUser.Close;
  TCadUser(Owner).DSCadUser.Open;

  TCadUser(Owner).DSCadUser.Locate('idUser',FNewIdUser,[]);
  Close;
end;

function TIncUser.GetNewIdUser: Integer;
var
  TempDs : TDataset;
begin
  with UCComponent do
    TempDS := DataConnector.UCGetSQLDataSet('SELECT ' + TableUsers.FieldUserID+' as MaxUserID from ' + TableUsers.TableName +
    ' ORDER BY ' + TableUsers.FieldUserID+' DESC');
  Result := TempDs.FieldByName('MaxUserID').asInteger + 1;
  TempDS.Close;
  FreeAndNil(TempDS);
end;

procedure TIncUser.btLimpaClick(Sender: TObject);
begin
  ComboPerfil.KeyValue := NULL
end;

procedure TIncUser.FormShow(Sender: TObject);
begin
  if not UCComponent.UsersProfile.Active then
  begin
    lbPerfil.Visible := False;
    ComboPerfil.Visible := False;
    btLimpa.Visible := False;
  end else
  begin
    ComboPerfil.ListSource.DataSet.Close;
    ComboPerfil.ListSource.DataSet.Open;
  end;
  ckPrivilegiado.Visible := UCComponent.UsersForm.UsePrivilegedField;
  if (UCComponent.UsersForm.ProtectAdmin) and (EditLogin.Text = UCComponent.Login.InitialLogin.User) then EditLogin.Enabled := False;
end;

end.


