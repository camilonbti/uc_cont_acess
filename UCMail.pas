{-----------------------------------------------------------------------------
 Unit Name: UCMail
 Author:    QmD
 Date:      09-nov-2004
 Purpose: Send Mail messages (forget password, user add/change/password force/etc)
 History: included indy 10 support
-----------------------------------------------------------------------------}


unit UCMail;
{$IFDEF VER170}
  {$I IdCompilerDefines.inc}
{$ELSE}
  {$IFDEF VER150}
    {$I IdCompilerDefines.inc}
  {$ELSE}
    {$IFDEF VER140}
      {$I IdCompilerDefines.inc}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdAntiFreezeBase, vcl.IdAntiFreeze, UCConsts,
  IdMessage, IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, vcl.Dialogs;

type
  TUCMailMessage = class(TPersistent)
  private
    FAtivo: Boolean;
    FTitulo: String;
    FLines: TStrings;
    procedure SetLines(const Value: TStrings);
  protected
  public
    constructor Create(AOwner : TComponent);
    destructor Destroy;override;
    procedure Assign(Source : TPersistent);override;
  published
    property Ativo : Boolean read FAtivo write FAtivo;
    property Titulo : String read FTitulo write FTitulo;
    property Mensagem : TStrings read FLines write SetLines;
  end;

type
  TUCMEsqueceuSenha = class(TUCMailMessage)
  private
    FLabelLoginForm: String;
    FMailEnviado: String;
  protected
  public
  published
    property LabelLoginForm : String read FLabelLoginForm write FLabelLoginForm;
    property MensagemEmailEnviado : String read FMailEnviado write FMailEnviado;
  end;

type
  TMessageTag = procedure ( Tag : String; var ReplaceText : String) of object;
  TMailUserControl = class(TComponent)
  private
    FPorta: Integer;
    FEmailRemetente: String;
    FUsuario: String;
    FNomeRemetente: String;
    FSenha: String;
    FSMTPServer: String;
    FAdicionaUsuario: TUCMailMessage;
    FSenhaTrocada: TUCMailMessage;
    FAlteraUsuario: TUCMailMessage;
    FSenhaForcada: TUCMailMessage;
    FIdAntiFreeze : TIdAntiFreeze;
    FEsqueceuSenha: TUCMEsqueceuSenha;
    function ParseMailMSG( Nome, Login, Senha, Email, Perfil, txt : String) : String;
    function TrataSenha(Senha: String; Key: word): String;
    procedure SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
  protected
    procedure EnviaEmailTp(Nome, Login, USenha, Email, Perfil : String; UCMSG: TUCMailMessage);
  public
    constructor Create(AOwner : TComponent); override;
    procedure EnviaEmailAdicionaUsuario( Nome, Login, Senha, Email, Perfil  : String; Key : word);
    procedure EnviaEmailAlteraUsuario( Nome, Login, Senha, Email, Perfil  : String; Key : word);
    procedure EnviaEmailSenhaForcada( Nome, Login, Senha, Email, Perfil : String);
    procedure EnviaEmailSenhaTrocada( Nome, Login, Senha, Email, Perfil  : String; Key : word);
    procedure EnviaEsqueceuSenha( Nome, Login, Senha, Email, Perfil : String; Key : Word);
  published
    property ServidorSMTP : String read FSMTPServer write FSMTPServer;
    property Usuario : String read FUsuario write FUsuario;
    property Senha : String read FSenha write FSenha;
    property Porta : Integer read FPorta write FPorta Default 25;
    property NomeRemetente : String read FNomeRemetente write FNomeRemetente;
    property EmailRemetente : String read FEmailRemetente write FEmailRemetente;
    property AdicionaUsuario : TUCMailMessage read FAdicionaUsuario write FAdicionaUsuario;
    property AlteraUsuario :  TUCMailMessage read FAlteraUsuario write FAlteraUsuario;
    property EsqueceuSenha : TUCMEsqueceuSenha  read FEsqueceuSenha write FEsqueceuSenha;
    property SenhaForcada :  TUCMailMessage read FSenhaForcada write FSenhaForcada;
    property SenhaTrocada :  TUCMailMessage read FSenhaTrocada write FSenhaTrocada;
  end;

implementation
uses UCBase, UCEMailForm_U;

{ TMailAdicUsuario }

procedure TUCMailMessage.Assign(Source: TPersistent);
begin
  if Source is TUCMailMessage then begin
    Self.Ativo := TUCMailMessage(Source).Ativo;
    Self.Titulo := TUCMailMessage(Source).Titulo;
    Self.Mensagem.Assign(TUCMailMessage(Source).Mensagem);
  end else inherited;
end;

constructor TUCMailMessage.Create(AOwner: TComponent);
begin
  FLines := TStringList.Create;
end;

destructor TUCMailMessage.Destroy;
begin

  inherited;
end;


procedure TUCMailMessage.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

{ TMailUserControl }

constructor TMailUserControl.Create(AOwner: TComponent);
begin
  inherited;
  AdicionaUsuario :=  TUCMailMessage.Create(self);
  AlteraUsuario :=  TUCMailMessage.Create(self);
  EsqueceuSenha :=  TUCMEsqueceuSenha.Create(self);
  SenhaForcada :=  TUCMailMessage.Create(self);
  SenhaTrocada :=  TUCMailMessage.Create(self);
  if csDesigning in ComponentState then begin
    Porta := 25;
    AdicionaUsuario.Ativo := True;
    AlteraUsuario.Ativo := True;
    EsqueceuSenha.Ativo := True;
    SenhaForcada.Ativo := True;
    SenhaTrocada.Ativo := True;
    EsqueceuSenha.LabelLoginForm := Const_Log_LbEsqueciSenha;
    EsqueceuSenha.MensagemEmailEnviado := Const_Log_MsgMailSend;
  end else begin
    FIdAntiFreeze := TIdAntiFreeze.Create(Self);
    FIdAntiFreeze.Active := True;
  end;
end;


procedure TMailUserControl.EnviaEmailAdicionaUsuario(Nome, Login, Senha, Email, Perfil  : String; Key : Word);
begin
  Senha := TrataSenha(Senha, Key);
  EnviaEmailTP(Nome, Login, Senha, Email, Perfil, AdicionaUsuario);
end;

procedure TMailUserControl.EnviaEmailAlteraUsuario(Nome, Login, Senha, Email, Perfil  : String; Key : Word);
begin
  Senha := TrataSenha(Senha, Key);
  EnviaEmailTP(Nome, Login, Senha, Email, Perfil, AlteraUsuario);
end;

procedure TMailUserControl.EnviaEmailSenhaForcada(Nome, Login, Senha, Email, Perfil : String);
begin
  EnviaEmailTP(Nome, Login, Senha, Email, Perfil, SenhaForcada);
end;

procedure TMailUserControl.EnviaEmailSenhaTrocada(Nome, Login, Senha, Email, Perfil  : String; Key : Word);
begin
  EnviaEmailTP(Nome, Login, Senha, Email, Perfil, SenhaTrocada);
end;


function TMailUserControl.ParseMailMSG( Nome, Login, Senha, Email, Perfil, txt : String) : String;
begin
  Txt := StringReplace( txt, ':nome', nome, [rfReplaceAll]);
  Txt := StringReplace( txt, ':login', login, [rfReplaceAll]);
  Txt := StringReplace( txt, ':senha', senha, [rfReplaceAll]);
  Txt := StringReplace( txt, ':email', email, [rfReplaceAll]);
  Txt := StringReplace( txt, ':perfil', perfil, [rfReplaceAll]);
  Result := Txt;

end;


procedure TMailUserControl.SMTPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  if not Assigned(UCEMailForm) then Exit;
  UCEMailForm.lbStatus.Caption := AStatusText;
  UCEMailForm.Update;
end;

procedure TMailUserControl.EnviaEmailTp(Nome, Login, USenha, Email, Perfil : String;
  UCMSG: TUCMailMessage);
var
  Mailmsg : TIdMessage;
  MailSMTP : TIdSMTP;
begin
  if Trim(Email) = '' then Exit;
  MailSMTP := TIdSMTP.Create(nil);
  MailSMTP.OnStatus := SMTPStatus;
  MailSMTP.Host := ServidorSMTP;
  {$IFDEF VER140}
    MailSMTP.UserID := Usuario;
  {$ENDIF}
  {$IFDEF VER150}
    MailSMTP.Username := Usuario;
  {$ENDIF}
  if Senha <> '' then begin
    MailSMTP.Password := Senha;

  {$IFDEF INDY100} //fixed 5/1/04 qmd

    MailSMTP.AuthType := atDefault;
    MailSMTP.AuthenticationType := atLogin;
  {$ELSE}


  {$ENDIF}
  end;
  MailMsg := TIdMessage.Create(nil);
  MailMSG.From.Address := EmailRemetente;
  MailMSG.From.Name := NomeRemetente;
  MailMSG.From.Text := NomeRemetente + ' <'+EmailRemetente+'>';
  with MailMSG.Recipients.Add do begin
    Address := email;
    Name := nome;
    Text := nome + ' <'+email+'>';
  end;
  MailMsg.Body.Text := ParseMailMSG(nome, login, USenha, email, Perfil, UCMSG.Mensagem.Text);
  MailMSG.Subject := UCMSG.Titulo;
  try
    try
    UCEMailForm := TUCEMailForm.Create(Self);
    UCEMailForm.lbStatus.Caption := '';
    UCEMailForm.Show;
    MailSMTP.Connect;
    MailSMTP.Send(MailMSG);
    except
      on e : Exception do
      begin
        UCEMailForm.lbStatus.Caption := E.Message;
        UCEMailForm.Update;
        Beep;
        Sleep(5000);
        raise;
      end;
    end;
  finally
    if MailSMTP.Connected then MailSMTP.Disconnect;
    MailMSG.Free;
    MailSMTP.Free;
    UCEMailForm.Close;
    FreeAndNil(UCEMailForm);
  end;
end;

procedure TMailUserControl.EnviaEsqueceuSenha( Nome, Login, Senha, Email, Perfil : String; Key : word);
begin
  if Trim(Email) = '' then Exit;
  try
    Senha := TrataSenha(Senha, Key);
    EnviaEmailTP(Nome, Login, Senha, Email, Perfil, EsqueceuSenha);
    MessageDlg(EsqueceuSenha.MensagemEmailEnviado, mtInformation, [mbOK], 0);
  except
  end;
end;
function TmailUserControl.TrataSenha( Senha : String; Key : word) : String;
begin
  Result := Decrypt(Senha, Key);
end;
end.
