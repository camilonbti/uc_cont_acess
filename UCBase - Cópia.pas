{-----------------------------------------------------------------------------
 Unit Name: UCBase
 Author:    QmD
 changed:      06-dez-2004
 Purpose: Main Unit
 History: included delphi 2005 support
-----------------------------------------------------------------------------}
unit UCBase;

interface

  {$DEFINE UCACTMANAGER}

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, vcl.ExtActns, UCMail, UCXPSettings,
  UCDataInfo, vcl.ActnMan, vcl.ActnMenus, Vcl.Menus, vcl.ActnList, UCMessages,
  UCConsts, Data.DB;

function Decrypt(const S: AnsiString; Key: Word): AnsiString;
function Encrypt(const S: AnsiString; Key: Word): AnsiString;
function GetVersionApp(const AFileName: String): String;

{$IFDEF Ver130}
function StrToBool ( Valor : String) : Boolean;
function BoolToStr ( Valor : Boolean) : String;
{$ENDIF}
const
  llLow = 0;
  llDefault = 1;
  llWarning = 2;
  llCritical = 3;
type

  TUserDef = class(TComponent) //classe para armazenar usuario logado = currentuser
    public
     UserID, Profile : Integer;
     Username, LoginName, Password, Email : String;
     Privilegiado : Boolean;
  end;

  TCadastroUsuarios = class(TPersistent) // armazenar menuitem ou action responsavel pelo cadastro de usuarios
    private
      FActCadUsu: TAction;
      FMenuCadUsu: TMenuItem;
      FUsaPriv: Boolean;
      FLockADM: Boolean;
      procedure SetActCadUsu(const Value: TAction);
      procedure SetMenuCadUsu(const Value: TMenuItem);
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property Action : TAction read FActCadUsu write SetActCadUsu;
      property MenuItem : TMenuItem read FMenuCadUsu write SetMenuCadUsu;
      property UsePrivilegedField : Boolean read FUsaPriv write FUsaPriv;
      property ProtectAdmin : Boolean read FLockADM write FLockADM;
  end;

  TPerfilUsuarios = class(TPersistent) // armazenar menuitem ou action responsavel pelo Perfil de usuarios
    private
      FPerfUsuAtive: Boolean;
      FActPerfUsu: TAction;
      FMenuPerfUsu: TMenuItem;
      procedure SetActPerfUsu(const Value: TAction);
      procedure SetMenuPerfUsu(const Value: TMenuItem);
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property Active : Boolean read FPerfUsuAtive write FPerfUsuAtive;
      property Action : TAction read FActPerfUsu write SetActPerfUsu;
      property MenuItem : TMenuItem read FMenuPerfUsu write SetMenuPerfUsu;
  end;

  TTrocarSenha = class(TPersistent) // armazenar menuitem ou action responsavel pelo Form trocar senha
    private
      FForcePass: Boolean;
      FPassLen: Integer;
      FActChgPass: TAction;
      FMenuChgPassUsu: TMenuItem;
      procedure SetActChgPassUsu(const Value: TAction);
      procedure SetMenuChgPassUsu(const Value: TMenuItem);
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property Action : TAction read FActChgPass write SetActChgPassUsu;
      property MenuItem : TMenuItem read FMenuChgPassUsu write SetMenuChgPassUsu;
      property ForcePassword : Boolean read FForcePass write FForcePass;
      property MinPasswordLength  : Integer read FPassLen write FPassLen;
  end;


  TUCAutoLogin = class(TPersistent) // armazenar configuracao de Auto-Logon
    private
      FActive : Boolean;
      FAutoUser, FAutoPassword : String;
      FMessageOnError: Boolean;
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property Active : Boolean read FActive write FActive;
      property User : String read FAutoUser write FAutoUser;
      property Password : String read FAutoPassword write FAutoPassword;
      property MessageOnError : Boolean read FMessageOnError write FMessageOnError;
  end;

  TInitialLogin = class(TPersistent) // armazenar Dados do Login que sera criado na primeira execucao do programa.
    private
      FIniUser: String;
      FIniPass: String;
      FPermIni: TStrings;
      FEmail: String;
      procedure SetFPermIni(const Value: TStrings);
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property User : String read FIniUser write FIniUser;
      property Email : String read FEmail write FEmail;
      property Password : String read FIniPass write FIniPass;
      property InitialRights :  TStrings read FPermIni write SetFPermIni;
    end;
  TGetLoginName = (lnNone, lnUserName, lnMachineName);
  TLogin = class(TPersistent)
    private
      FAutoLogin: TUCAutoLogin;
      FPassNTry: Integer;
      FLoginInicial: TInitialLogin;
    FGetLoginName: TGetLoginName;
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property AutoLogon : TUCAutoLogin read FAutoLogin write FAutoLogin;
      property InitialLogin : TInitialLogin read FLoginInicial write FLoginInicial;
      property MaxLoginAttempts : Integer read FPassNTry write FPassNTry;
      property GetLoginName : TGetLoginName read FGetLoginName write FGetLoginName;
  end;


  TNaoPermitidos = class(TPersistent) // Ocultar e/ou Desabilitar os itens que o usuario nao tem acesso
    private
      FMenuVisible, FActionVisible : Boolean;
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property MenuVisible : Boolean read FMenuVisible write FMenuVisible;
      property ActionVisible : Boolean read FActionVisible write FActionVisible;
  end;

  TLogControl = class(TPersistent) // Responsavel pelo Controle de Log
    private
      FLogActive: Boolean;
      FTableLog: String;
      FMenuLog: TMenuItem;
      FActLog: TAction;
      procedure SetFMenuLog(const Value: TMenuItem);
      procedure SetFActLog(const Value: TAction);
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property Action : TAction read FActLog write SetFActLog;
      property Active : Boolean read FLogActive write FLogActive;
      property TableLog : String read FTableLog write FTableLog;
      property MenuItem : TMenuItem read FMenuLog write SetFMenuLog;
  end;


  TUCControlRight = class(TPersistent) // Menu / ActionList/ActionManager ou ActionMainMenuBar a serem Controlados
    private
      FActionList: TActionList;
      {$IFDEF UCACTMANAGER}
      FActionManager: TActionManager;
      FActionMainMenuBar : TActionMainMenuBar;
    FMainMenu: TMenu;
      {$ENDIF}
      procedure SetActionList(const Value: TActionList);
      {$IFDEF UCACTMANAGER}
      procedure SetActionManager(const Value: TActionManager);
      procedure  SetActionMainMenuBar(const Value: TActionMainMenuBar);
      procedure SetMainMenu(const Value: TMenu);
      {$ENDIF}
    public
      constructor Create(AOwner : TComponent);
      destructor Destroy; override;
      procedure Assign(Source : TPersistent);override;
    published
      property ActionList : TActionList read FActionList write SetActionList;
      property MainMenu : TMenu read FMainMenu write SetMainMenu;
      {$IFDEF UCACTMANAGER}
      property ActionManager : TActionManager read FActionManager write SetActionManager;
      property ActionMainMenuBar : TActionMainMenuBar read FActionMainMenuBar write SetActionMainMenuBar;
      {$ENDIF}

    end;


  TOnLogin                 = procedure (Sender : TObject; var User, Password : String) of object;
  TOnLoginSucess           = procedure (Sender : TObject; IdUser : integer; Usuario, Nome, Senha, Email : String; Privilegiado : Boolean) of object;
  TOnLoginError            = procedure (Sender : TObject; Usuario, Senha : String) of object;
  TOnApplyRightsMenuIt     = procedure (Sender : TObject; MenuItem : TMenuItem) of object;
  TOnApllyRightsActionIt   = procedure (Sender : TObject; Action : TAction) of Object;
  TCustomCadUsuarioForm    = procedure (Sender : TObject; var CustomForm : TCustomForm) of Object;
  TCustomPerfilUsuarioForm = procedure (Sender : TObject; var CustomForm : TCustomForm) of Object;
  TCustomLoginForm         = procedure (Sender : TObject; var CustomForm : TCustomForm) of Object;
  TCustomTrocarSenhaForm   = procedure (Sender : TObject; var CustomForm : TCustomForm) of Object;
  TCustomLogControlForm    = procedure (Sender : TObject; var CustomForm : TCustomForm) of Object;
  TCustomInicialMsg        = procedure (Sender : TObject; var CustomForm : TCustomForm; var Msg : TStrings) of Object;
  TOnAddUser               = procedure (Sender : TObject; var Login, Password, Name, Mail : String; var Profile : Integer; var Privuser : Boolean) of Object;
  TOnChangeUser            = procedure (Sender : TObject; IDUser: Integer; var Login, Name, Mail : String; var Profile : Integer; var Privuser : Boolean) of Object;
  TOnDeleteUser            = procedure (Sender : TObject; IDUser: Integer; var CanDelete : Boolean; var ErrorMsg : String) of Object;
  TOnAddProfile            = procedure (Sender : TObject; var Profile : String) of Object;
  TOnDeleteProfile         = procedure (Sender : TObject; IDProfile : Integer; var CanDelete : Boolean; var ErrorMsg : String) of Object;
  TOnChangePassword        = procedure (Sender : TObject; IDUser : Integer; Login, CurrentPassword, NewPassword : String) of Object;
  TOnLogoff                = procedure (Sender : TObject; IDUser : integer) of Object;

  TUCSettings = class;

  TUCAboutVar=String[10];


  TUCCollection = class;

  TUCRun = class;

  TUCControls = class;

  TUCAppMessage = class;

  TUCLoginMode = (lmActive, lmPassive);

  //data connector
  TUCDataConn = class(TComponent)
  private
  protected
  public
    procedure UCExecSQL(FSQL : String); virtual; abstract;
    function UCGetSQLDataset(FSQL: String): TDataset; dynamic; abstract;
    function UCFindTable(const Tablename : String) : Boolean; virtual; abstract;
    function UCFindDataConnection : Boolean; virtual; abstract;
    function GetDBObjectName : String; virtual; abstract;
    function GetTransObjectName : String; virtual; abstract;
  published

  end;

  TUserControl = class(TComponent) // Classe principal
  private
    FUser                  : TUserDef;
    FUserSettings          : TUserSettings;
    FAplID                 : String;
    FNaoPermitidos         : TNaoPermitidos;
    FOnLogin               : TOnLogin;
    FOnStartApp            : TNotifyEvent;
    FOnLoginError          : TOnLoginError;
    FOnLoginSucess         : TOnLoginSucess;
    FOnApplyRightsActionIt : TOnApllyRightsActionIt;
    FOnApplyRightsMenuIt   : TOnApplyRightsMenuIt;
    FLogControl            : TLogControl;
{$IFDEF VER130}
{$ELSE}
    FMailUserControl: TMailUserControl;
{$ENDIF}
    FEncrytKey               : Word;
    FCadUsuarios             : TCadastroUsuarios;
    FLogin                   : TLogin;
    FPerfUsuarios            : TPerfilUsuarios;
    FTrocarSenha             : TTrocarSenha;
    FUCControlRight          : TUCControlRight;
    FOnCustomCadUsuarioForm  : TCustomCadUsuarioForm;
    FCustomLogControlForm    : TCustomLogControlForm;
    FCustomLoginForm         : TCustomLoginForm;
    FCustomPerfilUsuarioForm : TCustomPerfilUsuarioForm;
    FCustomTrocarSenhaForm   : TCustomTrocarSenhaForm;
    FOnAddProfile            : TOnAddProfile;
    FOnAddUser               : TOnAddUser;
    FOnChangePassword        : TOnChangePassword;
    FOnChangeUser            : TOnChangeUser;
    FOnDeleteProfile         : TOnDeleteProfile;
    FOnDeleteUser            : TOnDeleteUser;
    FOnLogoff                : TOnLogoff;
    FCustomInicialMsg        : TCustomInicialMsg;
    FAbout                   : TUCAboutVar;
    FRightItems              : TUCCollection;
    FThUCRun                 : TUCRun;
    FAutoStart               : Boolean;
    FTableRights             : TUCTableRights;
    FTableUsers              : TUCTableUsers;
    FMode                    : TUCLoginMode;
    UCControlList            : TList;
    FUCDataConn              : TUCDataConn;
    LoginMonitorList         : TList;
    FAfterLogin              : TNotifyEvent;
    FTryKeyField             : Boolean;

    procedure SetItems(Value: TUCCollection);
    procedure SetWindow;
    procedure SetWindowProfile;
{$IFDEF VER130}
{$ELSE}
    procedure SetFMailUserControl(const Value: TMailUserControl);
{$ENDIF}
    procedure ActionCadUser(Sender: TObject);
    procedure ActionTrocaSenha(Sender: TObject);
    procedure ActionUserProfile(Sender: TObject);
    procedure ActionOKLogin(Sender: TObject);
    procedure TestaFecha(Sender: TObject; var CanClose: Boolean);
    procedure ApplySettings(SourceSettings: TUCSettings);
    procedure UnlockEX( FormObj : TCustomForm; ObjName : String);
    procedure LockEX( FormObj : TCustomForm; ObjName : String; naInvisible : Boolean);
{$IFDEF UCACTMANAGER}
    procedure TrataActMenuBarIt(IT: TActionClientItem; FDataset : TDataset);
    procedure IncPermissActMenuBar(idUser : Integer; Act: TAction);
{$ENDIF}
    procedure SetUCDataConn(const Value: TUCDataConn);
    procedure DoCheckValidationField;
  protected
    FRetry : Integer;
    FormCadastroUsuarios, FormPerfilUsuarios, FormTrocarSenha, FormLogin, FormLogControl : TCustomForm;
    procedure Loaded; override;
    procedure ActionBtPermissDefault;
    procedure ActionBtPermissProfileDefault;
    procedure CriaCadUserForm; dynamic;
    procedure CriaProfileUserForm; dynamic;
    procedure ActionLog(Sender : TObject); dynamic;
    procedure ActionBtPermiss(Sender : TObject); dynamic;
    procedure ActionBtPermissProfile(Sender: TObject); dynamic;
    procedure CriaTrocaSenhaForm; dynamic;
    procedure ActionTSBtGrava(Sender : TObject);
    procedure SetFUserSettings ( const Value : TUserSettings);
    procedure SetLoginWindow ( Form : TCustomForm);
    procedure Notification(AComponent: TComponent;
     AOperation: TOperation); override;
    procedure RegistraCurrentUser(dados: TDataset);
    procedure ApplyRightsObj(FDataset: TDataset ; FProfile : Boolean = False);
{$IFDEF VER130}
{$ELSE}
    procedure ActionEsqueceuSenha(Sender: TObject);
{$ENDIF}
    procedure ShowLogin;
    procedure ApplyRights;
    procedure CriaTableLog;
    procedure CriaTableRights(ExtraRights : Boolean = False);
    procedure CriaTabelaUsuarios(TableExists : Boolean);
    procedure CriaTabelaMsgs(const TableName : String);
    procedure TryAutoLogon;
    procedure AddUCControlMonitor(UCControl : TUCControls);
    procedure DeleteUCControlMonitor(UCControl : TUCControls);
    procedure ApplyRightsUCControlMonitor;
    procedure LockControlsUCControlMonitor;
    procedure AddLoginMonitor(UCAppMessage : TUCAppMessage);
    procedure DeleteLoginMonitor(UCAppMessage : TUCAppMessage);
    procedure NotificationLoginMonitor;
  public
    procedure Execute;
    procedure StartLogin;
    procedure ShowUserManager;
    procedure ShowProfileManager;
    procedure ShowLogManager;
    procedure ShowChangePassword;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CurrentUser : TUserDef read FUser write FUser;
    property Settings : TUserSettings read FUserSettings write SetFUserSettings;

    procedure Log( MSG : String; Level : Integer = llDefault);
    function VerificaLogin(User , Password : String) : Boolean;
    procedure Logoff;
    function AddUser(Login, Password, Name, Mail : String; Profile : Integer; PrivUser : Boolean) : Integer;
    procedure ChangeUser(IDUser : Integer; Login, Name, Mail : String; Profile : Integer; PrivUser : Boolean);
    procedure ChangePassword(IDUser : Integer; NewPassword: String);
    procedure AddRight(idUser : Integer; ItemRight : TObject; FullPath : Boolean = True);overload;
    procedure AddRight(idUser : Integer; ItemRight : String);overload;
    procedure AddRightEX( idUser : Integer; Module, FormName, ObjName : String);

    procedure HideField(Sender: TField; var Text: String; DisplayText: Boolean);

  published
    property About: TUCAboutVar read FAbout write FAbout;
    property AutoStart : Boolean read FAutoStart write FAutoStart;
    property ApplicationID : String read FAplID write FAplID;
    property ControlRight : TUCControlRight read FUCControlRight write FUCControlRight;
    property UsersForm : TCadastroUsuarios read FCadUsuarios write FCadUsuarios;
    property EncryptKey : word read FEncrytKey write FEncrytKey;
    property NotAllowedItems : TNaoPermitidos read FNaoPermitidos write FNaoPermitidos;
    property Login : TLogin read FLogin write FLogin;
    property LogControl : TLogControl read FLogControl write FLogControl;
    property ExtraRight: TUCCollection read FRightItems write SetItems;
    property LoginMode : TUCLoginMode read FMode write FMode;
{$IFDEF VER130}
{$ELSE}
    property MailUserControl : TMailUserControl read FMailUserControl write SetFMailUserControl;
{$ENDIF}

    property UsersProfile               : TPerfilUsuarios          read FPerfUsuarios            write FPerfUsuarios;
    property TableUsers                 : TUCTableUsers            read FTableUsers              write FTableUsers;
    property TableRights                : TUCTableRights           read FTableRights             write FTableRights;
    property ChangePasswordForm         : TTrocarSenha             read FTrocarSenha             write FTrocarSenha;
    property OnLogin                    : TOnLogin                 read FOnLogin                 write FOnLogin;
    property OnStartApplication         : TNotifyEvent             read FOnStartApp              write FOnStartApp;
    property OnLoginSucess              : TOnLoginSucess           read FOnLoginSucess           write FOnLoginSucess;
    property OnLoginError               : TOnLoginError            read FOnLoginError            write FOnLoginError;
    property OnApplyRightsMenuIt        : TOnApplyRightsMenuIt     read FOnApplyRightsMenuIt     write FOnApplyRightsMenuIt;
    property OnApplyRightsActionIt      : TOnApllyRightsActionIt   read FOnApplyRightsActionIt   write FOnApplyRightsActionIt;
    property OnCustomUsersForm          : TCustomCadUsuarioForm    read FOnCustomCadUsuarioForm  write FOnCustomCadUsuarioForm;
    property OnCustomUsersProfileForm   : TCustomPerfilUsuarioForm read FCustomPerfilUsuarioForm write FCustomPerfilUsuarioForm;
    property OnCustomLoginForm          : TCustomLoginForm         read FCustomLoginForm         write FCustomLoginForm;
    property OnCustomChangePasswordForm : TCustomTrocarSenhaForm   read FCustomTrocarSenhaForm   write FCustomTrocarSenhaForm;
    property OnCustomLogControlForm     : TCustomLogControlForm    read FCustomLogControlForm    write FCustomLogControlForm;
    property OnCustomInitialMsg         : TCustomInicialMsg        read FCustomInicialMsg        write FCustomInicialMsg;
    property OnAddUser                  : TOnAddUser               read FOnAddUser               write FOnAddUser;
    property OnChangeUser               : TOnChangeUser            read FOnChangeUser            write FOnChangeUser;
    property OnDeleteUser               : TOnDeleteUser            read FOnDeleteUser            write FOnDeleteUser;
    property OnAddProfile               : TOnAddProfile            read FOnAddProfile            write FOnAddProfile;
    property OnDeleteProfile            : TOnDeleteProfile         read FOnDeleteProfile         write FOnDeleteProfile;
    property OnChangePassword           : TOnChangePassword        read FOnChangePassword        write FOnChangePassword;
    property OnLogoff                   : TOnLogoff                read FOnLogoff                write FOnLogoff;
    property DataConnector              : TUCDataConn              read FUCDataConn              write SetUCDataConn;
    property OnAfterLogin               : TNotifyEvent             read FAfterLogin              write FAfterLogin;
    property CheckValidationKey         : Boolean                  read FTryKeyField             write FTryKeyField;
  end;


  TUCCollectionItem = class(TCollectionItem)
  private
    FFormName,
    FCompName,
    FCaption,
    FGroupName: string;

    procedure SetFormName(const Value: string);
    procedure SetCompName(const Value: string);
    procedure SetCaption(const Value: string);
    procedure SetGroupName(const Value: string);
  protected
    function GetDisplayName: string; override;
  public
  published
    property FormName  : string read FFormName  write SetFormName;
    property CompName  : string read FCompName  write SetCompName;
    property Caption   : string read FCaption   write SetCaption;
    property GroupName : string read FGroupName write SetGroupName;
  end;

  TUCCollection = class(TCollection)
  private
    FUCBase: TUserControl;
    function GetItem(Index: Integer): TUCCollectionItem;
    procedure SetItem(Index: Integer; Value: TUCCollectionItem);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(UCBase: TUserControl);
    function Add: TUCCollectionItem;
    property Items[Index: Integer]: TUCCollectionItem
      read GetItem write SetItem; default;
  end;

 TVerifThread = class(TThread)
  private
    procedure VerNovaMsg;
  public
    AOwner : TComponent;
  protected
    procedure Execute; override;
  end;

 TUCRun = class(TThread)
  private
    procedure UCStart;
  public
    AOwner : TComponent;
  protected
    procedure Execute; override;
  end;


  TUCAppMessage = class(TComponent)
  private
    FActive      : Boolean;
    FReady       : Boolean;
    FInterval    : integer;
    FUserControl : TUserControl;
    FVerifThread : TVerifThread;
    FTabelaMsg   : String;

    procedure SetActive(const Value: Boolean);
    procedure SetUserControl(const Value: TUserControl);

  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

  public
    constructor Create(AOWner : TComponent);override;
    destructor Destroy; override;

    procedure ShowMessages(Modal : Boolean = True);
    procedure SendAppMessage(ToUser: Integer; Subject, Msg: String);
    procedure DeleteAppMessage(IdMsg : Integer);
    procedure CheckMessages;

  published
    property Active        : Boolean      read FActive      write SetActive;
    property Interval      : integer      read FInterval    write FInterval;
    property TableMessages : String       read FTabelaMsg   write FTabelaMsg;
    property UserControl   : TUserControl read FUserControl write SetUserControl;
  end;

  TUCSettings = class(TComponent)
  private
    FAddProfileFormMSG  : TAddProfileFormMSG;
    FAddUserFormMSG     : TAddUserFormMSG;
    FCadUserFormMSG     : TCadUserFormMSG;
    FLogControlFormMSG  : TLogControlFormMSG;
    FLoginFormMSG       : TLoginFormMSG;
    FPermissFormMSG     : TPermissFormMSG;
    FProfileUserFormMSG : TProfileUserFormMSG;
    FResetPassword      : TResetPassword;
    FTrocaSenhaFormMSG  : TTrocaSenhaFormMSG;
    FUserCommomMSG      : TUserCommonMSG;
    FAppMessagesMSG     : TAppMessagesMSG;
    FUCXPSettings       : TUCXPSettings;
    FXPStyle            : Boolean;
    FPosition           : TPosition;

    procedure SetFAddProfileFormMSG(const Value: TAddProfileFormMSG);
    procedure SetFAddUserFormMSG(const Value: TAddUserFormMSG);
    procedure SetFCadUserFormMSG(const Value: TCadUserFormMSG);
    procedure SetFFormLoginMsg(const Value: TLoginFormMSG);
    procedure SetFLogControlFormMSG(const Value: TLogControlFormMSG);
    procedure SetFPermissFormMSG(const Value: TPermissFormMSG);
    procedure SetFProfileUserFormMSG(const Value: TProfileUserFormMSG);
    procedure SetFResetPassword(const Value: TResetPassword);
    procedure SetFTrocaSenhaFormMSG(const Value: TTrocaSenhaFormMSG);
    procedure SetFUserCommonMSg(const Value: TUserCommonMSG);
    procedure SetAppMessagesMSG(const Value: TAppMessagesMSG);

  protected

  public
    constructor Create(AOwner : TComponent);override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;

  published
    property AppMessages      : TAppMessagesMSG      read FAppMessagesMSG     write SetAppMessagesMSG;
    property CommonMessages   : TUserCommonMSG       read FUserCommomMSG      write SetFUserCommonMSg;
    property Login            : TLoginFormMSG        read FLoginFormMSG       write SetFFormLoginMsg;
    property Log              : TLogControlFormMSG   read FLogControlFormMSG  write SetFLogControlFormMSG;
    property UsersForm        : TCadUserFormMSG      read FCadUserFormMSG     write SetFCadUserFormMSG;
    property AddChangeUser    : TAddUserFormMSG      read FAddUserFormMSG     write SetFAddUserFormMSG;
    property AddChangeProfile : TAddProfileFormMSG   read FAddProfileFormMSG  write SetFAddProfileFormMSG;
    property UsersProfile     : TProfileUserFormMSG  read FProfileUserFormMSG write SetFProfileUserFormMSG;
    property Rights           : TPermissFormMSG      read FPermissFormMSG     write SetFPermissFormMSG;
    property ChangePassword   : TTrocaSenhaFormMSG   read FTrocaSenhaFormMSG  write SetFTrocaSenhaFormMSG;
    property ResetPassword    : TResetPassword       read FResetPassword      write SetFResetPassword;
    property XPStyleSet       : TUCXPSettings        read FUCXPSettings       write FUCXPSettings;
    property XPStyle          : Boolean              read FXPStyle            write FXPStyle;
    property WindowsPosition  : TPosition            read FPosition           write FPosition;
  end;

  TUCComponentsVar = String[10];

//  TUCComponentsVarProperty = class;

  TUCNotAllowed = (naInvisible, naDisabled);

  TUCControls = class (TComponent)
  private
    FGroupName    : String;
    FUCComponents : TUCComponentsVar;
    FUserControl  : TUserControl; //changed from FUCComp to FUserControl
    FUCNotAllowed : TUCNotAllowed;

    function GetUCAccessType: String;
    function GetActiveForm: String;
    procedure SetGroupName(const Value: String);
    procedure SetUserControl(const Value: TUserControl); //added by fduenas

  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

  public
    destructor Destroy; override;
    procedure ApplyRights;
    procedure LockControls;
    procedure ListComponents(Form: String; List : TStrings);

  published
    property AccessType  : String           read GetUCAccessType;
    property ActiveForm  : String           read GetActiveForm;
    property GroupName   : String           read FGroupName    write SetGroupName;
    property UserControl : TUserControl     read FUserControl  write SetUserControl; //Modified by fduenas
    property Components  : TUCComponentsVar read FUCComponents write FUCComponents;
    property NotAllowed  : TUCNotAllowed    read FUCNotAllowed write FUCNotAllowed;

  end;

procedure IniSettings( DestSettings : TUserSettings);
procedure IniSettings2(DestSettings: TUCSettings);

implementation

{$R UCLock.res}

{ TUserControl }
uses
  CadPerfil_U, CadUser_U, UserPermis_U, TrocaSenha_U,
  MsgRecForm_U, MsgsForm_U, LoginWindow_U, UCXPStyle, ViewLog_U;


constructor TUserControl.Create(AOwner: TComponent);
begin
  inherited;
  FUser := TUserDef.Create(self);
  ControlRight := TUCControlRight.Create(Self);
  Login := TLogin.Create(Self);
  LogControl := TLogControl.Create(Self);
  UsersForm := TCadastroUsuarios.Create(Self);
  UsersProfile := TPerfilUsuarios.Create(Self);
  ChangePasswordForm := TTrocarSenha.Create(Self);
  FUserSettings := TUserSettings.Create(Self);
  FNaoPermitidos := TNaoPermitidos.Create(Self);
  FRightItems := TUCCollection.Create(Self);
  TableUsers := TUCTableUsers.Create(Self);
  TableRights := TUCTableRights.Create(Self);
  if csDesigning in ComponentState then
  begin
    FMode := lmActive;
    with TableUsers do
    begin
      if TableName = ''       then TableName := 'UCTabUsers';
      if FieldUserID = ''     then FieldUserID := 'UCIdUser';
      if FieldUserName = ''   then FieldUserName := 'UCUserName';
      if FieldLogin = ''      then FieldLogin := 'UCLogin';
      if FieldPassword = ''   then FieldPassword := 'UCPassword';
      if FieldEmail = ''      then FieldEmail := 'UCEmail';
      if FieldPrivileged = '' then FieldPrivileged := 'UCPrivileged';
      if FieldTypeRec = ''    then FieldTypeRec := 'UCTypeRec';
      if FieldProfile = ''    then FieldProfile := 'UCProfile';
      if FieldKey = ''        then FieldKey := 'UCKey';
    end;
    with TableRights do
    begin
      if TableName = ''          then TableName := 'UCTabRights';
      if FieldUserID = ''        then FieldUserID := 'UCIdUser';
      if FieldModule = ''        then FieldModule := 'UCModule';
      if FieldComponentName = '' then FieldComponentName := 'UCCompName';
      if FieldFormName = ''      then FieldFormName := 'UCFormName';
      if FieldKey = ''           then FieldKey := 'UCKey'; 
    end;

    if LogControl.TableLog = '' then LogControl.TableLog := 'UCLog';
    if ApplicationID = '' then ApplicationID := 'NewProject';
    if Login.InitialLogin.User = '' then Login.InitialLogin.User := 'Admin';
    if Login.InitialLogin.Password = '' then Login.InitialLogin.Password := '#delphi';
    if Login.InitialLogin.Email = '' then Login.InitialLogin.Email := 'qmd@usercontrol.com.br';
    FAutoStart := True;
    UsersProfile.Active := True;
    UsersForm.UsePrivilegedField := False;
    UsersForm.ProtectAdmin := True;
    NotAllowedItems.MenuVisible := True;
    NotAllowedItems.ActionVisible := True;
  end else begin
    UCControlList := TList.Create;
    LoginMonitorList := TList.Create;
  end;
  IniSettings(Settings);
end;


procedure TUserControl.Loaded;
var
  Contador : integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    for Contador := 0 to Pred(Owner.ComponentCount) do
      if Owner.Components[Contador] is TUCSettings then ApplySettings(TUCSettings(Owner.Components[Contador]));

    //retornou 2.13 qmd

    if Assigned(UsersForm.MenuItem) and (not Assigned(UsersForm.MenuItem.OnClick)) then UsersForm.MenuItem.OnClick := ActionCadUser;
    if Assigned(UsersForm.Action) and (not Assigned(UsersForm.Action.OnExecute)) then UsersForm.Action.OnExecute := ActionCadUser;

    if UsersProfile.Active then
    begin
      if Assigned(UsersProfile.MenuItem) and (not Assigned(UsersProfile.MenuItem.OnClick)) then UsersProfile.MenuItem.OnClick := ActionUserProfile;
      if Assigned(UsersProfile.Action) and (not Assigned(UsersProfile.Action.OnExecute)) then UsersProfile.Action.OnExecute := ActionUserProfile;
    end;

    if Assigned(ChangePasswordForm.MenuItem) and (not Assigned(ChangePasswordForm.MenuItem.OnClick)) then ChangePasswordForm.MenuItem.OnClick := ActionTrocaSenha;
    if Assigned(ChangePasswordForm.Action) and (not Assigned(ChangePasswordForm.Action.OnExecute)) then ChangePasswordForm.Action.OnExecute := ActionTrocaSenha;

    if (LogControl.Active) then
    begin
      if Assigned(LogControl.MenuItem) and (not Assigned(LogControl.MenuItem.OnClick)) then LogControl.MenuItem.OnClick := ActionLog;
      if Assigned(LogControl.Action) and (not Assigned(LogControl.Action.OnExecute))then LogControl.Action.OnExecute := ActionLog;
    end;

    if not Assigned(DataConnector) then raise Exception.Create('Property DataConnector not defined!');

    if ApplicationID = '' then raise Exception.Create(MsgExceptAppID);

    with TableUsers do
    begin
      if TableName = ''       then Exception.Create(MsgExceptUsersTable);
      if FieldUserID = ''     then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldUserID***');
      if FieldUserName = ''   then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldUserName***');
      if FieldLogin = ''      then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldLogin***');
      if FieldPassword = ''   then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldPassword***');
      if FieldEmail = ''      then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldEmail***');
      if FieldPrivileged = '' then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldPrivileged***');
      if FieldTypeRec = ''    then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldTypeRec***');
      if FieldKey = ''        then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldKey***');
      if FieldProfile = ''    then Exception.Create(MsgExceptUsersTable +#13+#10+ 'FieldProfile***');
    end;
    with TableRights do
    begin
      if TableName = ''          then Exception.Create(MsgExceptRightsTable);
      if FieldUserID = ''        then Exception.Create(MsgExceptRightsTable +#13+#10+ 'FieldProfile***');
      if FieldModule = ''        then Exception.Create(MsgExceptRightsTable +#13+#10+ 'FieldModule***');
      if FieldComponentName = '' then Exception.Create(MsgExceptRightsTable +#13+#10+ 'FieldComponentName***');
      if FieldFormName = ''      then Exception.Create(MsgExceptRightsTable +#13+#10+ 'FieldFormName***');
      if FieldKey = ''           then Exception.Create(MsgExceptRightsTable +#13+#10+ 'FieldKey***');
    end;

    if Assigned(OnStartApplication) then OnStartApplication(self);

    //desviar para thread monitorando conexao ao banco qmd 30/01/2004
    if FAutoStart then
    begin
      FThUCRun := TUCRun.Create(True);
      FThUCRun.AOwner := Self;
      FThUCRun.FreeOnTerminate := True;
      FThUCRun.Resume;
    end;
  end;
end;

procedure TUserControl.ActionUserProfile(Sender : TObject);
begin
  if Assigned(OnCustomUsersProfileForm) then OnCustomUsersProfileForm(Self, FormPerfilUsuarios);
  if FormPerfilUsuarios = nil then CriaProfileUserForm;
  FormPerfilUsuarios.ShowModal;
  FreeAndNil(FormPerfilUsuarios);
end;

procedure TUserControl.CriaProfileUserForm;
begin
  FormPerfilUsuarios := TCadPerfil.Create(self);
  with Settings.UsersProfile, TCadPerfil(FormPerfilUsuarios) do
  begin
    Caption := WindowCaption;
    lbDescricao.Caption := LabelDescription;
    btAdic.Caption := BtAdd;
    BtAlt.Caption := BtChange;
    BtExclui.Caption := BtDelete;
    BtAcess.Caption := BtRights;
    BtExit.Caption := BtClose;
    BtAcess.OnClick := ActionBtPermissProfile;
    UCComponent := Self;
   //c Position := Self.Settings.WindowsPosition;
  end;

end;


procedure TUserControl.ActionBtPermissProfile(Sender: TObject);
begin
  if TCadPerfil(FormPerfilUsuarios).DSPerfilUser.IsEmpty then Exit;
  UserPermis := TUserPermis.Create(self);
  UserPermis.UCComponent := Self;
  SetWindowProfile;
  UserPermis.lbUser.Caption := TCadPerfil(FormPerfilUsuarios).DSPerfilUser.FieldByName('Nome').asString;
  ActionBtPermissProfileDefault;
end;

procedure TUserControl.SetWindowProfile;
begin
  with Settings.Rights do
  begin
    UserPermis.Caption := WindowCaption;
    UserPermis.LbDescricao.Caption := LabelProfile;
    UserPermis.lbUser.Left := UserPermis.LbDescricao.Left + UserPermis.LbDescricao.Width + 5;
    UserPermis.PageMenu.Caption := PageMenu;
    UserPermis.PageAction.Caption := PageActions;
    UserPermis.BtLibera.Caption := BtUnlock;
    UserPermis.BtBloqueia.Caption := BtLock;
    UserPermis.BtGrava.Caption := BtSave;
    UserPermis.BtCancel.Caption := BtCancel;

  end;
end;


procedure TUserControl.ActionCadUser(Sender: TObject);
begin
  if Assigned(OnCustomUsersForm) then OnCustomUsersForm(Self, FormCadastroUsuarios);
  if FormCadastroUsuarios = nil then CriaCadUserForm;
  FormCadastroUsuarios.ShowModal;
  FreeAndNil(FormCadastroUsuarios);
end;


procedure TUserControl.ActionTrocaSenha(Sender: TObject);
begin
  if Assigned(OnCustomChangePasswordForm) then OnCustomChangePasswordForm(Self, FormTrocarSenha);
  if FormTrocarSenha = nil then CriaTrocaSenhaForm;
  FormTrocarSenha.ShowModal;
  FreeAndNil(FormTrocarSenha);
end;


procedure TUserControl.CriaCadUserForm;
begin
  FormCadastroUsuarios := TCadUser.Create(self);
  with Settings.UsersForm, TCadUser(FormCadastroUsuarios) do
  begin
    Caption := WindowCaption;
//    lbDescricao.Caption := LabelDescription;
    btAdic.Caption := BtAdd;
    BtAlt.Caption := BtChange;
    BtExclui.Caption := BtDelete;
    BtAcess.Caption := BtRights;
    BtPass.Caption := BtPassword;
    BtExit.Caption := BtClose;
    BtAcess.OnClick := Self.ActionBtPermiss;
    UCComponent := Self;

   //c Position := Self.Settings.WindowsPosition;
  end;
end;

procedure TUserControl.ActionBtPermiss(Sender: TObject);
begin
  if TCadUser(FormCadastroUsuarios).DSCadUser.IsEmpty then Exit;
  UserPermis := TUserPermis.Create(self);
  UserPermis.UCComponent := Self;
  SetWindow;
  UserPermis.lbUser.Caption := TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('Login').asString;
  ActionBtPermissDefault;
end;

procedure TUserControl.SetWindow;
begin
  with Settings.Rights do
  begin
    UserPermis.Caption := WindowCaption;
    UserPermis.LbDescricao.Caption := LabelUser;
    UserPermis.lbUser.Left := UserPermis.LbDescricao.Left + UserPermis.LbDescricao.Width + 5;
    UserPermis.PageMenu.Caption := PageMenu;
    UserPermis.PageAction.Caption := PageActions;
    UserPermis.BtLibera.Caption := BtUnlock;
    UserPermis.BtBloqueia.Caption := BtLOck;
    UserPermis.BtGrava.Caption := BtSave;
    UserPermis.BtCancel.Caption := BtCancel;

  end;
end;

procedure TUserControl.CriaTrocaSenhaForm;
begin
 FormTrocarSenha := TTrocaSenha.Create(Self);
 with Settings.ChangePassword do begin
   TTrocaSenha(FormTrocarSenha).Caption := WindowCaption;
   TTrocaSenha(FormTrocarSenha).lbDescricao.Caption := LabelDescription;
   TTrocaSenha(FormTrocarSenha).lbSenhaAtu.Caption := LabelCurrentPassword;
   TTrocaSenha(FormTrocarSenha).lbNovaSenha.Caption := LabelNewPassword;
   TTrocaSenha(FormTrocarSenha).lbConfirma.Caption := LabelConfirm;
   TTrocaSenha(FormTrocarSenha).btGrava.Caption := BtSave;
   TTrocaSenha(FormTrocarSenha).btCancel.Caption := BtCancel;
 end;
 TTrocaSenha(FormTrocarSenha).btGrava.OnClick := ActionTSBtGrava;
 if CurrentUser.Password = '' then TTrocaSenha(FormTrocarSenha).EditAtu.Enabled := False;
end;

procedure TUserControl.ActionTSBtGrava(Sender: TObject);
begin
   if CurrentUser.Password <> TTrocaSenha(FormTrocarSenha).EditAtu.text then
   begin
     MessageDlg(Settings.CommonMessages.ChangePasswordError.InvalidCurrentPassword, mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditAtu.SetFocus;
     Exit;
   end;
   if TTrocaSenha(FormTrocarSenha).EditNova.Text <> TTrocaSenha(FormTrocarSenha).EditConfirma.Text then
   begin
     MessageDlg(Settings.CommonMessages.ChangePasswordError.InvalidNewPassword, mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditNova.SetFocus;
     Exit;
   end;
   if TTrocaSenha(FormTrocarSenha).EditNova.Text = CurrentUser.Password then
   begin
     MessageDlg(Settings.CommonMessages.ChangePasswordError.NewEqualCurrent, mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditNova.SetFocus;
     Exit;
   end;
   if (ChangePasswordForm.ForcePassword) and (TTrocaSenha(FormTrocarSenha).EditNova.Text = '') then
   begin
     MessageDlg( Settings.CommonMessages.ChangePasswordError.PasswordRequired, mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditNova.Text;
     Exit;
   end;
   if Length(TTrocaSenha(FormTrocarSenha).EditNova.Text) < ChangePasswordForm.MinPasswordLength then
   begin
     MessageDlg(Format(Settings.CommonMessages.ChangePasswordError.MinPasswordLength,[ChangePasswordForm.MinPasswordLength]), mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditNova.SetFocus;
     Exit;
   end;
   if Pos(LowerCase(TTrocaSenha(FormTrocarSenha).EditNova.Text),'asdfqwerzxcv1234567890321654987teste'+LowerCase(CurrentUser.Username) + LowerCase(CurrentUser.LoginName)) > 0 then
   begin
     MessageDlg( Settings.CommonMessages.ChangePasswordError.InvalidNewPassword, mtWarning, [mbOK], 0);
     TTrocaSenha(FormTrocarSenha).EditNova.SetFocus;
     Exit;
   end;

   if Assigned( OnChangePassword) then OnChangePassword(Self, CurrentUser.UserID, CurrentUser.LoginName, CurrentUser.Password,TTrocaSenha(FormTrocarSenha).EditNova.Text);
   ChangePassword(CurrentUser.UserID, TTrocaSenha(FormTrocarSenha).EditNova.Text);

   CurrentUser.Password := TTrocaSenha(FormTrocarSenha).EditNova.Text;
   if CurrentUser.Password = '' then MessageDlg(Format(Settings.CommonMessages.BlankPassword,[CurrentUser.LoginName]) , mtInformation, [mbOK], 0)
   else MessageDlg(Settings.CommonMessages.PasswordChanged, mtInformation, [mbOK], 0);

{$IFDEF VER130}
{$ELSE}
   if ( Assigned(MailUserControl) ) and (MailUserControl.SenhaTrocada.Ativo) then
   begin
     with CurrentUser do
     begin
       try
         MailUserControl.EnviaEmailSenhaTrocada( Username, LoginName, TTrocaSenha(FormTrocarSenha).EditNova.Text, Email, '', EncryptKey);
       except
         on e : Exception do Log(e.Message,2);
       end;
     end;
   end;
{$ENDIF}
   TTrocaSenha(FormTrocarSenha).Close;
end;


const
  Codes64 = '0A1B2C3D4E5F6G7H89IjKlMnOPqRsTuVWXyZabcdefghijkLmNopQrStUvwxYz+/';
  C1 = 52845;
  C2 = 22719;

function Decode(const S: AnsiString): AnsiString;
const
  Map: array[AnsiChar] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 63, 52, 53,
    54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2,
    3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
    46, 47, 48, 49, 50, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0);
var
  I: LongInt;
begin
  case Length(S) of
    2:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6);
        SetLength(Result, 1);
        Move(I, Result[1], Length(Result))
      end;
    3:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12);
        SetLength(Result, 2);
        Move(I, Result[1], Length(Result))
      end;
    4:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12) +
          (Map[S[4]] shl 18);
        SetLength(Result, 3);
        Move(I, Result[1], Length(Result))
      end
  end
end;

function PreProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Decode(Copy(SS, 1, 4));
    Delete(SS, 1, 4)
  end
end;

function InternalDecrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: int64;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := AnsiChar(Byte(Result[I]) xor (Seed shr 8));
    Seed := (Byte(S[I]) + Seed) * Word(C1) + Word(C2)
  end
end;

function Decrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := InternalDecrypt(PreProcess(S), Key)
end;

function Encode(const S: AnsiString): AnsiString;
const
  Map: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    'abcdefghijklmnopqrstuvwxyz0123456789+/';
var
  I: LongInt;
begin
  I := 0;
  Move(S[1], I, Length(S));
  case Length(S) of
    1:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64];
    2:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] +
        Map[(I shr 12) mod 64];
    3:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] +
        Map[(I shr 12) mod 64] + Map[(I shr 18) mod 64]
  end
end;

function PostProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Encode(Copy(SS, 1, 3));
    Delete(SS, 1, 3)
  end
end;

function InternalEncrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: int64;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := AnsiChar(Byte(Result[I]) xor (Seed shr 8));
    Seed := (Byte(Result[I]) + Seed) * Word(C1) + Word(C2)
  end
end;

function Encrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := PostProcess(InternalEncrypt(S, Key))
end;

procedure TUserControl.SetFUserSettings(const Value: TUserSettings);
begin
  Settings := Value;
end;

procedure TUserControl.SetLoginWindow(Form: TCustomForm);
begin
  with Settings.Login, Form as TLoginWindow do
  begin
    Caption := WindowCaption;
    btOK.Caption := Settings.Login.BtOk;
    BtCancela.Caption := BtCancel;
//    if LeftImage <> nil then ImgLeft.Picture.Assign(LeftImage);
//    if BottomImage <> nil then ImgBottom.Picture.Assign(BottomImage);
//    if TopImage <> nil then ImgTop.Picture.Assign(TopImage);
{$IFDEF VER130}
{$ELSE}
    if Assigned(MailUserControl) then
    begin
      lbEsqueci.Visible := MailUserControl.EsqueceuSenha.Ativo;
      lbEsqueci.Caption := MailUserControl.EsqueceuSenha.LabelLoginForm;
    end;
{$ENDIF}
{    UCXPStyle.XPSettings.Assign(Self.Settings.XpStyleSet); qmd problema com foco
    UCXPStyle.Active := Self.Settings.XPStyle;}
   //c Position := Self.Settings.WindowsPosition;
  end;

end;


procedure TUserControl.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) then
  begin
    if AComponent = UsersForm.MenuItem then UsersForm.MenuItem := nil;
    if AComponent = UsersForm.Action then UsersForm.Action := nil;
    if AComponent = UsersProfile.MenuItem then UsersProfile.MenuItem := nil;
    if AComponent = UsersProfile.Action then UsersProfile.Action := nil;
    if AComponent = ChangePasswordForm.Action then ChangePasswordForm.Action := nil;
    if AComponent = ChangePasswordForm.MenuItem then ChangePasswordForm.MenuItem := nil;
    if AComponent = ControlRight.MainMenu then ControlRight.MainMenu := nil;
    if AComponent = ControlRight.ActionList then ControlRight.ActionList := nil;
    {$IFDEF UCACTMANAGER}
    if AComponent = ControlRight.ActionManager then ControlRight.ActionManager := nil;
    if AComponent = ControlRight.ActionMainMenuBar then  ControlRight.ActionMainMenuBar := nil;
    {$ENDIF}
    if AComponent = LogControl.MenuItem then LogControl.MenuItem := nil;
    if AComponent = LogControl.Action then LogControl.Action := nil;
    if AComponent = FUCDataConn then FUCDataConn := nil;
{$IFDEF VER130}
{$ELSE}
    if AComponent = FMailUserControl then FMailUserControl := nil;
{$ENDIF}
  end;
  inherited Notification (AComponent, AOperation);
end;


procedure TUserControl.ActionLog(Sender: TObject);
begin
  FormLogControl := TViewLog.Create(self);
  TViewLog(FormLogControl).UCComponent := Self;
  with TViewLog(FormLogControl), Settings.Log do
  begin
    Caption := WindowCaption;
    lbDescricao.Caption := LabelDescription;
    lbUsuario.Caption := LabelUser;
    lbData.Caption := LabelDate;
    lbNivel.Caption := LabelLevel;
    BtFiltro.Caption := BtFilter;
    BtExclui.Caption := BtDelete;
    BtFecha.Caption := BtClose;
    DbGrid1.Columns[0].Title.Caption := ColLevel;
    DbGrid1.Columns[1].Title.Caption := ColMessage;
    DbGrid1.Columns[2].Title.Caption := ColUser;
    DbGrid1.Columns[3].Title.Caption := ColDate;
   //c Position := Self.Settings.WindowsPosition;
  end;
  TViewLog(FormLogControl).ShowModal;
  FreeandNil(FormLogControl);
end;

procedure TUserControl.Log(MSG: String; Level: Integer);
begin
  if not LogControl.Active then Exit;
  DataConnector.UCExecSQL('Insert into ' + LogControl.TableLog + '( IdUser, MSG, Data, Nivel) Values ( '+
            IntToStr(CurrentUser.UserID)+', '+
            QuotedStr(Copy(MSG,1,250))+', '+
            QuotedStr(FormatDateTime('YYYYMMDDhhmmss',now))+', '+
            IntToStr(Level)+')');
end;
{$IFDEF VER130}
{$ELSE}
procedure TUserControl.SetFMailUserControl(const Value: TMailUserControl);
begin
  FMailUserControl := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;
{$ENDIF}

procedure TUserControl.RegistraCurrentUser( dados : TDataset);
begin
  with CurrentUser do
  begin
    UserID := Dados.FieldByName(TableUsers.FieldUserID).asInteger;
    Username := Dados.FieldByName(TableUsers.FieldUserName).asString;
    LoginName:= Dados.FieldByName(TableUsers.FieldLogin).asString;
    Password := Decrypt(Dados.FieldByName(TableUsers.FieldPassword).asString, EncryptKey);
    Email := Dados.FieldByName(TableUsers.FieldEmail).asString;
    Privilegiado := StrToBool(Dados.FieldByName(TableUsers.FieldPrivileged).asString);
    Profile := Dados.FieldByName(TableUsers.FieldProfile).asInteger;
    if Assigned(OnLoginSucess) then OnLoginSucess(Self, UserID, LoginName, UserName, Password, EMail, Privilegiado);
  end;
  ApplyRightsUCControlMonitor;
  NotificationLoginMonitor;
end;


{$IFDEF VER130}
{$ELSE}
procedure TUserControl.ActionEsqueceuSenha(Sender: TObject);
var
  FDataset : TDataset;
begin
  FDataset := DataConnector.UCGetSQLDataset('Select * from '+ TableUsers.TableName + ' Where '+
              TableUsers.FieldLogin+' = '+ QuotedStr(TLoginWindow(FormLogin).EditUsuario.Text));
  with FDataset do
    try
      if not IsEmpty then
        MailUserControl.EnviaEsqueceuSenha( fieldbyname(TableUsers.FieldUserName).asString,
                                            fieldbyname(TableUsers.FieldLogin).asString,
                                            fieldbyname(TableUsers.FieldPassword).asString,
                                            fieldbyname(TableUsers.FieldEmail).asString, '', EncryptKey)
      else MessageDlg(Settings.CommonMessages.InvalidLogin, mtWarning, [mbOK], 0);
    finally
      Close;
      Free;
    end;
end;
{$ENDIF}

procedure TUserControl.TryAutoLogon;
begin
  if not VerificaLogin(Login.AutoLogon.User, Login.AutoLogon.Password) then
  begin
    if Login.AutoLogon.MessageOnError then MessageDlg(Settings.CommonMessages.AutoLogonError, mtWarning, [mbOK], 0);
    ShowLogin;
  end;
end;


function TUserControl.VerificaLogin(User, Password: String): Boolean;
var
  vSenha, Key : String;
  FDataset : TDataset;
begin
  vSenha := TableUsers.FieldPassword +  ' = ' + QuotedStr(Encrypt(Password, EncryptKey));
  FDataset := DataConnector.UCGetSQLDataset('Select * from '+ TableUsers.TableName + ' Where '+
              TableUsers.FieldLogin+' = '+ QuotedStr(User) + ' and ' + vSenha);
   ////exibe a senha admin

///
  //excluir
//          FDataset := DataConnector.UCGetSQLDataset('Select * from '+ TableUsers.TableName + ' Where '+
//                       TableUsers.FieldLogin+' = '+ QuotedStr('Admin'));
//               Key := Decrypt(FDataset.FieldByName(TableUsers.FieldKey).asString, EncryptKey);
  ////

  with FDataset do
    try
      if not IsEmpty then
      begin
        Key := Decrypt(FDataset.FieldByName(TableUsers.FieldKey).asString, EncryptKey);

        if Key <> FDataSet.FieldByName(TableUsers.FieldUserID).asString +
                  FDataSet.FieldByName(TableUsers.FieldLogin).asString +
                  Decrypt(FDataSet.FieldByName(TableUsers.FieldPassword).asString, EncryptKey) then
        begin
          Result := False;
          if Assigned(OnLoginError) then OnLoginError(Self, User, Password);
        end else
        begin
          Result := True;
          RegistraCurrentuser(FDataset);
        end;
      end else begin
        Result := False;
        if Assigned(OnLoginError) then OnLoginError(Self, User, Password);
      end;
    finally
      Close;
      Free;
    end;
end;

procedure TUserControl.Logoff;
begin
  if Assigned(onLogoff) then
    onLogoff(Self, CurrentUser.UserID);
  LockControlsUCControlMonitor;

  CurrentUser.UserID := 0;
  if LoginMode = lmActive then
    ShowLogin;
  ApplyRights;
end;

function TUserControl.AddUser(Login, Password, Name, Mail: String;
  Profile: Integer; PrivUser: Boolean) : Integer;
var
  Key : String;
begin
  with DataConnector.UCGetSQLDataset('Select Max('+TableUsers.FieldUserID+') as IdUser from ' + TableUsers.TableName) do
  begin
    Result := Fieldbyname('idUser').asInteger + 1;
    Close;
    Free;
  end;
  Key := Encrypt( IntToStr(Result)+Login+Password, EncryptKey );
  with TableUsers do
    DataConnector.UCExecSQL(Format('Insert into %s( %s, %s, %s, %s, %s, %s, %s, %s, %s) VALUES(%d, %s, %s, %s, %s, %s, %d, %s, %s)',
              [ TableName,
                FieldUserID, FieldUserName, FieldLogin, FieldPassword, FieldEmail, FieldPrivileged, FieldProfile, FieldTypeRec, FieldKey,
                Result, QuotedStr(Name), QuotedStr(Login), QuotedStr(Encrypt(Password, EncryptKey)),
                QuotedStr(Mail), BoolToStr(PrivUser), Profile, QuotedStr('U'), QuotedStr(Key)]));
  if Assigned(OnAddUser) then OnAddUser(Self, Login, Password, Name, Mail, Profile, Privuser);
end;

procedure TUserControl.ChangePassword(IDUser: Integer; NewPassword: String);
var
  FLogin, FSenha : String;
  Key : String;
begin
  inherited;
  with DataConnector.UCGetSQLDataset('Select '+TableUsers.FieldLogin+' as login, '+TableUsers.FieldPassword+
    ' as senha from ' + TableUsers.TableName+' where '+TableUsers.FieldUserID+' = '+ IntToStr(IdUser)) do
  begin
    FLogin := Fieldbyname('Login').asString;
    Key := Encrypt( IntToStr(IDUser)+FLogin+NewPassword, EncryptKey );
    FSenha := Decrypt(FieldByName('Senha').asString, EncryptKey);
    Close;
    Free;
  end;
  DataConnector.UCExecSQL('Update ' +  TableUsers.TableName + ' Set '+TableUsers.FieldPassword+' = '+
    QuotedStr(Encrypt(NewPassword, EncryptKey))+', '+TableUsers.FieldKey + ' = ' +QuotedStr(Key)+
    ' where '+TableUsers.FieldUserID+' = '+ IntToStr(IdUser));
  if Assigned(onChangePassword) then OnChangePassword(Self, IdUser, FLogin, FSenha, NewPassword);
end;

procedure TUserControl.ChangeUser(IDUser: Integer; Login, Name,
  Mail: String; Profile: Integer; PrivUser: Boolean);
var
  Key, Password : String;
begin
  with DataConnector.UCGetSQLDataset('Select ' + TableUsers.FieldPassword+
    ' as senha from ' + TableUsers.TableName+' where '+TableUsers.FieldUserID+' = '+ IntToStr(IdUser)) do
  begin
    Password := Decrypt(FieldByName('Senha').asString, EncryptKey);
    Close;
    Free;
  end;
  Key := Encrypt( IntToStr(IDUser)+Login+Password, EncryptKey );

  with TableUsers do
    DataConnector.UCExecSQL('Update ' +  TableName + ' Set '+
      FieldUserName + ' = '+ QuotedStr(Name)+', '+
      FieldLogin + ' = '+ QuotedStr(Login)+', '+
      FieldEmail + ' = '+ QuotedStr(Mail)+', '+
      FieldPrivileged + ' = '+ BooltoStr(PrivUser)+', '+
      FieldProfile + ' = '+ IntToStr(Profile)+  ', '+
      FieldKey + ' = ' + QuotedStr(Key) +
      ' where '+FieldUserID +' = '+ IntToStr(IdUser));
  if Assigned(OnChangeUser) then OnChangeUser(Self, IdUser, Login, Name, Mail, Profile, PrivUser);

end;

procedure IniSettings(DestSettings: TUserSettings);
var
  tmp : TBitmap;
begin
    with DestSettings.CommonMessages do
    begin
      if BlankPassword = '' then BlankPassword := Const_Men_SenhaDesabitada;
      if PasswordChanged = '' then PasswordChanged := Const_Men_SenhaAlterada;
      if InitialMessage.Text = '' then InitialMessage.Text := Const_Men_MsgInicial;
      if MaxLoginAttemptsError = '' then MaxLoginAttemptsError := Const_Men_MaxTentativas;
      if InvalidLogin = '' then InvalidLogin := Const_Men_LoginInvalido;
      if AutoLogonError = '' then AutoLogonError := Const_Men_AutoLogonError;
    end;
    with DestSettings.Login do
    begin
      if BtCancel = '' then BtCancel := Const_Log_BtCancelar;
      if BtOK = '' then BtOK := Const_Log_BtOK;
      if LabelPassword = '' then LabelPassword := Const_Log_LabelSenha;
      if LabelUser = '' then LabelUser := Const_Log_LabelUsuario;
      if WindowCaption = '' then WindowCaption := Const_Log_WindowCaption;

      Tmp := TBitmap.create;
      Tmp.LoadFromResourceName(HInstance, 'UCLOCKLOGIN');
      LeftImage.Assign(tmp);
      FreeAndNil(tmp);

    end;
    with DestSettings.UsersForm do
    begin
      if WindowCaption = '' then WindowCaption := Const_Cad_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Cad_LabelDescricao;
      if ColName = '' then ColName := Const_Cad_ColunaNome;
      if ColLogin = '' then ColLogin := Const_Cad_ColunaLogin;
      if ColEmail = '' then ColEmail := Const_Cad_ColunaEmail;
      if BtAdd = '' then BtAdd := Const_Cad_BtAdicionar;
      if BtChange = '' then BtChange := Const_Cad_BtAlterar;
      if BtDelete = '' then BtDelete := Const_Cad_BtExcluir;
      if BtRights = '' then BtRights := Const_Cad_BtPermissoes;
      if BtPassword = '' then BtPassword := Const_Cad_BtSenha;
      if BtClose = '' then BtClose := Const_Cad_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_Cad_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_Cad_ConfirmaDelete_WindowCaption; //added by fduenas

    end;
    with DestSettings.UsersProfile do
    begin
      if WindowCaption = '' then WindowCaption := Const_Prof_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Prof_LabelDescricao;
      if ColProfile = '' then ColProfile := Const_Prof_ColunaNome;
      if BtAdd = '' then BtAdd := Const_Prof_BtAdicionar;
      if BtChange = '' then BtChange := Const_Prof_BtAlterar;
      if BtDelete = '' then BtDelete := Const_Prof_BtExcluir;
      if BtRights = '' then BtRights := Const_Prof_BtPermissoes;    //BGM
      if BtClose = '' then BtClose := Const_Prof_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_Prof_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_Prof_ConfirmaDelete_WindowCaption; //added by fduenas
    end;
    with DestSettings.AddChangeUser do
    begin
      if WindowCaption = '' then WindowCaption := Const_Inc_WindowCaption;
      if LabelAdd = '' then LabelAdd := Const_Inc_LabelAdicionar;
      if LabelChange = '' then LabelChange := Const_Inc_LabelAlterar;
      if LabelName = '' then LabelName := Const_Inc_LabelNome;
      if LabelLogin = '' then LabelLogin := Const_Inc_LabelLogin;
      if LabelEmail = '' then LabelEmail := Const_Inc_LabelEmail;
      if LabelPerfil = '' then LabelPerfil := Const_Inc_LabelPerfil;
      if CheckPrivileged = '' then CheckPrivileged := Const_Inc_CheckPrivilegiado;
      if BtSave = '' then BtSave := Const_Inc_BtGravar;
      if BtCancel = '' then BtCancel := Const_Inc_BtCancelar;
    end;
    with DestSettings.AddChangeProfile do
    begin
      if WindowCaption = '' then WindowCaption := Const_PInc_WindowCaption;
      if LabelAdd = '' then LabelAdd := Const_PInc_LabelAdicionar;
      if LabelChange = '' then LabelChange := Const_PInc_LabelAlterar;
      if LabelName = '' then LabelName := Const_PInc_LabelNome;
      if BtSave = '' then BtSave := Const_PInc_BtGravar;
      if BtCancel = '' then BtCancel := Const_PInc_BtCancelar;
    end;
    with DestSettings.Rights do
    begin
      if WindowCaption = '' then WindowCaption := Const_Perm_WindowCaption;
      if LabelUser = '' then LabelUser := Const_Perm_LabelUsuario;
      if LabelProfile = '' then LabelProfile := Const_Perm_LabelPerfil;
      if PageMenu = '' then PageMenu := Const_Perm_PageMenu;
      if PageActions = '' then PageActions := Const_Perm_PageActions;
      if BtUnlock = '' then BtUnlock := Const_Perm_BtLibera;
      if BtLock = '' then BtLock := Const_Perm_BtBloqueia;
      if BtSave = '' then BtSave := Const_Perm_BtGravar;
      if BtCancel = '' then BtCancel := Const_Perm_BtCancelar;
    end;
    with DestSettings.ChangePassword do
    begin
      if WindowCaption = '' then WindowCaption := Const_Troc_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Troc_LabelDescricao;
      if LabelCurrentPassword = '' then LabelCurrentPassword := Const_Troc_LabelSenhaAtual;
      if LabelNewPassword = '' then LabelNewPassword := Const_Troc_LabelNovaSenha;
      if LabelConfirm = '' then LabelConfirm := Const_Troc_LabelConfirma;
      if BtSave = '' then BtSave := Const_Troc_BtGravar;
      if BtCancel = '' then BtCancel := Const_Troc_BtCancelar;
    end;
    with DestSettings.CommonMessages.ChangePasswordError do
    begin
      if InvalidCurrentPassword = '' then InvalidCurrentPassword :=  Const_ErrPass_SenhaAtualInvalida;
      if NewPasswordError = '' then NewPasswordError :=  Const_ErrPass_ErroNovaSenha;
      if NewEqualCurrent = '' then NewEqualCurrent :=  Const_ErrPass_NovaIgualAtual;
      if PasswordRequired = '' then PasswordRequired :=  Const_ErrPass_SenhaObrigatoria;
      if MinPasswordLength = '' then MinPasswordLength := Const_ErrPass_SenhaMinima;
      if InvalidNewPassword= '' then InvalidNewPassword :=  Const_ErrPass_SenhaInvalida;
    end;
    with DestSettings.ResetPassword do
    begin
      if WindowCaption = '' then WindowCaption := Const_DefPass_WindowCaption;
      if LabelPassword = '' then LabelPassword := Const_DefPass_LabelSenha;
    end;
    with DestSettings.Log do
    begin
      if WindowCaption = '' then WindowCaption := Const_LogC_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_LogC_LabelDescricao;
      if LabelUser = '' then LabelUser := Const_LogC_LabelUsuario;
      if LabelDate = '' then LabelDate := Const_LogC_LabelData;
      if LabelLevel = '' then LabelLevel := Const_LogC_LabelNivel;
      if ColLevel = '' then ColLevel := Const_LogC_ColunaNivel;
      if ColMessage = '' then ColMessage := Const_LogC_ColunaMensagem;
      if ColUser = '' then ColUser := Const_LogC_ColunaUsuario;
      if ColDate = '' then ColDate := Const_LogC_ColunaData;
      if BtFilter = '' then BtFilter := Const_LogC_BtFiltro;
      if BtDelete = '' then BtDelete := Const_LogC_BtExcluir;
      if BtClose = '' then BtClose := Const_LogC_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_LogC_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_LogC_ConfirmaDelete_WindowCaption; //added by fduenas
      if OptionUserAll = '' then OptionUserAll := Const_LogC_Todos; //added by fduenas
      if OptionLevelLow = '' then OptionLevelLow := Const_LogC_Low; //added by fduenas
      if OptionLevelNormal = '' then OptionLevelNormal := Const_LogC_Normal; //added by fduenas
      if OptionLevelHigh = '' then OptionLevelHigh := Const_LogC_High; //added by fduenas
      if OptionLevelCritic = '' then OptionLevelCritic := Const_LogC_Critic; //added by fduenas
      if DeletePerformed = '' then DeletePerformed := Const_LogC_ExcluirEfectuada; //added by fduenas
    end;
    with DestSettings.AppMessages do
    begin
      if MsgsForm_BtNew = '' then MsgsForm_BtNew := Const_Msgs_BtNew;
      if MsgsForm_BtReplay = '' then MsgsForm_BtReplay := Const_Msgs_BtReplay;
      if MsgsForm_BtForward = '' then MsgsForm_BtForward := Const_Msgs_BtForward;
      if MsgsForm_BtDelete = '' then MsgsForm_BtDelete := Const_Msgs_BtDelete;
      if MsgsForm_BtClose = '' then MsgsForm_BtDelete := Const_Msgs_BtClose; //added by fduenas
      if MsgsForm_WindowCaption = '' then MsgsForm_WindowCaption := Const_Msgs_WindowCaption;
      if MsgsForm_ColFrom = '' then  MsgsForm_ColFrom := Const_Msgs_ColFrom;
      if MsgsForm_ColSubject = '' then  MsgsForm_ColSubject := Const_Msgs_ColSubject;
      if MsgsForm_ColDate = '' then MsgsForm_ColDate := Const_Msgs_ColDate;
      if MsgsForm_PromptDelete = '' then  MsgsForm_PromptDelete := Const_Msgs_PromptDelete;
      if MsgsForm_PromptDelete_WindowCaption = '' then  MsgsForm_PromptDelete_WindowCaption := Const_Msgs_PromptDelete_WindowCaption;
      if MsgsForm_NoMessagesSelected = '' then  MsgsForm_NoMessagesSelected := Const_Msgs_NoMessagesSelected;
      if MsgsForm_NoMessagesSelected_WindowCaption = '' then  MsgsForm_NoMessagesSelected_WindowCaption := Const_Msgs_NoMessagesSelected_WindowCaption;

      if MsgRec_BtClose = '' then  MsgRec_BtClose := Const_MsgRec_BtClose;
      if MsgRec_WindowCaption = '' then MsgRec_WindowCaption := Const_MsgRec_WindowCaption;
      if MsgRec_Title = ''then MsgRec_Title := Const_MsgRec_Title;
      if MsgRec_LabelFrom = ''then MsgRec_LabelFrom := Const_MsgRec_LabelFrom;
      if MsgRec_LabelDate = '' then MsgRec_LabelDate := Const_MsgRec_LabelDate;
      if MsgRec_LabelSubject = '' then MsgRec_LabelSubject := Const_MsgRec_LabelSubject;
      if MsgRec_LabelMessage = '' then MsgRec_LabelMessage := Const_MsgRec_LabelMessage;

      if MsgSend_BtSend =  '' then MsgSend_BtSend := Const_MsgSend_BtSend;
      if MsgSend_BtCancel = '' then MsgSend_BtCancel := Const_MsgSend_BtCancel;
      if MsgSend_WindowCaption = '' then MsgSend_WindowCaption := Const_MsgSend_WindowCaption;
      if MsgSend_Title = '' then MsgSend_Title := Const_MsgSend_Title;
      if MsgSend_GroupTo = '' then MsgSend_GroupTo := Const_MsgSend_GroupTo;
      if MsgSend_RadioUser = '' then MsgSend_RadioUser := Const_MsgSend_RadioUser;
      if MsgSend_RadioAll = '' then MsgSend_RadioAll := Const_MsgSend_RadioAll;
      if MsgSend_GroupMessage = '' then MsgSend_GroupMessage := Const_MsgSend_GroupMessage;
      if MsgSend_LabelSubject = '' then MsgSend_LabelSubject := Const_MsgSend_LabelSubject; //added by fduenas
      if MsgSend_LabelMessageText = '' then MsgSend_LabelMessageText := Const_MsgSend_LabelMessageText; //added by fduenas
    end;
   //c DestSettings.WindowsPosition := poMainFormCenter;
end;


procedure TUserControl.CriaTabelaMsgs(const TableName : String);
begin
  DataConnector.UCExecSQL('Create Table '+ TableName + ' ( '+
                         'IdMsg int ,'+
                         'UsrFrom int, '+
                         'UsrTo int, '+
                         'Subject Varchar(50),'+
                         'Msg Varchar(255),'+
                         'DtSend Varchar(12),'+
                         'DtReceive Varchar(12) )');
end;

destructor TUserControl.Destroy;
begin
  //Free method changes to FreeAndNil function
  //modified by fduenas
  FRightItems.Free;
  FreeAndNil(FUser);
  ControlRight.Free;
  Login.free;
  LogControl.Free ;
  UsersForm.Free ;
  UsersProfile.Free;
  ChangePasswordForm.Free;
  FUserSettings.Free;
  FNaoPermitidos.Free;
  UCControlList.Free;
  LoginMonitorList.Free;
  // QmD 19/04/2005
  FreeAndNil(FTableUsers);
  FreeAndNil(FTableRights);
  inherited Destroy;
end;

procedure TUserControl.SetItems(Value: TUCCollection);
begin

end;

procedure TUserControl.HideField(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  Text := '(Campo Bloqueado)';
end;

procedure TUserControl.StartLogin;
begin
  CurrentUser.UserID := 0;
  ShowLogin;
  ApplyRights;
end;

procedure TUserControl.Execute;
begin
//    if not UCFindDataConnection then raise Exception.Create(Format(msgExceptConnection,[name]));
  if Assigned(FThUCRun) then FThUCRun.Terminate;
  try
    if not DataConnector.UCFindTable(FTableRights.TableName) then CriaTableRights;
    if not DataConnector.UCFindTable(FTableRights.TableName+'EX') then CriaTableRights(True); //extra rights table
    if LogControl.Active then
      if not DataConnector.UCFindTable(LogControl.TableLog) then CriaTableLog;

    CriaTabelaUsuarios(DataConnector.UCFindTable(FTableUsers.TableName));

    // testa campo KEY qmd 28-02-2005
    if FTryKeyField then DoCheckValidationField;
  finally
    if LoginMode = lmActive then
      if not Login.AutoLogon.Active then ShowLogin else TryAutoLogon;
    ApplyRights;
  end;
end;

procedure TUserControl.DoCheckValidationField;
var
  TempDS : TDataset;
  Key, Login, Senha : String;
  UserID : Integer;
begin
  //verifica tabela de usuarios
  TempDS := DataConnector.UCGetSQLDataset('SELECT * FROM '+TableUsers.TableName);
  if TempDS.FindField(TableUsers.FieldKey) = nil then
  begin
    DataConnector.UCExecSQL('ALTER TABLE ' + TableUsers.TableName + ' ADD ' +
       TableUsers.FieldKey + ' VARCHAR(255)');
    TempDS.First;
    with TempDS do
    begin
      while not Eof do
      begin
        UserID := TempDS.FieldByName(TableUsers.FieldUserID).AsInteger;
        Login := TempDS.FieldByName(TableUsers.FieldLogin).AsString;
        Senha := Decrypt(TempDS.FieldByName(TableUsers.FieldPassword).AsString, EncryptKey);
        Key := Encrypt( IntToStr(UserID)+ Login +Senha, EncryptKey );
        DataConnector.UCExecSQL(Format('UPDATE %s SET %s = %s where %s = %d', [ TableUsers.TableName,
           TableUsers.FieldKey, QuotedStr(Key),
           TableUsers.FieldUserID, TempDS.FieldByName(TableUsers.FieldUserID).AsInteger]));
        Next;
      end;
    end;
  end;
  TempDS.Close;
  FreeAndNil(TempDS);

  //verifica tabela de permissoes
  TempDS := DataConnector.UCGetSQLDataset('SELECT * FROM '+TableRights.TableName);
  if TempDS.FindField(TableRights.FieldKey) = nil then
  begin
    DataConnector.UCExecSQL('ALTER TABLE ' + TableRights.TableName + ' ADD ' +
       TableUsers.FieldKey + ' VARCHAR(255)');
    TempDS.First;
    with TempDS do
    begin
      while not Eof do
      begin
        UserID := TempDS.FieldByName(TableRights.FieldUserID).AsInteger;
        Login := TempDS.FieldByName(TableRights.FieldComponentName).AsString;
        Key := Encrypt(IntToStr(UserID) + Login, EncryptKey);
        DataConnector.UCExecSQL(Format('UPDATE %s SET %s = %s where %s = %d and %s = %s and %s = %s', [ TableRights.TableName,
           TableRights.FieldKey, QuotedStr(Key),
           TableRights.FieldUserID, TempDS.FieldByName(TableRights.FieldUserID).AsInteger,
           TableRights.FieldModule, QuotedStr(ApplicationID),
           TableRights.FieldComponentName, QuotedStr(Login)]));
        Next;
      end;
    end;
  end;
  TempDS.Close;
  FreeAndNil(TempDS);

  //verifica tabela de permissoes extendidas
  TempDS := DataConnector.UCGetSQLDataset('SELECT * FROM '+TableRights.TableName+'EX');
  if TempDS.FindField(TableRights.FieldKey) = nil then
  begin
    DataConnector.UCExecSQL('ALTER TABLE ' + TableRights.TableName + 'EX ADD ' +
       TableUsers.FieldKey + ' VARCHAR(255)');
    TempDS.First;
    with TempDS do
    begin
      while not Eof do
      begin
        UserID := TempDS.FieldByName(TableRights.FieldUserID).AsInteger;
        Login := TempDS.FieldByName(TableRights.FieldComponentName).AsString; //componentname
        senha := TempDS.FieldByName(TableRights.FieldFormName).AsString; // formname
        Key := Encrypt(IntToStr(UserID) + Login, EncryptKey);
        DataConnector.UCExecSQL(Format('UPDATE %s SET %s = %s where %s = %d and %s = %s and %s = %s and %s = %s', [ TableRights.TableName + 'EX',
           TableRights.FieldKey, QuotedStr(Key),
           TableRights.FieldUserID, TempDS.FieldByName(TableRights.FieldUserID).AsInteger,
           TableRights.FieldModule, QuotedStr(ApplicationID),
           TableRights.FieldComponentName, QuotedStr(Login), // componente name
           TableRights.FieldFormName, QuotedStr(Senha) ])); // formname
        Next;
      end;
    end;
  end;
  TempDS.Close;
  FreeAndNil(TempDS);


end;

procedure TUserControl.ActionBtPermissDefault;
var
  TempCampos, TempCamposEX : String;
begin
  UserPermis.TempIdUser := TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('IdUser').asInteger;

  TempCampos := Format(' %s as IdUser, %s as Modulo, %s as ObjName, %s as UCKey ', [TableRights.FieldUserID, TableRights.FieldModule, TableRights.FieldComponentName, TableRights.FieldKey]);
  TempCamposEX := Format('%s, %s as FormName ',[TempCampos, TableRights.FieldFormName]);

  UserPermis.DSPermiss := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab Where tab.%s = %s and tab.%s = %s',
                          [TempCampos, TableRights.TableName, TableRights.FieldUserID, TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('IdUser').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPermiss.Open;

  UserPermis.DSPermissEX := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab1 Where tab1.%s = %s and tab1.%s = %s',
                          [TempCamposEX, TableRights.TableName + 'EX', TableRights.FieldUserID, TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('IdUser').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPermissEX.Open;

  UserPermis.DSPerfil := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab Where tab.%s = %s and tab.%s = %s',
                          [TempCampos, TableRights.TableName, TableRights.FieldUserID, TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('Perfil').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPerfil.Open;

  UserPermis.DSPerfilEX := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab1 Where tab1.%s = %s and tab1.%s = %s',
                          [TempCamposEX, TableRights.TableName + 'EX', TableRights.FieldUserID, TCadUser(FormCadastroUsuarios).DSCadUser.FieldByName('Perfil').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPerfilEX.Open;

  UserPermis.ShowModal;


  TCadUser(FormCadastroUsuarios).DSCadUser.Close;
  TCadUser(FormCadastroUsuarios).DSCadUser.Open;

  TCadUser(FormCadastroUsuarios).DSCadUser.Locate('idUser', UserPermis.TempIdUser,[]);

  FreeAndNil(UserPermis);
end;

procedure TUserControl.ActionBtPermissProfileDefault;
var
  TempCampos, TempCamposEX : String;
begin
  UserPermis.TempIdUser := TCadPerfil(FormPerfilUsuarios).DSPerfilUser.FieldByName('IdUser').asInteger;

  TempCampos := Format(' %s as IdUser, %s as Modulo, %s as ObjName, %s as UCKey ', [TableRights.FieldUserID, TableRights.FieldModule, TableRights.FieldComponentName, TableRights.FieldKey]);
  TempCamposEX := Format('%s, %s as FormName ',[TempCampos, TableRights.FieldFormName]);

  UserPermis.DSPermiss := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab Where tab.%s = %s and tab.%s = %s',
                          [TempCampos, TableRights.TableName, TableRights.FieldUserID ,TCadPerfil(FormPerfilUsuarios).DSPerfilUser.FieldByName('IdUser').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPermiss.Open;

  UserPermis.DSPermissEX := DataConnector.UCGetSQLDataset(Format('Select %s from %s tab1 Where tab1.%s = %s and tab1.%s = %s',
                          [TempCamposEX, TableRights.TableName + 'EX', TableRights.FieldUserID, TCadPerfil(FormPerfilUsuarios).DSPerfilUser.FieldByName('IdUser').asString, TableRights.FieldModule, QuotedStr(ApplicationID)]) );
  UserPermis.DSPermissEX.Open;

  UserPermis.DSPerfil := TDataset.Create(nil);

  UserPermis.ShowModal;

  TCadPerfil(FormPerfilUsuarios).DSPerfilUser.Close;
  TCadPerfil(FormPerfilUsuarios).DSPerfilUser.Open;
  TCadPerfil(FormPerfilUsuarios).DSPerfilUser.Locate('idUser', UserPermis.TempIdUser,[]);
  FreeAndNil(UserPermis);
end;

procedure TUserControl.ShowChangePassword;
begin
  ActionTrocaSenha(self);
end;

procedure TUserControl.ShowLogManager;
begin
  ActionLog(Self);
end;

procedure TUserControl.ShowProfileManager;
begin
  ActionUserProfile(self);
end;

procedure TUserControl.ShowUserManager;
begin
  ActionCadUser(self);
end;

procedure TUserControl.AddUCControlMonitor(UCControl: TUCControls);
begin
  UCControlList.Add(UCControl);
end;

procedure TUserControl.ApplyRightsUCControlMonitor;
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(UCControlList.Count) do
    TUCControls(UCControlList.Items[Contador]).ApplyRights;
end;

procedure TUserControl.DeleteUCControlMonitor(UCControl: TUCControls);
var
  Contador : Integer;
  SLControls : TStringList;
begin
  if not Assigned(UCControlList) then Exit;
  SLControls := TStringList.Create;
  for Contador := 0 to Pred(UCControlList.Count) do
    if TUCControls(UCControlList.Items[Contador]) = UCControl then
      SLControls.Add(IntToStr(Contador));

  for Contador := 0 to Pred(SLControls.Count) do
    UCControlList.Delete(StrToInt(SLControls[Contador]));

end;

procedure TUserControl.LockControlsUCControlMonitor;
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(UCControlList.Count) do
   TUCControls(UCControlList.Items[Contador]).LockControls;
end;

procedure TUserControl.SetUCDataConn(const Value: TUCDataConn);
begin
  FUCDataConn := Value;
  if Assigned(Value) then Value.FreeNotification(Self);
end;

procedure TUserControl.AddLoginMonitor(UCAppMessage: TUCAppMessage);
begin
  LoginMonitorList.Add(UCAppMessage);
end;

procedure TUserControl.DeleteLoginMonitor(UCAppMessage: TUCAppMessage);
var
  Contador : Integer;
  SLControls : TStringList;
begin
  SLControls := TStringList.Create;
  if Assigned(LoginMonitorList) then
    for Contador := 0 to Pred(LoginMonitorList.Count) do
      if TUCAppMessage(LoginMonitorList.Items[Contador]) = UCAppMessage then
        SLControls.Add(IntToStr(Contador));
  if assigned(SLControls) then
    for Contador := 0 to Pred(SLControls.Count) do
      LoginMonitorList.Delete(StrToInt(SLControls[Contador]));
end;

procedure TUserControl.NotificationLoginMonitor;
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(LoginMonitorList.Count) do
    TUCAppMessage(LoginMonitorList.Items[Contador]).CheckMessages;
end;

{ TUCAutoLogin }

procedure TUCAutoLogin.Assign(Source: TPersistent);
begin
  if Source is TUCAutoLogin then
  begin
    Self.Active := TUCAutoLogin(Source).Active;
    Self.User := TUCAutoLogin(Source).User;
    Self.Password := TUCAutoLogin(Source).Password;
  end else inherited;
end;

constructor TUCAutoLogin.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TUCAutoLogin.Destroy;
begin
  inherited;
end;

{ TNaoPermitidos }

procedure TNaoPermitidos.Assign(Source: TPersistent);
begin
  if Source is TNaoPermitidos then
  begin
    Self.MenuVisible := TNaoPermitidos(Source).MenuVisible;
    Self.ActionVisible := TNaoPermitidos(Source).FMenuVisible;
  end else inherited;
end;

constructor TNaoPermitidos.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TNaoPermitidos.Destroy;
begin
  inherited;
end;

{ TLogControl }

procedure TLogControl.Assign(Source: TPersistent);
begin
  if Source is TLogControl then
  begin
    Self.Active := TLogControl(Source).Active;
    Self.TableLog := TLogControl(Source).TableLog;
    Self.MenuItem := TLogControl(Source).MenuItem;
    Self.Action := TLogControl(Source).Action;
  end else inherited;
end;

constructor TLogControl.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TLogControl.Destroy;
begin
  inherited;
end;

procedure TLogControl.SetFActLog(const Value: TAction);
begin
  FActLog := Value;
  if Value <> nil then Value.FreeNotification(Self.Action);
end;

procedure TLogControl.SetFMenuLog(const Value: TMenuItem);
begin
  FMenuLog := Value;
  if Value <> nil then Value.FreeNotification(Self.MenuItem);
end;


procedure TUserControl.ShowLogin;
begin
  FRetry := 0;
  if Assigned(onCustomLoginForm) then OnCustomLoginForm(Self, FormLogin);
  if FormLogin = nil then
  begin
    FormLogin := TLoginWindow.Create(self);
    with FormLogin as TLoginWindow do
    begin
      SetLoginWindow(TLoginWindow(FormLogin));
      btOK.onClick := ActionOKLogin;
      onCloseQuery := Testafecha;
  {$IFDEF VER130}
  {$ELSE}
      lbEsqueci.OnClick := ActionEsqueceuSenha;
  {$ENDIF}
    end;
  end;
  FormLogin.ShowModal;
  FreeAndNil(FormLogin);
end;

procedure TUserControl.ActionOKLogin(Sender: TObject);
var
  TempUser, TempPassword : String;
begin
  TempUser := TLoginWindow(FormLogin).EditUsuario.Text;
  TempPassword := TLoginWindow(FormLogin).EditSenha.Text;
  if Assigned(OnLogin) then Onlogin(Self, TempUser, TempPassword);
  if VerificaLogin(TempUser, TempPassword) then TLoginWindow(FormLogin).Close
  else
  begin
    MessageDlg(Settings.CommonMessages.InvalidLogin, mtWarning, [mbOK], 0);
    Inc(FRetry);
    if (Login.MaxLoginAttempts > 0) and ( FRetry = Login.MaxLoginAttempts) then
    begin
      MessageDlg(Format(Settings.CommonMessages.MaxLoginAttemptsError,[Login.MaxLoginAttempts]), mtError, [mbOK], 0);
      halt;
    end;
  end;
end;

procedure TUserControl.TestaFecha(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (CurrentUser.UserID > 0);
end;


procedure TUserControl.ApplyRights;
var
  TempDS : TDataset;
begin
  // Aplica Permissoes do Usuario logado
  TempDS := DataConnector.UCGetSQLDataset('Select '+TableRights.FieldComponentName+' as ObjName, '+
                        TableRights.FieldKey + ' as UCKey, ' + TableRights.FieldUserID + ' as UserID '+
                        ' from '+ TableRights.TableName +  ' Where '+TableRights.FieldUserID+' = ' +
                        IntToStr(CurrentUser.UserID)+ ' And '+TableRights.FieldModule+' = ' + QuotedStr(ApplicationID));
  ApplyRightsObj(TempDS);
  TempDS.Close;


  // Aplica Permissoes do Perfil do usuario
  if CurrentUser.Profile > 0 then
  begin
    TempDS := DataConnector.UCGetSQLDataset('Select '+TableRights.FieldComponentName+' as ObjName, ' +
    TableRights.FieldKey + ' as UCKey, ' + TableRights.FieldUserID + ' as UserID '+
                          ' from '+ TableRights.TableName +  ' Where '+TableRights.FieldUserID+' = ' +
                          IntToStr(CurrentUser.Profile)+ ' And '+TableRights.FieldModule+' = ' + QuotedStr(ApplicationID));
    ApplyRightsObj(TempDS, True);
    TempDS.Close;
  end;
  FreeAndNil(TempDS);
  if Assigned(FAfterLogin) then FAfterLogin(Self);
end;

procedure TUserControl.ApplyRightsObj( FDataset : TDataset; FProfile : Boolean = False);
var
  Contador : integer;
  Encontrado : Boolean;
  Key, Temp : String;
  ObjAct : TObject;
  OwnerMenu : TComponent;
begin
  //Permissao de Menus   QMD
  if Assigned(ControlRight.MainMenu) then
  begin
    OwnerMenu := ControlRight.MainMenu.Owner;
    for Contador := 0 to Pred(OwnerMenu.ComponentCount ) do //qmd  -1 removido em 29/11/2004
    begin
      if (OwnerMenu.Components[Contador].ClassType = TMenuItem) and (TMenuItem(OwnerMenu.Components[Contador]).GetParentMenu = ControlRight.MainMenu) then
      begin
        if not FProfile then
        begin
          Encontrado := FDataset.Locate('ObjName', OwnerMenu.Components[Contador].Name,[]);
          //verifica key
          if Encontrado then
          begin
            Key := Decrypt(FDataset.FieldByName('UCKey').asString, EncryptKey);
            Encontrado := (Key = FDataset.FieldByName('UserID').asString + FDataset.FieldByName('ObjName').asString);
          end;
          TMenuItem(OwnerMenu.Components[Contador]).Enabled := Encontrado;
          if not Encontrado then TMenuItem(OwnerMenu.Components[Contador]).Visible := NotAllowedItems.MenuVisible
          else TMenuItem(OwnerMenu.Components[Contador]).Visible := True;
        end else
        begin
          if FDataset.Locate('ObjName', OwnerMenu.Components[Contador].Name,[]) then
          begin
            //verifica key
            if (Decrypt(FDataset.FieldByName('UCKey').asString, EncryptKey) = FDataset.FieldByName('UserID').asString + FDataset.FieldByName('ObjName').asString) then
            begin
              TMenuItem(OwnerMenu.Components[Contador]).Enabled := True;
              TMenuItem(OwnerMenu.Components[Contador]).Visible := True;
            end;
          end;
        end;
        if Assigned(OnApplyRightsMenuIt) then OnApplyRightsMenuIt(Self, TMenuItem(OwnerMenu.Components[Contador]));
      end;
    end;
  end;

  //Permissao de Actions
  if (Assigned(ControlRight.ActionList) ) {$IFDEF UCACTMANAGER}or (Assigned(ControlRight.ActionManager)) or (Assigned(ControlRight.ActionMainMenuBar)){$ENDIF} then
  begin
    if Assigned(ControlRight.ActionList) then ObjAct := ControlRight.ActionList {$IFDEF UCACTMANAGER}else ObjAct := ControlRight.ActionManager{$ENDIF};
    for contador := 0 to TActionList(ObjAct).ActionCount -1 do
    begin
      if not FProfile then
      begin
        Encontrado := FDataset.Locate('ObjName', TAction(TActionList(ObjAct).Actions[contador]).Name ,[]);
        //verifica key
        if Encontrado then
          Encontrado := (Decrypt(FDataset.FieldByName('UCKey').asString, EncryptKey) = FDataset.FieldByName('UserID').asString + FDataset.FieldByName('ObjName').asString);

        TAction(TActionList(ObjAct).Actions[contador]).Enabled := Encontrado;
        if not Encontrado then TAction(TActionList(ObjAct).Actions[contador]).Visible := NotAllowedItems.ActionVisible
        else TAction(TActionList(ObjAct).Actions[contador]).Visible := True;
      end else begin
        if FDataset.Locate('ObjName', TAction(TActionList(ObjAct).Actions[contador]).Name ,[]) then
        begin
          //verifica key
          if (Decrypt(FDataset.FieldByName('UCKey').asString, EncryptKey) = FDataset.FieldByName('UserID').asString + FDataset.FieldByName('ObjName').asString) then
          begin
            TAction(TActionList(ObjAct).Actions[contador]).Enabled := True;
            TAction(TActionList(ObjAct).Actions[contador]).Visible := True;
          end;
        end;
      end;
      if Assigned(OnApplyRightsActionIt) then OnApplyRightsActionIt(Self, TAction(TActionList(ObjAct).Actions[contador]));
    end;
  end;
  {$IFDEF UCACTMANAGER}
  if Assigned(ControlRight.ActionMainMenuBar) then
  begin
    for Contador := 0 to ControlRight.ActionMainMenuBar.ActionClient.Items.Count-1 do
    begin
      Temp := IntToStr(Contador);
      if ControlRight.ActionMainMenuBar.ActionClient.Items[StrToInt(Temp)].Items.Count > 0 then
      begin
        ControlRight.ActionMainMenuBar.ActionClient.Items[StrToInt(Temp)].Visible :=
          (FDataset.Locate('ObjName',#1+'G'+ControlRight.ActionMainMenuBar.ActionClient.Items[StrToInt(Temp)].Caption,[])) and
          (Decrypt(FDataset.FieldByName('UCKey').asString, EncryptKey) = FDataset.FieldByName('UserID').asString + FDataset.FieldByName('ObjName').asString);
        TrataActMenuBarIt(ControlRight.ActionMainMenuBar.ActionClient.Items[StrToInt(Temp)], FDataset);
      end;
    end;
  end;
  {$ENDIF}
end;


procedure TUserControl.UnlockEX( FormObj : TCustomForm; ObjName : String);
begin
  if FormObj.FindComponent(ObjName) = nil then Exit;
  if FormObj.FindComponent(ObjName) is TControl then
  begin
    TControl(FormObj.FindComponent(ObjName)).Enabled := True;
    TControl(FormObj.FindComponent(ObjName)).Visible := True;
  end;

  if FormObj.FindComponent(ObjName) is TMenuItem then // tmenuitem
  begin
    TMenuItem(FormObj.FindComponent(ObjName)).Enabled := True;
    TMenuItem(FormObj.FindComponent(ObjName)).Visible := True;
    //chama evento OnApplyRightsMenuIt
    if Assigned(OnApplyRightsMenuIt) then OnApplyRightsMenuIt(self, FormObj.FindComponent(ObjName) as TMenuItem);
  end;

  if FormObj.FindComponent(ObjName) is TAction then // tmenuitem
  begin
    TAction(FormObj.FindComponent(ObjName)).Enabled := True;
    TAction(FormObj.FindComponent(ObjName)).Visible := True;
    //chama evento OnApplyRightsMenuIt
    if Assigned(OnApplyRightsActionIt) then OnApplyRightsActionIt(self, FormObj.FindComponent(ObjName) as TAction);
  end;

  if FormObj.FindComponent(ObjName) is TField then // Tfield
  begin
    TField(FormObj.FindComponent(ObjName)).ReadOnly := False;
    TField(FormObj.FindComponent(ObjName)).Visible := True;
    TField(FormObj.FindComponent(ObjName)).onGetText := nil;
  end;
end;


procedure TUserControl.LockEX( FormObj : TCustomForm; ObjName : String; naInvisible : Boolean);
begin
  if FormObj.FindComponent(ObjName) = nil then Exit;
  if FormObj.FindComponent(ObjName) is TControl then
  begin
    TControl(FormObj.FindComponent(ObjName)).Enabled := False;
    TControl(FormObj.FindComponent(ObjName)).Visible := not naInvisible; //qmd
  end;

  if FormObj.FindComponent(ObjName) is TMenuItem then // tmenuitem
  begin
    TMenuItem(FormObj.FindComponent(ObjName)).Enabled := False;
    TMenuItem(FormObj.FindComponent(ObjName)).Visible := not naInvisible; //qmd
    //chama evento OnApplyRightsMenuIt
    if Assigned(OnApplyRightsMenuIt) then OnApplyRightsMenuIt(self, FormObj.FindComponent(ObjName) as TMenuItem);
  end;

  if FormObj.FindComponent(ObjName) is TAction then // tmenuitem
  begin
    TAction(FormObj.FindComponent(ObjName)).Enabled := False;
    TAction(FormObj.FindComponent(ObjName)).Visible := not naInvisible; //qmd
    //chama evento OnApplyRightsMenuIt
    if Assigned(OnApplyRightsActionIt) then OnApplyRightsActionIt(self, FormObj.FindComponent(ObjName) as TAction);
  end;

  if FormObj.FindComponent(ObjName) is TField then // Tfield
  begin
    TField(FormObj.FindComponent(ObjName)).ReadOnly := True;
    TField(FormObj.FindComponent(ObjName)).Visible := not naInvisible; //qmd
    TField(FormObj.FindComponent(ObjName)).onGetText := HideField;
  end;
end;

{$IFDEF UCACTMANAGER}
procedure TUserControl.TrataActMenuBarIt(IT : TActionClientItem; FDataset : TDataset);
var
  Contador : integer;
begin
  for contador := 0 to IT.Items.Count -1 do
    if IT.Items[Contador].Caption <> '-' then
      if IT.Items[Contador].Items.Count > 0 then
      begin
        IT.Items[Contador].Visible := (FDataset.Locate('ObjName',#1+'G'+IT.Items[Contador].Caption,[]));
        TrataActMenuBarIt(IT.Items[Contador], FDataset);
      end;
end;
{$ENDIF}
procedure TUserControl.CriaTableRights(ExtraRights : Boolean = False);
begin
  with TableRights do
  begin
    if not ExtraRights then
      DataConnector.UCExecSQL(Format('Create Table %s( %s int, %s varchar(50), %s varchar(50), %s varchar(255) )',
                [TableName, FieldUserID, FieldModule, FieldComponentName, FieldKey]) )
    else
      DataConnector.UCExecSQL(Format('Create Table %sEX( %s int, %s varchar(50), %s varchar(50), %s varchar(50), %s varchar(255) )',
                [TableName, FieldUserID, FieldModule, FieldComponentName, FieldFormName, FieldKey]) );
  end;
end;

procedure TUserControl.AddRightEX( idUser : Integer; Module, FormName, ObjName : String);
var
  Key : String;
begin
  Key := Encrypt(IntToStr(idUser) + ObjName, EncryptKey);
  with TableRights do
    DataConnector.UCExecSQL(Format('INSERT INTO %sEX( %s, %s, %s, %s, %s) VALUES (%d, %s, %s, %s, %s)',
                                               [ TableName, FieldUserID, FieldModule, FieldFormName, FieldComponentName, FieldKey,
                                                 IdUser, QuotedStr(Module), QuotedStr(FormName), QuotedStr(ObjName), QuotedStr(Key)]));
end;

procedure TUserControl.AddRight(idUser : Integer; ItemRight : String);
var
  Key : String;
begin
  if ItemRight = '' then Exit;

  Key := Encrypt(IntToStr(idUser) + ItemRight, EncryptKey);
  DataConnector.UCExecSQL(Format('Insert into %s( %s, %s, %s, %s) Values( %d, %s, %s, %s)',
              [TableRights.TableName, TableRights.FieldUserID, TableRights.FieldModule, TableRights.FieldComponentName, TableRights.FieldKey,
               idUser, QuotedStr(ApplicationID), QuotedStr(ItemRight), QuotedStr(Key)]));
end;


procedure TUserControl.AddRight(idUser : Integer; ItemRight : TObject; FullPath : Boolean = True);
var
  Obj : TObject;
begin
  if ItemRight = nil then Exit;
  Obj := ItemRight;

  if Obj.ClassType = TMenuItem then
  begin
    While Assigned(Obj) and (Obj.ClassType = TMenuItem) and (TComponent(Obj).Name <> '') do
    begin
      AddRight(idUser, TComponent(Obj).Name);
      if FullPath then Obj := TMenuItem(Obj).Parent
      else Obj := nil;
    end;
  end
  else
    AddRight(idUser, TComponent(Obj).Name);
end;

procedure TUserControl.CriaTableLog;
begin
  DataConnector.UCExecSQL('Create Table '+ LogControl.TableLog + ' ( '+
                         'IdUser int ,'+
                         'MSG varchar(250), '+
                         'Data varchar(14), '+
                         'Nivel Int)');
end;

{$IFDEF UCACTMANAGER}
procedure TUserControl.IncPermissActMenuBar( idUser : Integer; Act : TAction);
var
  Temp : TActionClientItem;
begin
  if Act = nil then exit;

  Temp := ControlRight.ActionMainMenuBar.ActionManager.FindItemByAction(Act);
  while Temp <> nil do
  begin
    AddRight(idUser, #1+'G'+Temp.Caption);
    Temp := TActionClientItem(TActionClientItem(Temp).ParentItem);
  end;
end;
{$ENDIF}

procedure TUserControl.CriaTabelaUsuarios(TableExists : Boolean);
var
  Contador, FIdUser : integer;
  FCustomform : TCustomForm;
  FMsg : TStrings;
  DSUser, DSPerm : TDataSet;
begin
  if not TableExists then
    with TableUsers do
      DataConnector.UCExecSQL(Format('Create Table %s( %s int, %s varchar(30), %s varchar(30), %s varchar(30), %s varchar(150), %s int, %s char(1), %s int, %s varchar(255) )',
              [TableName, FieldUserID, FieldUserName, FieldLogin, FieldPassword, FieldEmail, FieldPrivileged, FieldTypeRec, FieldProfile, FieldKey]) );

  DSUser := DataConnector.UCGetSQLDataset('Select '+TableUsers.FieldUserID+' as idUser from '+ TableUsers.TableName +
            ' where '+TableUsers.FieldLogin+' = '+ QuotedStr(Login.InitialLogin.User));
  if DSUser.IsEmpty then
    FIDUser := AddUser(Login.InitialLogin.User,Login.InitialLogin.Password, Login.InitialLogin.User, Login.InitialLogin.Email, 0, True)
  else FIDUser := DSUser.FieldByName('idUser').asInteger;
  DSUser.Close;
  FreeAndNil(DSUser);
  DSPerm := DataConnector.UCGetSQLDataset('Select '+TableRights.FieldUserID+' as iduser from '+
    TableRights.TableName + ' where '+TableRights.FieldUserID+' = '+ IntToStr(FIDUser)+ ' and '+TableRights.FieldModule+' = '+QuotedStr(ApplicationID));
  if not DSPerm.IsEmpty  then
  begin
      DSPerm.Close;
      FreeAndNil(DSPerm);
      Exit; //login!
  end;
  DSPerm.Close;
  FreeAndNil(DSPerm);

  AddRight(FIDUser, UsersForm.MenuItem);
  AddRight(FIDUser, UsersForm.Action);
  AddRight(FIDUser, UsersProfile.MenuItem);
  AddRight(FIDUser, UsersProfile.Action);

  AddRight(FIDUser, ChangePasswordForm.MenuItem);
  AddRight(FIDUser, ChangePasswordForm.Action);

  {$IFDEF UCACTMANAGER}
  if Assigned(ControlRight.ActionMainMenuBar) then IncPermissActMenuBar(FIDUser, UsersForm.Action);
  if Assigned(ControlRight.ActionMainMenuBar) then IncPermissActMenuBar(FIDUser, UsersProfile.Action);
  if Assigned(ControlRight.ActionMainMenuBar) then IncPermissActMenuBar(FIDUser, ChangePasswordForm.Action);
  {$ENDIF}
  if LogControl.Active then
  begin
    AddRight(FIDUser, LogControl.MenuItem);
    AddRight(FIDUser, LogControl.Action);
    {$IFDEF UCACTMANAGER}
    if Assigned(ControlRight.ActionMainMenuBar) then IncPermissActMenuBar(FIDUser, LogControl.Action);
    {$ENDIF}
  end;

  for contador := 0 to Pred(Login.InitialLogin.InitialRights.Count) do
    if Owner.FindComponent(Login.InitialLogin.InitialRights[contador]) <> nil then
    begin
      AddRight( FIDUser, Owner.FindComponent(Login.InitialLogin.InitialRights[contador]));
      AddRightEX( FIDUser, ApplicationID, TcustomForm(Owner).name, Login.InitialLogin.InitialRights[contador]);
    end;

  FMsg := TStringList.Create;
  FMsg.Assign(Settings.CommonMessages.InitialMessage);
  FMsg.Text := StringReplace(FMsg.Text,':user', Login.InitialLogin.User,[rfReplaceAll]);
  FMsg.Text := StringReplace(FMsg.Text,':password', Login.InitialLogin.Password, [rfReplaceAll]);

  if Assigned(OnCustomInitialMsg) then OnCustomInitialMsg(Self,FCustomForm ,FMsg);
  if FCustomForm <> nil then FCustomForm.ShowModal else MessageDlg(FMsg.Text, mtInformation, [mbOK], 0);
end;


procedure TUserControl.ApplySettings(SourceSettings: TUCSettings);
begin
    with Settings.CommonMessages do
    begin
      BlankPassword := SourceSettings.CommonMessages.BlankPassword;
      PasswordChanged := SourceSettings.CommonMessages.PasswordChanged;
      InitialMessage.Text := SourceSettings.CommonMessages.InitialMessage.Text;
      MaxLoginAttemptsError := SourceSettings.CommonMessages.MaxLoginAttemptsError;
      InvalidLogin := SourceSettings.CommonMessages.InvalidLogin;
      AutoLogonError := SourceSettings.CommonMessages.AutoLogonError;
    end;
    with Settings.Login do
    begin
      BtCancel := SourceSettings.Login.BtCancel;
      BtOK := SourceSettings.Login.BtOK;
      LabelPassword := SourceSettings.Login.LabelPassword;
      LabelUser := SourceSettings.Login.LabelUser;
      WindowCaption := SourceSettings.Login.WindowCaption;
      if Assigned(SourceSettings.Login.LeftImage.Bitmap) then LeftImage.Bitmap := SourceSettings.Login.LeftImage.Bitmap
      else LeftImage.Bitmap := nil;
      if Assigned(SourceSettings.Login.TopImage.Bitmap) then TopImage.Bitmap := SourceSettings.Login.TopImage.Bitmap
      else TopImage.Bitmap := nil;
      if Assigned(SourceSettings.Login.BottomImage.Bitmap) then BottomImage.Bitmap := SourceSettings.Login.BottomImage.Bitmap
      else BottomImage.Bitmap := nil;
    end;
    with Settings.UsersForm do
    begin
      WindowCaption := SourceSettings.UsersForm.WindowCaption;
      LabelDescription := SourceSettings.UsersForm.LabelDescription;
      ColName := SourceSettings.UsersForm.ColName;
      ColLogin := SourceSettings.UsersForm.ColLogin;
      ColEmail := SourceSettings.UsersForm.ColEmail;
      BtAdd := SourceSettings.UsersForm.BtAdd;
      BtChange := SourceSettings.UsersForm.BtChange;
      BtDelete := SourceSettings.UsersForm.BtDelete;
      BtRights := SourceSettings.UsersForm.BtRights;
      BtPassword := SourceSettings.UsersForm.BtPassword;
      BtClose := SourceSettings.UsersForm.BtClose;
      PromptDelete := SourceSettings.UsersForm.PromptDelete;
      PromptDelete_WindowCaption := SourceSettings.UsersForm.PromptDelete_WindowCaption; //added by fduenas
    end;
    with Settings.UsersProfile do
    begin
      WindowCaption :=   SourceSettings.UsersProfile.WindowCaption;
      LabelDescription := SourceSettings.UsersProfile.LabelDescription;
      ColProfile := SourceSettings.UsersProfile.ColProfile;
      BtAdd := SourceSettings.UsersProfile.BtAdd;
      BtChange := SourceSettings.UsersProfile.BtChange;
      BtDelete := SourceSettings.UsersProfile.BtDelete;
      BtRights := SourceSettings.UsersProfile.BtRights; //added by fduenas
      BtClose := SourceSettings.UsersProfile.BtClose;
      PromptDelete := SourceSettings.UsersProfile.PromptDelete;
      PromptDelete_WindowCaption := SourceSettings.UsersProfile.PromptDelete_WindowCaption; //added by fduenas
    end;
    with Settings.AddChangeUser do
    begin
      WindowCaption := SourceSettings.AddChangeUser.WindowCaption;
      LabelAdd := SourceSettings.AddChangeUser.LabelAdd;
      LabelChange := SourceSettings.AddChangeUser.LabelChange;
      LabelName := SourceSettings.AddChangeUser.LabelName;
      LabelLogin := SourceSettings.AddChangeUser.LabelLogin;
      LabelEmail := SourceSettings.AddChangeUser.LabelEmail;
      CheckPrivileged := SourceSettings.AddChangeUser.CheckPrivileged;
      BtSave := SourceSettings.AddChangeUser.BtSave;
      BtCancel := SourceSettings.AddChangeUser.BtCancel;
    end;
    with Settings.AddChangeProfile do
    begin
      WindowCaption := SourceSettings.AddChangeProfile.WindowCaption;
      LabelAdd := SourceSettings.AddChangeProfile.LabelAdd;
      LabelChange := SourceSettings.AddChangeProfile.LabelChange;
      LabelName := SourceSettings.AddChangeProfile.LabelName;
      BtSave := SourceSettings.AddChangeProfile.BtSave;
      BtCancel := SourceSettings.AddChangeProfile.BtCancel;
    end;
    with Settings.Rights do
    begin
      WindowCaption := SourceSettings.Rights.WindowCaption;
      LabelUser := SourceSettings.Rights.LabelUser;
      LabelProfile := SourceSettings.Rights.LabelProfile;
      PageMenu := SourceSettings.Rights.PageMenu;
      PageActions := SourceSettings.Rights.PageActions;
      BtUnlock := SourceSettings.Rights.BtUnlock;
      BtLock := SourceSettings.Rights.BtLock;
      BtSave := SourceSettings.Rights.BtSave;
      BtCancel := SourceSettings.Rights.BtCancel;
    end;
    with Settings.ChangePassword do
    begin
      WindowCaption := SourceSettings.ChangePassword.WindowCaption;
      LabelDescription := SourceSettings.ChangePassword.LabelDescription;
      LabelCurrentPassword := SourceSettings.ChangePassword.LabelCurrentPassword;
      LabelNewPassword := SourceSettings.ChangePassword.LabelNewPassword;
      LabelConfirm := SourceSettings.ChangePassword.LabelConfirm;
      BtSave := SourceSettings.ChangePassword.BtSave;
      BtCancel := SourceSettings.ChangePassword.BtCancel;
    end;
    with Settings.CommonMessages.ChangePasswordError do
    begin
      InvalidCurrentPassword := SourceSettings.CommonMessages.ChangePasswordError.InvalidCurrentPassword;
      NewPasswordError := SourceSettings.CommonMessages.ChangePasswordError.NewPasswordError;
      NewEqualCurrent := SourceSettings.CommonMessages.ChangePasswordError.NewEqualCurrent;
      PasswordRequired := SourceSettings.CommonMessages.ChangePasswordError.PasswordRequired;
      MinPasswordLength := SourceSettings.CommonMessages.ChangePasswordError.MinPasswordLength;
      InvalidNewPassword := SourceSettings.CommonMessages.ChangePasswordError.InvalidNewPassword;
    end;
    with Settings.ResetPassword do
    begin
      WindowCaption := SourceSettings.ResetPassword.WindowCaption;
      LabelPassword := SourceSettings.ResetPassword.LabelPassword;
    end;

    with Settings.Log do
    begin
      WindowCaption := SourceSettings.Log.WindowCaption;
      LabelDescription := SourceSettings.Log.LabelDescription;
      LabelUser := SourceSettings.Log.LabelUser;
      LabelDate := SourceSettings.Log.LabelDate;
      LabelLevel := SourceSettings.Log.LabelLevel;
      ColLevel := SourceSettings.Log.ColLevel;
      ColMessage := SourceSettings.Log.ColMessage;
      ColUser := SourceSettings.Log.ColUser;
      ColDate := SourceSettings.Log.ColDate;
      BtFilter := SourceSettings.Log.BtFilter;
      BtDelete := SourceSettings.Log.BtDelete;
      BtClose := SourceSettings.Log.BtClose;
      PromptDelete := SourceSettings.Log.PromptDelete;
      PromptDelete_WindowCaption := SourceSettings.Log.PromptDelete_WindowCaption; //added by fduenas
      OptionUserAll := SourceSettings.Log.OptionUserAll; //added by fduenas
      OptionLevelLow := SourceSettings.Log.OptionLevelLow; //added by fduenas
      OptionLevelNormal := SourceSettings.Log.OptionLevelNormal; //added by fduenas
      OptionLevelHigh := SourceSettings.Log.OptionLevelHigh; //added by fduenas
      OptionLevelCritic := SourceSettings.Log.OptionLevelCritic; //added by fduenas
      DeletePerformed := SourceSettings.Log.DeletePerformed; //added by fduenas
    end;

    with Settings.AppMessages do
    begin
      MsgsForm_BtNew := SourceSettings.AppMessages.MsgsForm_BtNew;
      MsgsForm_BtReplay := SourceSettings.AppMessages.MsgsForm_BtReplay;
      MsgsForm_BtForward := SourceSettings.AppMessages.MsgsForm_BtForward;
      MsgsForm_BtDelete := SourceSettings.AppMessages.MsgsForm_BtDelete;
      MsgsForm_BtClose := SourceSettings.AppMessages.MsgsForm_BtClose; //added by fduenas
      MsgsForm_WindowCaption := SourceSettings.AppMessages.MsgsForm_WindowCaption;
      MsgsForm_ColFrom := SourceSettings.AppMessages.MsgsForm_ColFrom;
      MsgsForm_ColSubject := SourceSettings.AppMessages.MsgsForm_ColSubject;
      MsgsForm_ColDate := SourceSettings.AppMessages.MsgsForm_ColDate;
      MsgsForm_PromptDelete := SourceSettings.AppMessages.MsgsForm_PromptDelete;
      MsgsForm_PromptDelete_WindowCaption := SourceSettings.AppMessages.MsgsForm_PromptDelete_WindowCaption; //added by fduenas
      MsgsForm_NoMessagesSelected := SourceSettings.AppMessages.MsgsForm_NoMessagesSelected; //added by fduenas
      MsgsForm_NoMessagesSelected_WindowCaption := SourceSettings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption; //added by fduenas

      MsgRec_BtClose := SourceSettings.AppMessages.MsgRec_BtClose;
      MsgRec_WindowCaption := SourceSettings.AppMessages.MsgRec_WindowCaption;
      MsgRec_Title := SourceSettings.AppMessages.MsgRec_Title;
      MsgRec_LabelFrom := SourceSettings.AppMessages.MsgRec_LabelFrom;
      MsgRec_LabelDate := SourceSettings.AppMessages.MsgRec_LabelDate;
      MsgRec_LabelSubject := SourceSettings.AppMessages.MsgRec_LabelSubject;
      MsgRec_LabelMessage := SourceSettings.AppMessages.MsgRec_LabelMessage;

      MsgSend_BtSend := SourceSettings.AppMessages.MsgSend_BtSend;
      MsgSend_BtCancel := SourceSettings.AppMessages.MsgSend_BtCancel;
      MsgSend_WindowCaption := SourceSettings.AppMessages.MsgSend_WindowCaption;
      MsgSend_Title := SourceSettings.AppMessages.MsgSend_Title;
      MsgSend_GroupTo := SourceSettings.AppMessages.MsgSend_GroupTo;
      MsgSend_RadioUser := SourceSettings.AppMessages.MsgSend_RadioUser;
      MsgSend_RadioAll := SourceSettings.AppMessages.MsgSend_RadioAll;
      MsgSend_GroupMessage := SourceSettings.AppMessages.MsgSend_GroupMessage;
      MsgSend_LabelSubject := SourceSettings.AppMessages.MsgSend_LabelSubject; //added by fduenas
      MsgSend_LabelMessageText := SourceSettings.AppMessages.MsgSend_LabelMessageText; //added by fduenas
    end;
    Settings.XPStyleSet.Assign(SourceSettings.XPStyleSet);
    Settings.XPStyle := SourceSettings.XPStyle;
   //c Settings.WindowsPosition := SourceSettings.WindowsPosition;
end;


{$IFDEF Ver130}
function StrToBool ( Valor : String) : Boolean;
begin
  if Valor = '-1' then Result := True else Result := False;
end;

function BoolToStr ( Valor : Boolean) : String;
begin
  if Valor then Result := '-1' else Result := '0';
end;
{$ENDIF}

{ TCadastroUsuarios }

procedure TCadastroUsuarios.Assign(Source: TPersistent);
begin
  if Source is TCadastroUsuarios then
  begin
    Self.MenuItem := TCadastroUsuarios(Source).MenuItem;
    Self.Action := TCadastroUsuarios(Source).Action;
  end else inherited;
end;

constructor TCadastroUsuarios.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TCadastroUsuarios.Destroy;
begin
  inherited;
end;


procedure TCadastroUsuarios.SetActCadUsu(const Value: TAction);
begin
  FActCadUsu := Value;
  if Value <> nil then Value.FreeNotification(Self.Action);
end;


procedure TCadastroUsuarios.SetMenuCadUsu(const Value: TMenuItem);
begin
  FMenuCadUsu := Value;
  if Value <> nil then Value.FreeNotification(Self.MenuItem);
end;



{ TLogin }

procedure TLogin.Assign(Source: TPersistent);
begin
  if Source is TLogin then
  begin
    Self.MaxLoginAttempts := TLogin(Source).MaxLoginAttempts;
  end else inherited;
end;

constructor TLogin.Create(AOwner: TComponent);
begin
  inherited Create;
  AutoLogon := TUCAutoLogin.Create(nil);
  InitialLogin := TInitialLogin.Create(nil);
  if not AutoLogon.MessageOnError  then AutoLogon.MessageOnError := True;
end;

destructor TLogin.Destroy;
begin
  AutoLogon.Free; //added by fduenas
  InitialLogin.Free; //added by fduenas
  inherited;
end;


{ TPerfilUsuarios }

procedure TPerfilUsuarios.Assign(Source: TPersistent);
begin
  if Source is TPerfilUsuarios then
  begin
    Self.MenuItem := TPerfilUsuarios(Source).MenuItem;
    Self.Action := TPerfilUsuarios(Source).Action;
  end else inherited;
end;

constructor TPerfilUsuarios.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TPerfilUsuarios.Destroy;
begin
  inherited;
end;

procedure TPerfilUsuarios.SetActPerfUsu(const Value: TAction);
begin
  FActPerfUsu := Value;
  if Value <> nil then Value.FreeNotification(Self.Action);
end;


procedure TPerfilUsuarios.SetMenuPerfUsu(const Value: TMenuItem);
begin
  FMenuPerfUsu := Value;
  if Value <> nil then Value.FreeNotification(Self.MenuItem);
end;

{ TTrocarSenha }

procedure TTrocarSenha.Assign(Source: TPersistent);
begin
  if Source is TTrocarSenha then
  begin
    Self.MenuItem := TTrocarSenha(Source).MenuItem;
    Self.Action := TTrocarSenha(Source).Action;

    Self.ForcePassword := TTrocarSenha(Source).ForcePassword;
    Self.MinPasswordLength := TTrocarSenha(Source).MinPasswordLength;
  end else inherited;
end;

constructor TTrocarSenha.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TTrocarSenha.Destroy;
begin
  inherited;
end;

procedure TTrocarSenha.SetActChgPassUsu(const Value: TAction);
begin
  FActChgPass := Value;
  if Value <> nil then Value.FreeNotification(Self.Action);
end;


procedure TTrocarSenha.SetMenuChgPassUsu(const Value: TMenuItem);
begin
  FMenuChgPassUsu := Value;
  if Value <> nil then Value.FreeNotification(Self.MenuItem);
end;

{ TInitialLogin }

procedure TInitialLogin.Assign(Source: TPersistent);
begin
  if Source is TInitialLogin then
  begin
    Self.User := TInitialLogin(Source).User;
    Self.Password := TInitialLogin(Source).Password;
  end else inherited;

end;

constructor TInitialLogin.Create(AOwner: TComponent);
begin
  inherited Create;
  FPermINI := TStringList.Create;
end;

destructor TInitialLogin.Destroy;
begin
  FreeAndNil(FPermIni); //added by fduenas
  inherited;
end;

procedure TInitialLogin.SetFPermIni(const Value: TStrings);
begin
  FPermIni.Assign(Value);
end;

{ TUCControlRight }

procedure TUCControlRight.Assign(Source: TPersistent);
begin
  if Source is TUCControlRight then
  begin
    Self.ActionList := TUCControlRight(Source).ActionList;
    {$IFDEF UCACTMANAGER}
    Self.ActionManager := TUCControlRight(Source).ActionManager;
    {$ENDIF}
  end else inherited;

end;

constructor TUCControlRight.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TUCControlRight.Destroy;
begin
  inherited;
end;

procedure TUCControlRight.SetActionList(const Value: TActionList);
begin
  FActionList := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self.ActionList);
    {$IFDEF UCACTMANAGER}
    FActionManager := nil;
    {$ENDIF}
  end;
end;
{$IFDEF UCACTMANAGER}
procedure TUCControlRight.SetActionMainMenuBar(
  const Value: TActionMainMenuBar);
begin
  FActionMainMenuBar := Value;
  if Value <> nil then Value.FreeNotification(Self.ActionMainMenuBar);
end;

procedure TUCControlRight.SetActionManager(const Value: TActionManager);
begin
  FActionManager := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self.ActionManager);
    FActionList := nil;
  end;
end;
{$ENDIF}

procedure TUCControlRight.SetMainMenu(const Value: TMenu);
begin
  FMainMenu := Value;
  if Value <> nil then Value.FreeNotification(Self.MainMenu);
end;

{ TUCAppMessage }

procedure TUCAppMessage.CheckMessages;
  function FmtDtHr(dt : String) : String;
  begin
    Result := Copy(dt,7,2)+'/'+Copy(dt,5,2)+'/'+Copy(dt,1,4)+' '+Copy(dt,9,2)+':'+Copy(dt,11,2);
  end;
begin
  if not FReady then Exit;
  with Self.UserControl.DataConnector.UCGetSQLDataset('SELECT UCM.IdMsg, UCC.'+Self.UserControl.TableUsers.FieldUserName +
    ' AS De, UCC_1.'+Self.UserControl.TableUsers.FieldUserName+' AS Para, UCM.Subject, UCM.Msg, UCM.DtSend, UCM.DtReceive ' +
    'FROM ('+ Self.TableMessages+ ' UCM INNER JOIN ' + Self.UserControl.TableUsers.TableName + ' UCC ON UCM.UsrFrom = UCC.'+Self.UserControl.TableUsers.FieldUserID+') INNER JOIN '+
    Self.UserControl.TableUsers.TableName + ' UCC_1 ON UCM.UsrTo = UCC_1.'+Self.UserControl.TableUsers.FieldUserID+' where UCM.DtReceive is NULL and  UCM.UsrTo = ' + IntToStr(Self.UserControl.CurrentUser.UserID)) do
  begin
    while not eof do
    begin
      MsgRecForm := TMsgRecForm.Create(Self);
      MsgRecForm.stDe.Caption := Fieldbyname('De').asString;
      MsgRecForm.stData.Caption := FmtDtHr(Fieldbyname('DtSend').asString);
      MsgRecForm.stAssunto.Caption := Fieldbyname('Subject').asString;
      MsgRecForm.MemoMsg.Text := Fieldbyname('msg').asString;
      Self.UserControl.DataConnector.UCExecSQL('Update '+ Self.TableMessages + ' set DtReceive =  '+
                                 QuotedStr(FormatDateTime('YYYYMMDDhhmm',now)) +
                                 ' Where  idMsg = ' + fieldbyname('idMsg').asString);
      MsgRecForm.Show;
      next;
    end;
    Close;
    Free;
  end;

end;

constructor TUCAppMessage.Create(AOWner: TComponent);
begin
  inherited;
  FReady := False;
  if csDesigning in ComponentState then
  begin
    Interval := 60000;
    Active := True;
  end;
  FVerifThread := TVerifThread.Create(True);
  FVerifThread.AOwner := Self;
  FVerifThread.FreeOnTerminate := True;
end;

procedure TUCAppMessage.DeleteAppMessage(IdMsg: Integer);
begin
  if MessageDlg(FUserControl.Settings.AppMessages.MsgsForm_PromptDelete, mtConfirmation, [mbYes, mbNo],0) <> mrYes then exit;
  UserControl.DataConnector.UCExecSQL('Delete from '+ TableMessages + ' where IdMsg = '+ IntToStr(idMsg));
end;

destructor TUCAppMessage.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    FVerifThread.Terminate;
    if Assigned(UserControl) then Usercontrol.DeleteLoginMonitor(Self);
  end;
  inherited Destroy;
end;

procedure TUCAppMessage.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    if not Assigned(FUserControl) then raise Exception.Create('Component UserControl not defined!');
    Usercontrol.AddLoginMonitor(Self);
    if not FUserControl.DataConnector.UCFindTable(TableMessages) then FUserControl.CriaTabelaMsgs(TableMessages);
{    FVerifThread := TVerifThread.Create(True);
    FVerifThread.AOwner := Self;
    FVerifThread.FreeOnTerminate := True;}
  end;
  FReady := True;
end;

procedure TUCAppMessage.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  If AOperation = opRemove then
     If AComponent = FUserControl then
        FUserControl := nil;

  inherited Notification(AComponent, AOperation);

end;

procedure TUCAppMessage.SendAppMessage(ToUser: Integer; Subject, Msg: String);
var
  UltId : integer;
begin
  with UserControl.DataConnector.UCGetSQLDataset('Select Max(idMsg) as nr from '+ TableMessages) do
  begin
    UltID := Fieldbyname('nr').asInteger +1;
    Close;
    Free;
  end;
  UserControl.DataConnector.UCExecSQL('Insert into '+ TableMessages + '( idMsg, UsrFrom, UsrTo, Subject, Msg, DtSend) Values ('+
                        IntToStr(UltId)+ ', '+
                        IntToStr(UserControl.CurrentUser.UserID)+', '+
                        IntToStr(toUser)+', '+
                        QuotedStr(Subject)+', '+
                        QuotedStr(Msg)+', '+
                        QuotedStr(FormatDateTime('YYYYMMDDHHMM',now))+')');

end;

procedure TUCAppMessage.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if (csDesigning in ComponentState) then exit;
  if FActive then FVerifThread.Resume else FVerifThread.Suspend;
end;

procedure TUCAppMessage.SetUserControl(const Value: TUserControl);
begin
  FUserControl := Value;
  if Value <> nil then
     Value.FreeNotification(self);
end;

procedure TUCAppMessage.ShowMessages;
begin
  MsgsForm := TMsgsForm.Create(self);
  with FUserControl.Settings.AppMessages do
  begin
    MsgsForm.Caption := MsgsForm_WindowCaption;
    MsgsForm.btnova.Caption := MsgsForm_BtNew;
    MsgsForm.btResponder.Caption := MsgsForm_BtReplay;
    MsgsForm.btEncaminhar.Caption := MsgsForm_BtForward;
    MsgsForm.btExcluir.Caption := MsgsForm_BtDelete;
    MsgsForm.btFechar.Caption := MsgsForm_BtClose;

    MsgsForm.ListView1.Columns[0].Caption := MsgsForm_ColFrom;
    MsgsForm.ListView1.Columns[1].Caption := MsgsForm_ColSubject;
    MsgsForm.ListView1.Columns[2].Caption := MsgsForm_ColDate;
  end;

  MsgsForm.DSMsgs := UserControl.DataConnector.UCGetSQLDataset('SELECT UCM.IdMsg, UCM.UsrFrom, UCC.'+Self.UserControl.TableUsers.FieldUserName+' AS De, UCC_1.'+Self.UserControl.TableUsers.FieldUserName+' AS Para, UCM.Subject, UCM.Msg, UCM.DtSend, UCM.DtReceive '+
                                   'FROM ('+ TableMessages + ' UCM INNER JOIN '+ UserControl.TableUsers.TableName+ ' UCC ON UCM.UsrFrom = UCC.'+Self.UserControl.TableUsers.FieldUserID+') '+
                                   ' INNER JOIN '+ UserControl.TableUsers.TableName+ ' UCC_1 ON UCM.UsrTo = UCC_1.'+Self.UserControl.TableUsers.FieldUserID+' WHERE UCM.UsrTo = '+IntToStr(UserControl.CurrentUser.UserID)+' ORDER BY UCM.DtReceive DESC');
  MsgsForm.DSMsgs.Open;
  MsgsForm.DSUsuarios := UserControl.DataConnector.UCGetSQLDataset('SELECT ' +
                           UserControl.TableUsers.FieldUserID + ' as idUser, ' +
                           UserControl.TableUsers.FieldLogin + ' as Login, ' +
                           UserControl.TableUsers.FieldUserName + ' as Nome, ' +
                           UserControl.TableUsers.FieldPassword + ' as Senha, ' +
                           UserControl.TableUsers.FieldEmail + ' as Email, ' +
                           UserControl.TableUsers.FieldPrivileged + ' as Privilegiado, ' +
                           UserControl.TableUsers.FieldTypeRec + ' as Tipo, ' +
                           UserControl.TableUsers.FieldProfile + ' as Perfil '+
                           ' FROM '+ UserControl.TableUsers.TableName +
                           ' WHERE '+ UserControl.TableUsers.FieldUserID + ' <> ' +IntToStr(UserControl.CurrentUser.UserID)+
                           ' AND ' + UserControl.TableUsers.FieldTypeRec  + ' = ' + QuotedStr('U') +
                           ' ORDER BY ' + UserControl.TableUsers.FieldUserName);
  MsgsForm.DSUsuarios.Open;

 //c MsgsForm.Position := Self.FUserControl.Settings.WindowsPosition;

  MsgsForm.ShowModal;
  FreeAndNil(MsgsForm)
end;

{ TVerifThread }

procedure TVerifThread.Execute;
begin
  while not self.Terminated do
  begin
    if (Assigned(TUCAppMessage(AOwner).UserControl)) and
    (TUCAppMessage(AOwner).UserControl.CurrentUser.UserID <> 0) then Synchronize(VerNovaMsg);
    Sleep(TUCAppMessage(aowner).Interval);
  end;
end;

procedure TVerifThread.VerNovaMsg;
var
  AOW : TUCAppMessage;
begin
  AOW := TUCAppMessage(AOwner);
  AOW.CheckMessages;
end;

{ TUCSettings }
procedure TUCSettings.Assign(Source: TPersistent);
begin
  if Source is TUserSettings then
  begin
    Self.CommonMessages.Assign(TUserSettings(Source).CommonMessages); //modified by fduenas
    Self.AppMessages.Assign(TUserSettings(Source).AppMessages); //modified by fduenas
    Self.XPStyleSet.Assign(TUserSettings(Source).XPStyleSet); //modified by fduenas
  end else inherited;
end;

constructor TUCSettings.Create(AOwner: TComponent);
begin
  inherited;

  FAppMessagesMSG := TAppMessagesMSG.Create(nil);
  FLoginFormMSG := TLoginFormMSG.Create(nil);
  FUserCommomMSG := TUserCommonMSG.Create(nil);
  FCadUserFormMSG := TCadUserFormMSG.Create(nil);
  FAddUserFormMSG := TAddUserFormMSG.Create(nil);
  FAddProfileFormMSG := TAddProfileFormMSG.Create(nil);
  FPermissFormMSG := TPermissFormMSG.Create(nil);
  FProfileUserFormMSG := TProfileUserFormMSG.Create(nil);
  FTrocaSenhaFormMSG := TTrocaSenhaFormMSG.Create(nil);
  FResetPassword := TResetPassword.Create(nil);
  FLogControlFormMSG := TLogControlFormMSG.Create(nil);
  FUCXPSettings := TUCXPSettings.Create(nil);

  {
  FAppMessagesMSG := TAppMessagesMSG.Create(nil);
  FLoginFormMSG := TLoginFormMSG.Create(Self);
  FUserCommomMSG := TUserCommonMSG.Create(Self);
  FCadUserFormMSG := TCadUserFormMSG.Create(Self);
  FAddUserFormMSG := TAddUserFormMSG.Create(Self);
  FAddProfileFormMSG := TAddProfileFormMSG.Create(Self);
  FPermissFormMSG := TPermissFormMSG.Create(Self);
  FProfileUserFormMSG := TProfileUserFormMSG.Create(Self);
  FTrocaSenhaFormMSG := TTrocaSenhaFormMSG.Create(Self);
  FResetPassword := TResetPassword.Create(Self);
  FLogControlFormMSG := TLogControlFormMSG.Create(Self);
  FUCXPSettings := TUCXPSettings.Create(Self);
  }
  if csDesigning in ComponentState then IniSettings2(Self);

end;

destructor TUCSettings.Destroy;
begin
  //added by fduenas
  FAppMessagesMSG.Free;
  FLoginFormMSG.Free;
  FUserCommomMSG.Free;
  FCadUserFormMSG.Free;
  FAddUserFormMSG.Free;
  FAddProfileFormMSG.Free;
  FPermissFormMSG.Free;
  FProfileUserFormMSG.Free;
  FTrocaSenhaFormMSG.Free;
  FResetPassword.Free;
  FLogControlFormMSG.Free;
  FUCXPSettings.Free;

  inherited;
end;


procedure TUCSettings.SetAppMessagesMSG(const Value: TAppMessagesMSG);
begin
  FAppMessagesMSG := Value;
end;

procedure TUCSettings.SetFAddProfileFormMSG(
  const Value: TAddProfileFormMSG);
begin
  FAddProfileFormMSG := Value;
end;

procedure TUCSettings.SetFAddUserFormMSG(const Value: TAddUserFormMSG);
begin
  FAddUserFormMSG := Value;
end;

procedure TUCSettings.SetFCadUserFormMSG(const Value: TCadUserFormMSG);
begin
  FCadUserFormMSG := Value;
end;

procedure TUCSettings.SetFFormLoginMsg(const Value: TLoginFormMSG);
begin
  FLoginFormMSG := Value;
end;

procedure TUCSettings.SetFLogControlFormMSG(
  const Value: TLogControlFormMSG);
begin
  FLogControlFormMSG := Value;
end;

procedure TUCSettings.SetFPermissFormMSG(const Value: TPermissFormMSG);
begin
  FPermissFormMSG := Value;
end;

procedure TUCSettings.SetFProfileUserFormMSG(
  const Value: TProfileUserFormMSG);
begin
  FProfileUserFormMSG := Value;
end;

procedure TUCSettings.SetFResetPassword(const Value: TResetPassword);
begin
  FResetPassword := Value;
end;

procedure TUCSettings.SetFTrocaSenhaFormMSG(
  const Value: TTrocaSenhaFormMSG);
begin
  FTrocaSenhaFormMSG := Value;
end;

procedure TUCSettings.SetFUserCommonMSg(const Value: TUserCommonMSG);
begin
  FUserCommomMSG := Value;
end;


procedure IniSettings2(DestSettings: TUCSettings);
var
  tmp : TBitmap;
begin
    with DestSettings.CommonMessages do
    begin
      if BlankPassword = '' then BlankPassword := Const_Men_SenhaDesabitada;
      if PasswordChanged = '' then PasswordChanged := Const_Men_SenhaAlterada;
      if InitialMessage.Text = '' then InitialMessage.Text := Const_Men_MsgInicial;
      if MaxLoginAttemptsError = '' then MaxLoginAttemptsError := Const_Men_MaxTentativas;
      if InvalidLogin = '' then InvalidLogin := Const_Men_LoginInvalido;
      if AutoLogonError = '' then AutoLogonError := Const_Men_AutoLogonError;
    end;
    with DestSettings.Login do
    begin
      if BtCancel = '' then BtCancel := Const_Log_BtCancelar;
      if BtOK = '' then BtOK := Const_Log_BtOK;
      if LabelPassword = '' then LabelPassword := Const_Log_LabelSenha;
      if LabelUser = '' then LabelUser := Const_Log_LabelUsuario;
      if WindowCaption = '' then WindowCaption := Const_Log_WindowCaption;

      Tmp := TBitmap.create;
      Tmp.LoadFromResourceName(HInstance, 'UCLOCKLOGIN');
      LeftImage.Assign(tmp);
      FreeAndNil(tmp);
    end;
    with DestSettings.UsersForm do
    begin
      if WindowCaption = '' then WindowCaption := Const_Cad_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Cad_LabelDescricao;
      if ColName = '' then ColName := Const_Cad_ColunaNome;
      if ColLogin = '' then ColLogin := Const_Cad_ColunaLogin;
      if ColEmail = '' then ColEmail := Const_Cad_ColunaEmail;
      if BtAdd = '' then BtAdd := Const_Cad_BtAdicionar;
      if BtChange = '' then BtChange := Const_Cad_BtAlterar;
      if BtDelete = '' then BtDelete := Const_Cad_BtExcluir;
      if BtRights = '' then BtRights := Const_Cad_BtPermissoes;
      if BtPassword = '' then BtPassword := Const_Cad_BtSenha;
      if BtClose = '' then BtClose := Const_Cad_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_Cad_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_Cad_ConfirmaDelete_WindowCaption; //added by fduenas
    end;
    with DestSettings.UsersProfile do
    begin
      if WindowCaption = '' then WindowCaption := Const_Prof_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Prof_LabelDescricao;
      if ColProfile = '' then ColProfile := Const_Prof_ColunaNome;
      if BtAdd = '' then BtAdd := Const_Prof_BtAdicionar;
      if BtChange = '' then BtChange := Const_Prof_BtAlterar;
      if BtDelete = '' then BtDelete := Const_Prof_BtExcluir;
      if BtRights = '' then BtRights := Const_Prof_BtPermissoes;
      if BtClose = '' then BtClose := Const_Prof_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_Prof_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_Prof_ConfirmaDelete_WindowCaption; //added by fduenas
    end;
    with DestSettings.AddChangeUser do
    begin
      if WindowCaption = '' then WindowCaption := Const_Inc_WindowCaption;
      if LabelAdd = '' then LabelAdd := Const_Inc_LabelAdicionar;
      if LabelChange = '' then LabelChange := Const_Inc_LabelAlterar;
      if LabelName = '' then LabelName := Const_Inc_LabelNome;
      if LabelLogin = '' then LabelLogin := Const_Inc_LabelLogin;
      if LabelEmail = '' then LabelEmail := Const_Inc_LabelEmail;
      if CheckPrivileged = '' then CheckPrivileged := Const_Inc_CheckPrivilegiado;
      if BtSave = '' then BtSave := Const_Inc_BtGravar;
      if BtCancel = '' then BtCancel := Const_Inc_BtCancelar;
    end;
    with DestSettings.AddChangeProfile do
    begin
      if WindowCaption = '' then WindowCaption := Const_PInc_WindowCaption;
      if LabelAdd = '' then LabelAdd := Const_PInc_LabelAdicionar;
      if LabelChange = '' then LabelChange := Const_PInc_LabelAlterar;
      if LabelName = '' then LabelName := Const_PInc_LabelNome;
      if BtSave = '' then BtSave := Const_PInc_BtGravar;
      if BtCancel = '' then BtCancel := Const_PInc_BtCancelar;
    end;
    with DestSettings.Rights do
    begin
      if WindowCaption = '' then WindowCaption := Const_Perm_WindowCaption;
      if LabelUser = '' then LabelUser := Const_Perm_LabelUsuario;
      if LabelProfile = '' then LabelProfile := Const_Perm_LabelPerfil;
      if PageMenu = '' then PageMenu := Const_Perm_PageMenu;
      if PageActions = '' then PageActions := Const_Perm_PageActions;
      if BtUnlock = '' then BtUnlock := Const_Perm_BtLibera;
      if BtLock = '' then BtLock := Const_Perm_BtBloqueia;
      if BtSave = '' then BtSave := Const_Perm_BtGravar;
      if BtCancel = '' then BtCancel := Const_Perm_BtCancelar;
    end;
    with DestSettings.ChangePassword do
    begin
      if WindowCaption = '' then WindowCaption := Const_Troc_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_Troc_LabelDescricao;
      if LabelCurrentPassword = '' then LabelCurrentPassword := Const_Troc_LabelSenhaAtual;
      if LabelNewPassword = '' then LabelNewPassword := Const_Troc_LabelNovaSenha;
      if LabelConfirm = '' then LabelConfirm := Const_Troc_LabelConfirma;
      if BtSave = '' then BtSave := Const_Troc_BtGravar;
      if BtCancel = '' then BtCancel := Const_Troc_BtCancelar;
    end;
    with DestSettings.CommonMessages.ChangePasswordError do
    begin
      if InvalidCurrentPassword = '' then InvalidCurrentPassword :=  Const_ErrPass_SenhaAtualInvalida;
      if NewPasswordError = '' then NewPasswordError :=  Const_ErrPass_ErroNovaSenha;
      if NewEqualCurrent = '' then NewEqualCurrent :=  Const_ErrPass_NovaIgualAtual;
      if PasswordRequired = '' then PasswordRequired :=  Const_ErrPass_SenhaObrigatoria;
      if MinPasswordLength = '' then MinPasswordLength := Const_ErrPass_SenhaMinima;
      if InvalidNewPassword= '' then InvalidNewPassword :=  Const_ErrPass_SenhaInvalida;
    end;
    with DestSettings.ResetPassword do
    begin
      if WindowCaption = '' then WindowCaption := Const_DefPass_WindowCaption;
      if LabelPassword = '' then LabelPassword := Const_DefPass_LabelSenha;
    end;
    with DestSettings.Log do
    begin
      if WindowCaption = '' then WindowCaption := Const_LogC_WindowCaption;
      if LabelDescription = '' then LabelDescription := Const_LogC_LabelDescricao;
      if LabelUser = '' then LabelUser := Const_LogC_LabelUsuario;
      if LabelDate = '' then LabelDate := Const_LogC_LabelData;
      if LabelLevel = '' then LabelLevel := Const_LogC_LabelNivel;
      if ColLevel = '' then ColLevel := Const_LogC_ColunaNivel;
      if ColMessage = '' then ColMessage := Const_LogC_ColunaMensagem;
      if ColUser = '' then ColUser := Const_LogC_ColunaUsuario;
      if ColDate = '' then ColDate := Const_LogC_ColunaData;
      if BtFilter = '' then BtFilter := Const_LogC_BtFiltro;
      if BtDelete = '' then BtDelete := Const_LogC_BtExcluir;
      if BtClose = '' then BtClose := Const_LogC_BtFechar;
      if PromptDelete = '' then PromptDelete := Const_LogC_ConfirmaExcluir;
      if PromptDelete_WindowCaption = '' then PromptDelete_WindowCaption := Const_LogC_ConfirmaDelete_WindowCaption; //added by fduenas
      if OptionUserAll = '' then OptionUserAll := Const_LogC_Todos; //added by fduenas
      if OptionLevelLow = '' then OptionLevelLow := Const_LogC_Low; //added by fduenas
      if OptionLevelNormal = '' then OptionLevelNormal := Const_LogC_Normal; //added by fduenas
      if OptionLevelHigh = '' then OptionLevelHigh := Const_LogC_High; //added by fduenas
      if OptionLevelCritic = '' then OptionLevelCritic := Const_LogC_Critic; //added by fduenas
      if DeletePerformed = '' then DeletePerformed := Const_LogC_ExcluirEfectuada; //added by fduenas
    end;
    with DestSettings.AppMessages do
    begin
      if MsgsForm_BtNew = '' then MsgsForm_BtNew := Const_Msgs_BtNew;
      if MsgsForm_BtReplay = '' then MsgsForm_BtReplay := Const_Msgs_BtReplay;
      if MsgsForm_BtForward = '' then MsgsForm_BtForward := Const_Msgs_BtForward;
      if MsgsForm_BtDelete = '' then MsgsForm_BtDelete := Const_Msgs_BtDelete;
      if MsgsForm_BtClose = '' then MsgsForm_BtClose := Const_Msgs_BtClose; //added by fduenas
      if MsgsForm_WindowCaption = '' then MsgsForm_WindowCaption := Const_Msgs_WindowCaption;
      if MsgsForm_ColFrom = '' then  MsgsForm_ColFrom := Const_Msgs_ColFrom;
      if MsgsForm_ColSubject = '' then  MsgsForm_ColSubject := Const_Msgs_ColSubject;
      if MsgsForm_ColDate = '' then MsgsForm_ColDate := Const_Msgs_ColDate;
      if MsgsForm_PromptDelete = '' then  MsgsForm_PromptDelete := Const_Msgs_PromptDelete;
      if MsgsForm_PromptDelete_WindowCaption = '' then  MsgsForm_PromptDelete_WindowCaption := Const_Msgs_PromptDelete_WindowCaption; //added by fduenas
      if MsgsForm_NoMessagesSelected = '' then  MsgsForm_NoMessagesSelected := Const_Msgs_NoMessagesSelected; //added by fduenas
      if MsgsForm_NoMessagesSelected_WindowCaption = '' then  MsgsForm_NoMessagesSelected_WindowCaption := Const_Msgs_NoMessagesSelected_WindowCaption; //added by fduenas

      if MsgRec_BtClose = '' then  MsgRec_BtClose := Const_MsgRec_BtClose;
      if MsgRec_WindowCaption = '' then MsgRec_WindowCaption := Const_MsgRec_WindowCaption;
      if MsgRec_Title = ''then MsgRec_Title := Const_MsgRec_Title;
      if MsgRec_LabelFrom = ''then MsgRec_LabelFrom := Const_MsgRec_LabelFrom;
      if MsgRec_LabelDate = '' then MsgRec_LabelDate := Const_MsgRec_LabelDate;
      if MsgRec_LabelSubject = '' then MsgRec_LabelSubject := Const_MsgRec_LabelSubject;
      if MsgRec_LabelMessage = '' then MsgRec_LabelMessage := Const_MsgRec_LabelMessage;

      if MsgSend_BtSend =  '' then MsgSend_BtSend := Const_MsgSend_BtSend;
      if MsgSend_BtCancel = '' then MsgSend_BtCancel := Const_MsgSend_BtCancel;
      if MsgSend_WindowCaption = '' then MsgSend_WindowCaption := Const_MsgSend_WindowCaption;
      if MsgSend_Title = '' then MsgSend_Title := Const_MsgSend_Title;
      if MsgSend_GroupTo = '' then MsgSend_GroupTo := Const_MsgSend_GroupTo;
      if MsgSend_RadioUser = '' then MsgSend_RadioUser := Const_MsgSend_RadioUser;
      if MsgSend_RadioAll = '' then MsgSend_RadioAll := Const_MsgSend_RadioAll;
      if MsgSend_GroupMessage = '' then MsgSend_GroupMessage := Const_MsgSend_GroupMessage;
      if MsgSend_LabelSubject = '' then MsgSend_LabelSubject := Const_MsgSend_LabelSubject; //added by fduenas
      if MsgSend_LabelMessageText = '' then MsgSend_LabelMessageText  := Const_MsgSend_LabelMessageText; //added by fduenas
    end;
   //c DestSettings.WindowsPosition := poMainFormCenter;
end;



{ TUCCollectionItem }

function TUCCollectionItem.GetDisplayName: string;
begin
  Result := FormName+'.'+CompName;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TUCCollectionItem.SetFormName(const Value: string);
begin
  if FFormName <> Value then
    FFormName := Value;
end;

procedure TUCCollectionItem.SetCompName(const Value: string);
begin
  if FCompName <> Value then
    FCompName:= Value;
end;

procedure TUCCollectionItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
    FCaption:= Value;
end;

procedure TUCCollectionItem.SetGroupName(const Value: string);
begin
  if FGroupName <> Value then
    FGroupname := Value;
end;

{ TUCCollection }

constructor TUCCollection.Create(UCBase: TUserControl);
begin
  inherited Create(TUCCollectionItem);
  FUCBase := UCBase;
end;

function TUCCollection.Add: TUCCollectionItem;
begin
  Result := TUCCollectionItem(inherited Add);
end;

function TUCCollection.GetItem(Index: Integer): TUCCollectionItem;
begin
  Result := TUCCollectionItem(inherited GetItem(Index));
end;

procedure TUCCollection.SetItem(Index: Integer;
	Value: TUCCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TUCCollection.GetOwner: TPersistent;
begin
  Result := FUCBase;
end;



{ TUCControls }

function TUCControls.GetActiveForm: String;
begin
  Result := TCustomForm(Owner).Name;
end;

function TUCControls.GetUCAccessType: String;
begin
  if not Assigned(UserControl) then Result := ''
  else Result := UserControl.ClassName;
end;

procedure TUCControls.ListComponents(Form: String; List : TStrings);
var
  Contador : Integer;
begin
  List.Clear;
  if not Assigned(UserControl) then Exit;
  for Contador := 0 to Pred(UserControl.ExtraRight.Count) do
    if UpperCase(UserControl.ExtraRight[Contador].FormName) = UpperCase(Form) then
      List.Append(UserControl.ExtraRight[Contador].CompName);
end;

procedure TUCControls.ApplyRights;
var
  FListObj : TStringList;
  TempDS : TDataset;
  Contador : Integer;
begin
  try
    // Apply Extra Rights

    if not Assigned(UserControl) then Exit;
    with UserControl do
    begin



  //      if (UserControl.LoginMode = lmActive) and (CurrentUser.UserID = 0)  then Exit;
  //linha acima removida por camilo, abas não aplicou as permissões


    //qmd
  {    if UserControl.LoginMode = lmActive then
        and
        repeat
          Application.ProcessMessages;
        until CurrentUser.UserID > 0;}

      //adicionado por camilo
      // se der qualquer erro o form fica desativado

      LockControls;

      // camilo
      TCustomForm(Self.Owner).Enabled := False;

      FListObj := TStringList.Create;
      Self.ListComponents(Self.Owner.Name, FListObj);

      if UserControl.DataConnector.UCFindDataConnection then
      begin
        // permissoes do usuario
        TempDS := DataConnector.UCGetSQLDataset(Format('Select %s as UserID,%s as ObjName, %s as UCKey from %sEX Where %s = %d And %s = %s And %s = %s',
                                              [TableRights.FieldUserID,
                                                TableRights.FieldComponentName,
                                                TableRights.FieldKey,
                                                TableRights.TableName,
                                                TableRights.FieldUserID,
                                                CurrentUser.UserID,
                                                TableRights.FieldModule,
                                                QuotedStr(ApplicationID),
                                                TableRights.FieldFormName,
                                                QuotedStr(Self.Owner.Name)]) );

        //camilo
        TCustomForm(Self.Owner).Enabled := True;
        Application.ProcessMessages;

        for contador := 0 to Pred(FListObj.Count) do
        begin
          if (not TempDS.Locate('ObjName', FListObj[Contador],[])) or
           (Decrypt(TempDS.FieldByName('UCKey').asString, EncryptKey) <> TempDS.FieldByName('UserID').asString + TempDS.FieldByName('ObjName').asString) then
             LockEX(TCustomForm(Self.Owner), FListObj[Contador], NotAllowed = naInvisible)
          else
            UnlockEX(TCustomForm(Self.Owner), FListObj[Contador]);
        end;
        TempDS.Close;

        //camilo
        TCustomForm(Self.Owner).Enabled := False;
        Application.ProcessMessages;

        //permissoes do grupo
        TempDS := DataConnector.UCGetSQLDataset(Format('Select %s as UserID, %s as ObjName, %s as UCKey from %sEX Where %s = %d And %s = %s And %s = %s',
                                              [ TableRights.FieldUserID,
                                                TableRights.FieldComponentName,
                                                TableRights.FieldKey,
                                                TableRights.TableName,
                                                TableRights.FieldUserID,
                                                CurrentUser.Profile,
                                                TableRights.FieldModule,
                                                QuotedStr(ApplicationID),
                                                TableRights.FieldFormName,
                                                QuotedStr(Self.Owner.Name)]) );
        //camilo
        TCustomForm(Self.Owner).Enabled := True;
        Application.ProcessMessages;

        for contador := 0 to Pred(FListObj.Count) do
          if (TempDS.Locate('ObjName', FListObj[Contador],[])) or
           (Decrypt(TempDS.FieldByName('UCKey').asString, EncryptKey) <> TempDS.FieldByName('UserID').asString + TempDS.FieldByName('ObjName').asString) then
             UnlockEX(TCustomForm(Self.Owner), FListObj[Contador]);
        TempDS.Close;
      end else LockControls;
    end;

    except
      on E: Exception do
      begin
        TCustomForm(Self.Owner).Enabled := False;
        ShowMessage('Erro ao aplicar UCTela: ' + E.Message);
        // Fechar o formulário de forma segura
        PostMessage(TCustomForm(Self.Owner).Handle, WM_CLOSE, 0, 0);
        Application.ProcessMessages;
        TCustomForm(Self.Owner).Close;
        // Forçar o encerramento do processo do formulário
        TerminateProcess(GetCurrentProcess, 0);
      end;
    end;
end;

procedure TUCControls.LockControls;
var
  Contador : Integer;
  FListObj : TStringList;
begin
  try
    FListObj := TStringList.Create;
    Self.ListComponents(Self.Owner.Name, FListObj);
    for Contador := 0 to Pred(FListObj.Count) do
      UserControl.LockEX(TCustomForm(Self.Owner), FListObj[Contador], NotAllowed = naInvisible);
    FreeAndNil(FListObj);
  except
    on E: Exception do
    begin
      TCustomForm(Self.Owner).Enabled := False;
      ShowMessage('Erro ao aplicar UCTela: ' + E.Message);
      // Fechar o formulário de forma segura
      PostMessage(TCustomForm(Self.Owner).Handle, WM_CLOSE, 0, 0);
      Application.ProcessMessages;
      TCustomForm(Self.Owner).Close;
      // Forçar o encerramento do processo do formulário
      TerminateProcess(GetCurrentProcess, 0);
    end;
  end;
end;

procedure TUCControls.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    ApplyRights;
    UserControl.AddUCControlMonitor(Self);
  end;
end;

procedure TUCControls.SetGroupName(const Value: String);
var
  Contador : Integer;
begin
  if FGroupName = Value then Exit;
  FGroupName := Value;
  if Assigned(UserControl) then
  for Contador := 0 to Pred(UserControl.ExtraRight.Count) do
    if UpperCase(UserControl.ExtraRight[Contador].FormName) = UpperCase(Owner.Name) then
      UserControl.ExtraRight[Contador].GroupName := Value;
end;

destructor TUCControls.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(UserControl) then  UserControl.DeleteUCControlMonitor(Self);
  end;
  inherited;
end;

procedure TUCControls.SetUserControl(const Value: TUserControl);
begin
  FUserControl := Value;
  if Value <> nil then
     Value.FreeNotification(self.UserControl);
end;

procedure TUCControls.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if AOperation = opRemove then
     if AComponent = FUserControl then
        FUserControl := nil;

  inherited Notification(AComponent, AOperation);

end;

{ TUCRun }

procedure TUCRun.Execute;
begin
  while not self.Terminated do
  begin
    if TUserControl(AOwner).DataConnector.UCFindDataConnection then Synchronize(UCStart);
    Sleep(50);
  end;
end;

procedure TUCRun.UCStart;
begin
  TUserControl(AOwner).Execute;
end;

function GetVersionApp(const AFileName: String): String;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := EmptyStr;
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result:= Concat(IntToStr(FI.dwFileVersionMS shr 16), '.',
                          IntToStr(FI.dwFileVersionMS and $FFFF), '.',
                          IntToStr(FI.dwFileVersionLS shr 16), '.',
                          IntToStr(FI.dwFileVersionLS and $FFFF));
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

end.


