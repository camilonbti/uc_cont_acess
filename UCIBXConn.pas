{-----------------------------------------------------------------------------
 Unit Name: UCIBXConn
 Author:    QmD
 Date:      08-nov-2004
 Purpose:   IBX Support

 registered in UCReg.pas
-----------------------------------------------------------------------------}

unit UCIBXConn;

interface

uses
  System.SysUtils, System.Classes, UCBase, Data.DB, IBX.IBDatabase,
  IBX.IBCustomDataSet, IBX.IBQuery;

type
  TUCIBXConn = class(TUCDataConn)
  private
    FConnection : TIBDatabase;
    FTransaction: TIBTransaction;
    procedure SetFTransaction(const Value: TIBTransaction);
    procedure SetIBXConnection(const Value: TIBDatabase);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);override;
  public
    function GetDBObjectName : String; override;
    function GetTransObjectName : String; override;
    function UCFindDataConnection : Boolean; override;
    function UCFindTable(const Tablename : String) : Boolean; override;
    function UCGetSQLDataset(FSQL : String) : TDataset; override;
    procedure UCExecSQL(FSQL: String);override;
  published
    property Connection : TIBDatabase read FConnection write SetIBXConnection;
    property Transaction : TIBTransaction read FTransaction write SetFTransaction;
  end;

implementation

{ TUCIBXConn }


procedure TUCIBXConn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FConnection) then FConnection := nil;
  if (Operation = opRemove) and (AComponent = FTransaction) then FTransaction := nil;
  inherited Notification(AComponent, Operation);
end;

function TUCIBXConn.UCFindTable(const TableName: String): Boolean;
var
  TempList : TStringList;
begin
  try
    TempList := TStringList.Create;
    FConnection.GetTableNames(TempList,False);
    TempList.Text := UpperCase(TempList.Text);
    Result := TempList.IndexOf(UpperCase(TableName)) > -1;
  finally
    FreeAndNil(TempList);
  end;
end;

function TUCIBXConn.UCFindDataConnection: Boolean;
begin
    Result := Assigned(FConnection) and (FConnection.Connected);
end;

function TUCIBXConn.GetDBObjectName: String; 
begin
  if Assigned(FConnection) then
  begin
    if Owner = FConnection.Owner then Result := FConnection.Name
    else begin
      Result := FConnection.Owner.Name+'.'+FConnection.Name;
    end;
  end else Result := '';
end;

function TUCIBXConn.GetTransObjectName: String;
begin
  if Assigned(FTransaction) then
  begin
    if Owner = FTransaction.Owner then Result := FTransaction.Name
    else begin
      Result := FTransaction.Owner.Name+'.'+FTransaction.Name;
    end;
  end else Result := '';
end;

procedure TUCIBXConn.UCExecSQL(FSQL: String);
begin
  with TIBQuery.Create(nil) do
  begin
    Database := FConnection;
    Transaction := FTransaction;
    if not Transaction.Active then Transaction.Active := True;
    SQL.Text := FSQL;
    ExecSQL;
    FTransaction.Commit;
    Free;
  end;
end;

function TUCIBXConn.UCGetSQLDataset(FSQL: String): TDataset;
begin
  Result := TIBQuery.Create(nil);
  with Result as TIBQuery do
  begin
    Database := FConnection;
    Transaction := FTransaction;
    SQL.text := FSQL;
    Open;
  end;
end;


procedure TUCIBXConn.SetFTransaction(const Value: TIBTransaction);
begin
  FTransaction := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TUCIBXConn.SetIBXConnection(const Value: TIBDatabase);
begin
  if FConnection <> Value then FConnection := Value;
  if FConnection <> nil then FConnection.FreeNotification(Self);
end;

end.
