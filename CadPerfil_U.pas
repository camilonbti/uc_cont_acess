{-----------------------------------------------------------------------------
 Unit Name: CadPerfil_U
 Author:    QmD
 Last Change:      25-abr-2005
 Purpose: User profile
 History: Corrected Bug on Apply XPStyle definitions
-----------------------------------------------------------------------------}

unit CadPerfil_U;

interface

uses
{$IFDEF Ver130}
{$ELSE}
  System.Variants,
{$ENDIF}
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.Menus, Data.DB, vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls, IncPerfil_U, Vcl.Grids,
  Vcl.DBGrids,  UCBase, UCXPStyle, DBClient, Vcl.Mask, vcl.DBCtrls;

type
  TCadPerfil = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    lbDescricao: TLabel;
    Image1: TImage;
    Panel3: TPanel;
    btAdic: TBitBtn;
    BtAlt: TBitBtn;
    BtExclui: TBitBtn;
    BtExit: TBitBtn;
    DataSource1: TDataSource;
    BtAcess: TBitBtn;
    cdsUsuarios: TClientDataSet;
    dsUsuarios: TDataSource;
    gridUsuarios: TDBGrid;
    dbedtID_Usuario: TDBEdit;
    procedure BtExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btAdicClick(Sender: TObject);
    procedure BtAltClick(Sender: TObject);
    procedure BtExcluiClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cdsUsuariosBeforeOpen(DataSet: TDataSet);
    procedure dbedtID_UsuarioChange(Sender: TObject);
  private
    IncPerfil: TIncPerfil;
  public
    UCComponent : TUserControl;
    DsPerfilUser : TDataset;
    procedure SetWindow(Adicionar: Boolean);
  end;


implementation

uses Modulo;


{$R *.dfm}

procedure TCadPerfil.BtExitClick(Sender: TObject);
begin
  Close;
end;

procedure TCadPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TCadPerfil.DBGrid1DblClick(Sender: TObject);
begin
  BtAlt.Click;
end;

procedure TCadPerfil.btAdicClick(Sender: TObject);
begin
  IncPerfil := TIncPerfil.Create(Self);
  IncPerfil.UCComponent := Self.UCComponent;
  SetWindow(True);
  IncPerfil.ShowModal;
  FreeAndNil(IncPerfil);
end;

procedure TCadPerfil.SetWindow(Adicionar : Boolean);
begin
  with TUserControl(owner).Settings.AddChangeProfile do
  begin
    IncPerfil.Caption := WindowCaption;
    if Adicionar then IncPerfil.LbDescricao.Caption := LabelAdd else IncPerfil.LbDescricao.Caption := LabelChange;
    IncPerfil.lbNome.Caption := LabelName;
    IncPerfil.btGravar.Caption := BtSave;
    IncPerfil.btCancela.Caption := BtCancel;
    //corrected 25/04/2005  QmD
  end;
end;

procedure TCadPerfil.BtAltClick(Sender: TObject);
begin
  if DSPerfilUser.IsEmpty then Exit;
  IncPerfil := TIncPerfil.Create(self);
  IncPerfil.UCComponent := Self.UCComponent;
  SetWindow(False);
  With IncPerfil do begin
    FAltera := True;
    EditDescricao.Text := DSPerfilUser.FieldByName('Nome').asString;
    ShowModal;
  end;
  FreeAndNil(IncPerfil);
end;

procedure TCadPerfil.BtExcluiClick(Sender: TObject);
var
  TempID : Integer;
  CanDelete : Boolean;
  ErrorMsg : String;
  TempDS : TDataset;
begin
  if DSPerfilUser.IsEmpty then Exit;
  TempID := DSPerfilUser.fieldByName('IDUser').asInteger;
  TempDS :=  UCComponent.DataConnector.UCGetSQLDataset('Select '+UCComponent.TableUsers.FieldUserID+' as IdUser from '+
                        UCComponent.TableUsers.TableName +
                        ' Where '+UCComponent.TableUsers.FieldTypeRec+' = ' + QuotedStr('U') +
                        ' AND '+UCComponent.TableUsers.FieldProfile+' = ' + IntToStr(TempID));

  if TempDS.FieldByName('IdUser').asInteger > 0 then
  begin
    TempDS.Close;
    FreeAndNil(TempDS);
    //changed by fduenas: PromptDelete_WindowCaption
    if MessageBox(handle, PChar(Format(UCComponent.Settings.UsersProfile.PromptDelete, [DSPerfilUser.fieldByName('Nome').asString])),
      PChar(UCComponent.Settings.UsersProfile.PromptDelete_WindowCaption), MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> idYes then Exit;
  end;
  TempDS.Close;
  FreeAndNil(TempDS);

  CanDelete := True;
  if Assigned(UCComponent.onDeleteProfile) then UCComponent.onDeleteProfile(TObject(Owner), TempID, CanDelete, ErrorMsg);
  if not CanDelete then begin
    MessageDlg(ErrorMSG, mtWarning, [mbOK], 0);
    Exit;
  end;

  with UCComponent do
  begin
    DataConnector.UCExecSQL('Delete from '+ TableUsers.TableName + ' where '+TableUsers.FieldUserID+' = '+ IntToStr(TempID));
    DataConnector.UCExecSQL('Delete from '+ TableRights.TableName + ' where '+TableRights.FieldUserID+' = '+ IntToStr(TempID));
    DataConnector.UCExecSQL('Delete from '+ TableRights.TableName + 'EX where '+TableRights.FieldUserID+' = '+ IntToStr(TempID));
    DataConnector.UCExecSQL('Update '+ TableUsers.TableName +
                            ' Set '+TableUsers.FieldProfile+' = null where '+TableUsers.FieldUserID+' = '+ IntToStr(TempID));
  end;
  DSPerfilUser.Close;
  DSPerfilUser.Open;
end;

procedure TCadPerfil.FormShow(Sender: TObject);
begin
  with UCComponent do
  begin
    DSPerfilUser := DataConnector.UCGetSQLDataset(
      Format('Select %s as IdUser, %s as Login, %s as Nome, %s as Tipo from %s Where %s  = %s ORDER BY %s',
             [TableUsers.FieldUserID, TableUsers.FieldLogin, TableUsers.FieldUserName, TableUsers.FieldTypeRec,
              TableUsers.TableName, TableUsers.FieldTypeRec, QuotedStr('P'), TableUsers.FieldUserName]) );


    DBGrid1.Columns[0].Title.Caption := Settings.UsersProfile.ColProfile;
  end;
  DataSource1.Dataset := DSPerfilUser;

  dbedtID_Usuario.DataSource := DataSource1;
  dbedtID_Usuario.DataField := 'IdUser';

  with cdsUsuarios do
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
                   ' where UCTYPEREC = '+ dm.SQL_Texto('U');
    Open;
  end;
end;

procedure TCadPerfil.cdsUsuariosBeforeOpen(DataSet: TDataSet);
begin
  with cdsUsuarios do
  begin
    if Trim ( ProviderName ) = '' then
    begin
      RemoteServer := DM.SocketConnection;
      ProviderName := dm.SocketConnection.AppServer.Criar_DSP;
    end;
  end;
  dsUsuarios.DataSet := cdsUsuarios;
  gridUsuarios.DataSource := dsUsuarios;
end;

procedure TCadPerfil.dbedtID_UsuarioChange(Sender: TObject);
begin
  with cdsUsuarios do
  begin
    Filtered := False;
      Filter := 'UCPROFILE = '+  dm.SQL_Decimal_0(DataSource1.DataSet.FieldByName('IdUser').AsInteger);
    Filtered := True;
  end;
end;

end.
