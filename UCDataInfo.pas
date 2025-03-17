unit UCDataInfo;

interface

uses Classes;

type

  TUCTableUsers = class(TPersistent)
  private
    FEmail: String;
    FTypeRec: String;
    FUserID: String;
    FPrivileged: String;
    FUserName: String;
    FTable: String;
    FProfile: String;
    FLogin: String;
    FPassword: String;
    FKey: String;

  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property FieldUserID : String read FUserID write FUserID;
    property FieldUserName : String read FUserName write FUserName;
    property FieldLogin : String read FLogin write FLogin;
    property FieldPassword : String read FPassword write FPassword;
    property FieldEmail : String read FEmail write FEmail;
    property FieldPrivileged : String read FPrivileged write FPrivileged;
    property FieldTypeRec : String read FTypeRec write FTypeRec;
    property FieldProfile : String read FProfile write FProfile;
    property FieldKey : String read FKey write FKey;
    property TableName : String read FTable write FTable;
  end;

  TUCTableRights = class(TPersistent)
  private
    FUserID: String;
    FFormName: String;
    FModule: String;
    FTable: String;
    FObjName: String;
    FKey: String;

  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property FieldUserID : String read FUserID write FUserID;
    property FieldModule : String read FModule write FModule;
    property FieldComponentName : String read FObjName write FObjName;
    property FieldFormName : String read FFormName write FFormName;
    property FieldKey : String read FKey write FKey;
    property TableName : String read FTable write FTable;
  end;

implementation

{ TUCTableRights }

procedure TUCTableRights.Assign(Source: TPersistent);
begin
  if Source is TUCTableRights then
  begin
    Self.FieldUserID := TUCTableRights(Source).FieldUserID;
    Self.FieldModule := TUCTableRights(Source).FieldModule;
    Self.FieldComponentName := TUCTableRights(Source).FieldComponentName;
    Self.FieldFormName := TUCTableRights(Source).FieldFormName;
    Self.FieldKey := TUCTableRights(Source).FieldKey;
  end else inherited;
end;

constructor TUCTableRights.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TUCTableRights.Destroy;
begin

  inherited;
end;

{ TUCTableUsers }

procedure TUCTableUsers.Assign(Source: TPersistent);
begin
  if Source is TUCTableUsers then
  begin
    Self.FieldUserID := TUCTableUsers(Source).FieldUserID;
    Self.FieldUserName := TUCTableUsers(Source).FieldUserName;
    Self.FieldLogin := TUCTableUsers(Source).FieldLogin;
    Self.FieldPassword := TUCTableUsers(Source).FieldPassword;
    Self.FieldEmail := TUCTableUsers(Source).FieldEmail;
    Self.FieldPrivileged := TUCTableUsers(Source).FieldPrivileged;
    Self.FieldProfile := TUCTableUsers(Source).FieldProfile;
    Self.FieldKey := TUCTableUsers(Source).FieldKey;
    Self.TableName := TUCTableUsers(Source).TableName;
  end else inherited;
end;

constructor TUCTableUsers.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TUCTableUsers.Destroy;
begin
  inherited;
end;

end.
 