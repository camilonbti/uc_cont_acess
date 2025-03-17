{-----------------------------------------------------------------------------
 Unit Name: UCMySQLDACConn
 Author:    QmD
 Date:      22-nov-2004
 Purpose:   MySQLDAC Support

 registered in UCMySQLDACReg.pas
-----------------------------------------------------------------------------}

unit UCMySQLDACConn;

interface

uses
  System.SysUtils, System.Classes, UCBase, Data.DB, mySQLDbTables;

type
  TUCMySQLDACConn = class(TUCDataConn)
  private
    FConnection : TmySQLDatabase;
    procedure SetFConnection(Value : TmySQLDatabase);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
  public
    function GetDBObjectName : String; override;
    function GetTransObjectName : String; override;
    function UCFindDataConnection : Boolean; override;
    function UCFindTable(const Tablename : String) : Boolean; override;
    function UCGetSQLDataset(FSQL : String) : TDataset;override;
    procedure UCExecSQL(FSQL: String);override;
  published
    property Connection : TmySQLDatabase read FConnection write SetFConnection;
  end;

implementation

{ TUCMySQLDACConn }

procedure TUCMySQLDACConn.SetFConnection(Value: TmySQLDatabase);
begin
  if FConnection <> Value then FConnection := Value;
  if FConnection <> nil then FConnection.FreeNotification(Self);
end;

procedure TUCMySQLDACConn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FConnection) then
  begin
    FConnection := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TUCMySQLDACConn.UCFindTable(const TableName: String): Boolean;
var
  TempList : TStringList;
begin
  try
    TempList := TStringList.Create;
    FConnection.GetTableNames(TableName, TempList);
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(TableName)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCMySQLDACConn.UCFindDataConnection: Boolean;
begin
    Result := Assigned(FConnection) and (FConnection.Connected);
end;

function TUCMySQLDACConn.GetDBObjectName: String;
begin
  if Assigned(FConnection) then
  begin
    if Owner = FConnection.Owner then Result := FConnection.Name
    else begin
      Result := FConnection.Owner.Name+'.'+FConnection.Name;
    end;
  end else Result := '';
end;

function TUCMySQLDACConn.GetTransObjectName: String;
begin
  Result := '';
end;

procedure TUCMySQLDACConn.UCExecSQL(FSQL: String);
begin
  FConnection.Execute(FSQL);
end;

function TUCMySQLDACConn.UCGetSQLDataset(FSQL: String): TDataset;
begin
  Result := TmySQLQuery.Create(nil);
  with Result as TmySQLQuery do
  begin
    Database := FConnection;
    SQL.Text := FSQL;
    Open;
  end;
end;

end.
