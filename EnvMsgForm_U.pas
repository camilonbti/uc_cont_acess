unit EnvMsgForm_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vcl.Buttons, vcl.DBCtrls,
  Vcl.ExtCtrls, UCBase, Data.DB, UCXPStyle, DBClient, Vcl.Grids, Vcl.DBGrids,
  System.Variants;

type
  TEnvMsgForm = class(TForm)
    Panel1: TPanel;
    lbTitulo: TLabel;
    Image1: TImage;
    gbPara: TGroupBox;
    rbUsuario: TRadioButton;
    rbTodos: TRadioButton;
    dbUsuario: TDBLookupComboBox;
    gbMensagem: TGroupBox;
    lbAssunto: TLabel;
    lbMensagem: TLabel;
    EditAssunto: TEdit;
    MemoMsg: TMemo;
    btEnvia: TBitBtn;
    btCancela: TBitBtn;
    DataSource1: TDataSource;
    dblkpGrupo: TDBLookupComboBox;
    rbGrupo: TRadioButton;
    dsGruposUsuario: TDataSource;
    cdsGruposUsuario: TClientDataSet;
    procedure btCancelaClick(Sender: TObject);
    procedure dbUsuarioCloseUp(Sender: TObject);
    procedure rbUsuarioClick(Sender: TObject);
    procedure btEnviaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cdsGruposUsuarioBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure dblkpGrupoClick(Sender: TObject); //added by fduenas
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnvMsgForm: TEnvMsgForm;

implementation

uses MsgsForm_U, UCMessages, Modulo;
//#, Modulo;

{$R *.dfm}

procedure TEnvMsgForm.btCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TEnvMsgForm.dbUsuarioCloseUp(Sender: TObject);
begin
  if dbUsuario.KeyValue <> null then
  begin
    rbUsuario.Checked := True;
    dblkpGrupo.KeyValue := null;
  end;
end;

procedure TEnvMsgForm.rbUsuarioClick(Sender: TObject);
begin
  if not rbUsuario.Checked then
  begin
    dbUsuario.KeyValue := null;
    dblkpGrupo.KeyValue := null;
  end;
end;

procedure TEnvMsgForm.btEnviaClick(Sender: TObject);
begin
  if rbUsuario.checked then
    TUCAppMessage(MsgsForm.Owner).SendAppMessage(MsgsForm.DSUsuarios.fieldbyname('IdUser').asInteger,EditAssunto.Text, MemoMsg.Text )
  else begin
    with MsgsForm.DSUsuarios do
    begin
      First;
      while not eof do
      begin
        TUCAppMessage(MsgsForm.Owner).SendAppMessage(FieldByName('IdUser').asInteger, EditAssunto.Text, MemoMsg.Text );
        Next;
      end;
    end;
  end;
  Close;
end;

procedure TEnvMsgForm.FormCreate(Sender: TObject);
begin
 {with TUCAppMessage(Owner).UserControl.Settings.AppMessages do
 begin
  Self.Caption := MsgSend_WindowCaption;
  lbTitulo.Caption := MsgSend_Title;
  gbpara.Caption := MsgSend_GroupTo;
  rbUsuario.Caption := MsgSend_RadioUser;
  rbTodos.Caption := MsgSend_RadioAll;
  gbMensagem.Caption := MsgSend_GroupMessage;
  lbAssunto.Caption := MsgSend_LabelSubject;
  lbMensagem.Caption := MsgSend_LabelMessageText;
  btCancela.Caption := MsgSend_BtCancel;
  btEnvia.Caption := MsgSend_BtSend;
 end;}
end;

procedure TEnvMsgForm.cdsGruposUsuarioBeforeOpen(DataSet: TDataSet);
begin
  with cdsGruposUsuario do
  begin
    if Trim ( ProviderName ) = '' then
    begin
      RemoteServer := DM.SocketConnection;
      ProviderName := dm.SocketConnection.AppServer.Criar_DSP;
    end;
  end;
  dsGruposUsuario.DataSet := cdsGruposUsuario;
end;

procedure TEnvMsgForm.FormShow(Sender: TObject);
begin
    with cdsGruposUsuario do
    begin
      close;
      CommandText := 'select '+
                       ' UCIDUSER, '+
                       ' UCUSERNAME, '+
                       ' UCLOGIN, '+
                       ' UCPASSWORD, '+
                       ' UCEMAIL, '+
                       ' UCPRIVILEGED, '+
                       ' UCTYPEREC, '+
                       ' UCPROFILE, '+
                       ' UCKEY '+
                   ' from UCTABUSERS '+
                   ' where UCTYPEREC = '+ dm.SQL_Texto('P') +
                   ' order by 02';
      Open;

      dblkpGrupo.ListSource := dsGruposUsuario;
      dblkpGrupo.ListField := 'UCUSERNAME';
      dblkpGrupo.KeyField := 'UCIDUSER';

    end;
end;

procedure TEnvMsgForm.dblkpGrupoClick(Sender: TObject);
begin
  if Trim( dblkpGrupo.Text ) = '' then Exit;

  with DataSource1.DataSet do
  begin
    Filtered := False;
    Filter := 'Perfil = '+ dm.SQL_Decimal_0( cdsGruposUsuario.FieldByName('UCIDUSER').AsInteger);
    Filtered := True;
  end;
  rbGrupo.Checked := True;
  dblkpGrupo.SetFocus;
end;

end.
