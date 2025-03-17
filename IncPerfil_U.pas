unit IncPerfil_U;

interface

uses
{$IFDEF Ver150}
  System.Variants,
{$ENDIF}
{$IFDEF Ver140}
  System.Variants,
{$ENDIF}
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, vcl.Buttons, Vcl.ExtCtrls, UCBase, Data.DB, UCXPStyle;

type
  TIncPerfil = class(TForm)
    Panel1: TPanel;
    LbDescricao: TLabel;
    Image1: TImage;
    Panel3: TPanel;
    btGravar: TBitBtn;
    btCancela: TBitBtn;
    Panel2: TPanel;
    lbNome: TLabel;
    EditDescricao: TEdit;
    procedure btCancelaClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
  private
    function GetNewIdUser: Integer;
    { Private declarations }
  public
    FAltera : Boolean;
    UCComponent : TUserControl;
  end;

{var
  IncPerfil: TIncPerfil;}

implementation

{$R *.dfm}
uses CadPerfil_U;

procedure TIncPerfil.btCancelaClick(Sender: TObject);
begin
  Close;
end;

procedure TIncPerfil.btGravarClick(Sender: TObject);
var
  FNewIdUser : integer;
  FProfile : String;
begin
  btGravar.Enabled := False;
  with UCComponent do
  begin
    if not FAltera then
    begin // inclui perfil
      FNewIdUser := GetNewIdUser;
      FProfile := EditDescricao.Text;
      if Assigned(onAddProfile) then onAddProfile(TObject(Self.Owner.Owner), FProfile);


      DataConnector.UCExecSQL(Format('INSERT INTO %s(%s, %s, %s) Values(%d,%s,%s)',
                         [ TableUsers.TableName,
                           TableUsers.FieldUserID,
                           TableUsers.FieldUserName,
                           TableUsers.FieldTypeRec,
                           FNewIdUser,
                           QuotedStr(FProfile),
                           QuotedStr('P')]));


    end else begin // alterar perfil
      FNewIdUser := TCadPerfil(Self.Owner).DSPerfilUser.FieldByName('IdUser').asInteger;
      FProfile := EditDescricao.Text;

      DataConnector.UCExecSQL(Format('UPDATE %s SET %s = %s WHERE %s = %d',
                         [ TableUsers.TableName,
                           TableUsers.FieldUserName,
                           QuotedStr(FProfile),
                           TableUsers.FieldUserID,
                           FNewIdUser]));
    end;

  end;
  TCadPerfil(Owner).DSPerfilUser.Close;
  TCadPerfil(Owner).DSPerfilUser.Open;
  TCadPerfil(Owner).DSPerfilUser.Locate('IDUser',FNewIdUser,[]);
  Close;
end;

function TIncPerfil.GetNewIdUser: Integer;
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

end.
