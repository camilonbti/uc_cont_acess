unit UCMessages;

interface
uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Dialogs,  UCConsts,
  UCXPSettings, vcl.Forms;

type

  TAppMessagesMSG = class(TPersistent)
  private
    FMsgRec_LabelDate: String;
    FMsgsForm_BtBtForward: String;
    Fmsgsform_btnew: String;
    FMsgSend_GroupTo: String;
    FMsgSend_WindowCaption: String;
    FMsgSend_GroupMessage: String;
    FMsgsForm_ColFrom: String;
    FMsgsForm_BtDelete: String;
    FMsgsForm_BtClose: String; //added by fduenas
    FMsgRec_LabelMessage: String;
    FMsgRec_Title: String;
    FMsgSend_RadioAll: String;
    FMsgSend_RadioUser: String;
    FMsgSend_Title: String;
    FMsgsForm_ColSubject: String;
    FMsgRec_LabelFrom: String;
    FMsgsForm_WindowCaption: String;
    FMsgRec_LabelSubject: String;
    FMsgRec_WindowCaption: String;
    FMsgSend_BtSend: String;
    FMsgSend_BtCancel: String;
    FMsgsForm_BtReplay: String;
    FMsgRec_BtClose: String;
    FMsgSend_LabelSubject: String; //added by fduenas
    FMsgSend_LabelMessageText: String; //added by fduenas

    FMsgsForm_PromptDelete: String;
    FMsgsForm_PromptDelete_WindowCaption: String; //added by fduenas
    FMsgsForm_ColDate: String;

    FMsgsForm_NoMessagesSelected: String; //added by fduenas
    FMsgsForm_NoMessagesSelected_WindowCaption: String; //added by fduenas
  protected
  public
    constructor Create(Aowner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property MsgsForm_BtNew : String read Fmsgsform_btnew write Fmsgsform_btnew;
    property MsgsForm_BtReplay : String read FMsgsForm_BtReplay write FMsgsForm_BtReplay;
    property MsgsForm_BtForward : String read FMsgsForm_BtBtForward write FMsgsForm_BtBtForward;
    property MsgsForm_BtDelete : String read FMsgsForm_BtDelete write FMsgsForm_BtDelete;
    property MsgsForm_BtClose: String read FMsgsForm_BtClose write FMsgsForm_BtClose; //added By fduenas
    property MsgsForm_WindowCaption : String read FMsgsForm_WindowCaption write FMsgsForm_WindowCaption;
    property MsgsForm_ColFrom : String read FMsgsForm_ColFrom write FMsgsForm_ColFrom;
    property MsgsForm_ColSubject : String read FMsgsForm_ColSubject write FMsgsForm_ColSubject;
    property MsgsForm_ColDate : String read FMsgsForm_ColDate write FMsgsForm_ColDate;
    property MsgsForm_PromptDelete : String read FMsgsForm_PromptDelete write FMsgsForm_PromptDelete;
    property MsgsForm_PromptDelete_WindowCaption: String read FMsgsForm_PromptDelete_WindowCaption write FMsgsForm_PromptDelete_WindowCaption; //added by fduenas
    property MsgsForm_NoMessagesSelected: String read FMsgsForm_NoMessagesSelected write FMsgsForm_NoMessagesSelected; //added by fduenas
    property MsgsForm_NoMessagesSelected_WindowCaption: String read FMsgsForm_NoMessagesSelected_WindowCaption write FMsgsForm_NoMessagesSelected_WindowCaption; //added by fduenas

    property MsgRec_BtClose : String read FMsgRec_BtClose write FMsgRec_BtClose;
    property MsgRec_WindowCaption : String read FMsgRec_WindowCaption write FMsgRec_WindowCaption;
    property MsgRec_Title : String read FMsgRec_Title write FMsgRec_Title;
    property MsgRec_LabelFrom : String read FMsgRec_LabelFrom write FMsgRec_LabelFrom;
    property MsgRec_LabelDate : String read FMsgRec_LabelDate write FMsgRec_LabelDate;
    property MsgRec_LabelSubject : String read FMsgRec_LabelSubject write FMsgRec_LabelSubject;
    property MsgRec_LabelMessage : String read FMsgRec_LabelMessage write FMsgRec_LabelMessage;

    property MsgSend_BtSend : String read FMsgSend_BtSend write FMsgSend_BtSend;
    property MsgSend_BtCancel : String read FMsgSend_BtCancel write FMsgSend_BtCancel;
    property MsgSend_WindowCaption : String read FMsgSend_WindowCaption write FMsgSend_WindowCaption;
    property MsgSend_Title : String read FMsgSend_Title write FMsgSend_Title;
    property MsgSend_GroupTo : String read FMsgSend_GroupTo write FMsgSend_GroupTo;
    property MsgSend_RadioUser : String read FMsgSend_RadioUser write FMsgSend_RadioUser;
    property MsgSend_RadioAll : String read FMsgSend_RadioAll write FMsgSend_RadioAll;
    property MsgSend_GroupMessage : String read FMsgSend_GroupMessage write FMsgSend_GroupMessage;
    property MsgSend_LabelSubject: String read FMsgSend_LabelSubject write FMsgSend_LabelSubject; //added by fduenas
    property MsgSend_LabelMessageText: String read FMsgSend_LabelMessageText write FMsgSend_LabelMessageText; //added by fduenas
  end;



  TChangePassError = class(TPersistent)
  private
    FInvalidCurrentPassword,
    FNewPasswordError,
    FNewEqualCurrent,
    FPasswordRequired,
    FMinPasswordLength,
    FInvalidNewPassword: String;
  protected

  public
    constructor Create(Aowner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property InvalidCurrentPassword : String read FInvalidCurrentPassword write FInvalidCurrentPassword;
    property NewPasswordError : String read FNewPasswordError write FNewPasswordError;
    property NewEqualCurrent : String read FNewEqualCurrent write FNewEqualCurrent;
    property PasswordRequired : String read FPasswordRequired write FPasswordRequired;
    property MinPasswordLength : String read FMinPasswordLength write FMinPasswordLength;
    property InvalidNewPassword : String read FInvalidNewPassword write FInvalidNewPassword;
  end;

  TUserCommonMSG = class(TPersistent)
  private
    FPasswordOFF,
    FPasswordChanged,
    FInvalidUserPass,
    FMaxLoginTry,
    FAutoLogonError : String;
    FFirstMSG : TStrings;
    FChangePasswordError : TChangePassError;
    procedure SetFErroTrocaSenha(const Value: TChangePassError);
    procedure SetFFirstMSG(const Value: TStrings);
  protected

  public
    constructor Create(Aowner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property AutoLogonError : String read FAutoLogonError write FAutoLogonError;
    property ChangePasswordError : TChangePassError read FChangePasswordError write SetFErroTrocaSenha;
    property InvalidLogin : String read FInvalidUserPass write FInvalidUserPass;
    property InitialMessage :  TStrings read FFirstMSG write SetFFirstMSG;
    property MaxLoginAttemptsError : String read FMaxLoginTry write FMaxLoginTry;
    property PasswordChanged : String read FPasswordChanged write FPasswordChanged;
    property BlankPassword : String read FPasswordOFF write FPasswordOFF;
  end;

  TLoginFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelUser, FLabelPassword, FBtOk, FBtCancel : String;
    FBottomImage, FLeftImage, FTopImage : TPicture;
    procedure SetFBottomImage(const Value: TPicture);
    procedure SetFLeftImage(const Value: TPicture);
    procedure SetFTopImage(const Value: TPicture);
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelUser : String read FLabelUser write FLabelUser;
    property LabelPassword : String read FLabelPassword write FLabelPassword;
    property BtOk : String read FBtOk write FBtOk;
    property BtCancel : String read FBtCancel write FBtCancel;
    property TopImage : TPicture read FTopImage write SetFTopImage;
    property LeftImage : TPicture read FLeftImage write SetFLeftImage;
    property BottomImage : TPicture read FBottomImage write SetFBottomImage;
  end;

  TCadUserFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelDescricao, FColNome, FColLogin, FColEmail, FBtAdic, FBtAlt,
    FBtExc, FBtAccess, FBtPass, FBtClose, FConfExc: String;
    FPromptDelete_WindowCaption: string; //added by fduenas
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent);override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelDescription : String read FLabelDescricao write FLabelDescricao;
    property ColName : String read FColNome write FColNome;
    property ColLogin : String read FColLogin write FColLogin;
    property ColEmail : String read FColEmail write FColEmail;
    property BtAdd : String read FBtAdic write FBtAdic;
    property BtChange : String read FBtAlt write FBtAlt;
    property BtDelete : String read FBtExc write FBtExc;
    property PromptDelete : String read FConfExc write FConfExc;
    property PromptDelete_WindowCaption : String read FPromptDelete_WindowCaption write FPromptDelete_WindowCaption; //added by fduenas
    property BtRights : String read FBtAccess write FBtAccess;
    property BtPassword : String read FBtPass write FBtPass;
    property BtClose : String read FBtClose write FBtClose;
  end;

  TLogControlFormMSG = class(TPersistent)
  private
    FColUsuario: String;
    FColMensagem: String;
    FLabelDescription: String;
    FWindowCaption: String;
    FLabelLevel: String;
    FColData: String;
    FColNivel: String;
    FBtClose: String;
    FConfExc: String;
    FLabelUser: String;
    FBtFilt: String;
    FLabelDate: String;
    FBtExc: String;
    FOptionUserAll: string; //added by fduenas
    FOptionLevelLow: string; //added by fduenas
    FOptionLevelNormal: string; //added by fduenas
    FOptionLevelHigh: string; //added by fduenas
    FOptionLevelCritic: string; //added by fduenas
    FPromptDelete_WindowCaption: string; //added by fduenas
    FDeletePerformed: string; //added by fduenas
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent);override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelDescription : String read FLabelDescription write FLabelDescription;
    property LabelUser : String read FLabelUser write FLabelUser;
    property LabelDate : String read FLabelDate write FLabelDate;
    property LabelLevel : String read FLabelLevel write FLabelLevel;
    property ColLevel : String read FColNivel write FColNivel;
    property ColMessage : String read FColMensagem write FColMensagem;
    property ColUser : String read FColUsuario write FColUsuario;
    property ColDate : String read FColData write FColData;
    property BtFilter : String read FBtFilt write FBtFilt;
    property BtDelete : String read FBtExc write FBtExc;
    property BtClose : String read FBtClose write FBtClose;
    property PromptDelete : String read FConfExc write FConfExc;
    property PromptDelete_WindowCaption : String read FPromptDelete_WindowCaption write FPromptDelete_WindowCaption; //added by fduenas
    property OptionUserAll : String read FOptionUserAll write FOptionUserAll; //added by fduenas
    property OptionLevelLow : String read FOptionLevelLow write FOptionLevelLow; //added by fduenas
    property OptionLevelNormal : String read FOptionLevelNormal write FOptionLevelNormal; //added by fduenas
    property OptionLevelHigh : String read FOptionLevelHigh write FOptionLevelHigh; //added by fduenas
    property OptionLevelCritic : String read FOptionLevelCritic write FOptionLevelCritic; //added by fduenas
    property DeletePerformed : String read FDeletePerformed write FDeletePerformed; //added by fduenas
  end;

  TProfileUserFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelDescription, FColPerfil, FBtAdic, FBtAlt,
    FBtExc, FBtAcess {BGM}, FBtClose, FConfExc : String;
    FPromptDelete_WindowCaption: string; //added by fduenas
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent);override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelDescription : String read FLabelDescription write FLabelDescription;
    property ColProfile : String read FColPerfil write FColPerfil;
    property BtAdd : String read FBtAdic write FBtAdic;
    property BtChange : String read FBtAlt write FBtAlt;
    property BtDelete : String read FBtExc write FBtExc;
    property BtRights : String read FBtAcess write FBtAcess;    //BGM
    property PromptDelete : String read FConfExc write FConfExc;
    property PromptDelete_WindowCaption : String read FPromptDelete_WindowCaption write FPromptDelete_WindowCaption; //added by fduenas
    property BtClose : String read FBtClose write FBtClose;
  end;

  TAddUserFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelAdd,FLabelChange, FLabelNome, FLabelLogin, FLabelEmail, FCheckPriv, FBtSave, FBtCancelar, FLabelPerfil : String;
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelAdd : String read FLabelAdd write FLabelAdd;
    property LabelChange : String read FLabelChange write FLabelChange;
    property LabelName : String read FLabelNome write FLabelNome;
    property LabelLogin : String read FLabelLogin write FLabelLogin;
    property LabelEmail : String read FLabelEmail write FLabelEmail;
    property LabelPerfil : String read FLabelPerfil write FLabelPerfil;
    property CheckPrivileged : String read FCheckPriv write FCheckPriv;
    property BtSave : String read FBtSave write FBtSave;
    property BtCancel : String read FBtCancelar write FBtCancelar;

  end;

  TAddProfileFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelAdd,FLabelChange, FLabelName, FBtGravar, FBtCancel : String;
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelAdd : String read FLabelAdd write FLabelAdd;
    property LabelChange : String read FLabelChange write FLabelChange;
    property LabelName : String read FLabelName write FLabelName;
    property BtSave : String read FBtGravar write FBtGravar;
    property BtCancel : String read FBtCancel write FBtCancel;
  end;

  TPermissFormMSG = class(TPersistent)
  private
    FWindowCaption, FPageMenu, FPageActions, FBtUnlock, FBtLock, FBtGrava, FBtCancela : String;
    FLabelProfile: String;
    FLabelUser: String;
  protected
  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelUser : String read FLabelUser write FLabelUser;
    property LabelProfile : String read FLabelProfile write FLabelProfile;
    property PageMenu : String read FPageMenu write FPageMenu;
    property PageActions : String read FPageActions write FPageActions;
    property BtUnlock : String read FBtUnlock write FBtUnlock;
    property BtLock : String read FBtLock write FBtLock;
    property BtSave : String read FBtGrava write FBtGrava;
    property BtCancel : String read FBtCancela write FBtCancela;
  end;

  TTrocaSenhaFormMSG = class(TPersistent)
  private
    FWindowCaption, FLabelDescription, FLabelCurrentPassword, FLabelNewPassword, FLabelConfirm, FBtSave, FBtCancel : String;
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelDescription : String read FLabelDescription write FLabelDescription;
    property LabelCurrentPassword : String read FLabelCurrentPassword write FLabelCurrentPassword;
    property LabelNewPassword : String read FLabelNewPassword write FLabelNewPassword;
    property LabelConfirm : String read FLabelConfirm write FLabelConfirm;
    property BtSave : String read FBtSave write FBtSave;
    property BtCancel : String read FBtCancel write FBtCancel;
  end;

  TResetPassword = class(TPersistent)
  private
    FWindowCaption, FLabelPassword : String;
  protected

  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign( Source : TPersistent); override;
  published
    property WindowCaption : String read FWindowCaption write FWindowCaption;
    property LabelPassword : String read FLabelPassword write FLabelPassword;
  end;

  TUserSettings = class(TPersistent)
  private
    FUserCommomMSG : TUserCommonMSG;
    FLoginFormMSG : TLoginFormMSG;
    FCadUserFormMSG : TCadUserFormMSG;
    FAddUserFormMSG : TAddUserFormMSG;
    FPermissFormMSG : TPermissFormMSG;
    FTrocaSenhaFormMSG : TTrocaSenhaFormMSG;
    FResetPassword : TResetPassword;
    FProfileUserFormMSG: TProfileUserFormMSG;
    FAddProfileFormMSG: TAddProfileFormMSG;
    FLogControlFormMSG: TLogControlFormMSG;
    FAppMessagesMSG: TAppMessagesMSG;
    FUCXPSet: TUCXPSettings;
    FXPStyle: Boolean;
    FPosition: TPosition;
    procedure SetFResetPassword(const Value: TResetPassword);
    procedure SetFProfileUserFormMSG(const Value: TProfileUserFormMSG);
    procedure SetFAddProfileFormMSG(const Value: TAddProfileFormMSG);
    procedure SetFLogControlFormMSG(const Value: TLogControlFormMSG);
    procedure SetAppMessagesMSG(const Value: TAppMessagesMSG);
  protected
    procedure SetFUserCommonMsg( const Value : TUserCommonMSG);
    procedure SetFFormLoginMsg( const Value : TLoginFormMSG);
    procedure SetFCadUserFormMSG( const Value : TCadUserFormMSG);
    procedure SetFAddUserFormMSG(const Value : TAddUserFormMSG);
    procedure SetFPermissFormMSG(const Value : TPermissFormMSG);
    procedure SetFTrocaSenhaFormMSG(const Value : TTrocaSenhaFormMSG);
  public
    constructor Create(AOwner : TComponent);
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;

  published
    property AppMessages : TAppMessagesMSG read FAppMessagesMSG write SetAppMessagesMSG;  
    property CommonMessages : TUserCommonMSG read FUserCommomMSG write SetFUserCommonMSg;
    property Login : TLoginFormMSG      read FLoginFormMSG      write SetFFormLoginMsg;
    property Log :   TLogControlFormMSG read FLogControlFormMSG write SetFLogControlFormMSG;
    property UsersForm : TCadUserFormMSG read FCadUserFormMSG write SetFCadUserFormMSG;
    property AddChangeUser : TAddUserFormMSG read FAddUserFormMSG write SetFAddUserFormMSG;
    property AddChangeProfile : TAddProfileFormMSG read FAddProfileFormMSG write SetFAddProfileFormMSG;
    property UsersProfile : TProfileUserFormMSG read FProfileUserFormMSG write SetFProfileUserFormMSG;
    property Rights : TPermissFormMSG read FPermissFormMSG write SetFPermissFormMSG;
    property ChangePassword : TTrocaSenhaFormMSG read FTrocaSenhaFormMSG write SetFTrocaSenhaFormMSG;
    property ResetPassword : TResetPassword read FResetPassword write SetFResetPassword;
    property XPStyleSet : TUCXPSettings read FUCXPSet write FUCXPSet;
    property XPStyle : Boolean read FXPStyle write FXPStyle;
    property WindowsPosition : TPosition read FPosition write FPosition;
  end;




implementation


{ TUserSettings }

procedure TUserSettings.Assign(Source: TPersistent);
begin
  if Source is TUserSettings then
  begin
    Self.CommonMessages.Assign(TUserSettings(Source).CommonMessages);
  end else inherited;
end;

constructor TUserSettings.Create(AOwner: TComponent);
begin
  inherited Create;
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
  FUCXPSet := TUCXPSettings.Create(nil);
  FPosition := poMainFormCenter;
end;

destructor TUserSettings.Destroy;
begin
  // QmD 19/04/2005
  FreeAndNil(FAppMessagesMSG);
  FreeAndNil(FLoginFormMSG);
  FreeAndNil(FUserCommomMSG);
  FreeAndNil(FCadUserFormMSG);
  FreeAndNil(FAddUserFormMSG);
  FreeAndNil(FAddProfileFormMSG);
  FreeAndNil(FPermissFormMSG);
  FreeAndNil(FProfileUserFormMSG);
  FreeAndNil(FTrocaSenhaFormMSG);
  FreeAndNil(FResetPassword);
  FreeAndNil(FLogControlFormMSG);
  FreeAndNil(FUCXPSet);
  inherited;
end;

procedure TUserSettings.SetAppMessagesMSG(const Value: TAppMessagesMSG);
begin
  FAppMessagesMSG := Value;
end;

procedure TUserSettings.SetFAddProfileFormMSG(
  const Value: TAddProfileFormMSG);
begin
  FAddProfileFormMSG := Value;
end;

procedure TUserSettings.SetFAddUserFormMSG(const Value: TAddUserFormMSG);
begin
  AddChangeUser := Value;
end;

procedure TUserSettings.SetFCadUserFormMSG(const Value: TCadUserFormMSG);
begin
  UsersForm := Value;
end;

procedure TUserSettings.SetFFormLoginMsg(const Value: TLoginFormMSG);
begin
  Login := Value;
end;

procedure TUserSettings.SetFLogControlFormMSG(
  const Value: TLogControlFormMSG);
begin
  FLogControlFormMSG := Value;
end;



procedure TUserSettings.SetFPermissFormMSG(const Value: TPermissFormMSG);
begin
  Rights := Value;
end;

procedure TUserSettings.SetFProfileUserFormMSG(
  const Value: TProfileUserFormMSG);
begin
  FProfileUserFormMSG := Value;
end;

procedure TUserSettings.SetFResetPassword(const Value: TResetPassword);
begin
 FResetPassword := Value;
end;

procedure TUserSettings.SetFTrocaSenhaFormMSG(
  const Value: TTrocaSenhaFormMSG);
begin
  ChangePassword := Value;
end;

procedure TUserSettings.SetFUserCommonMsg(const value: TUserCommonMSG);
begin
  CommonMessages := Value;
end;

{ TUserCommonMSG }

procedure TUserCommonMSG.Assign(Source: TPersistent);
begin
  if Source is TUserCommonMSG then begin
    Self.BlankPassword :=  TUserCommonMSG(Source).BlankPassword;
    Self.PasswordChanged := TUserCommonMSG(Source).PasswordChanged;
    Self.InitialMessage := TUserCommonMSG(Source).InitialMessage;
    Self.InvalidLogin := TUserCommonMSG(Source).InvalidLogin;
    Self.MaxLoginAttemptsError := TUserCommonMSG(Source).MaxLoginAttemptsError;
    Self.ChangePasswordError := TUserCommonMSG(Source).ChangePasswordError;
  end else inherited;
end;

constructor TUserCommonMSG.Create(Aowner: TComponent);
begin
  inherited Create;
  ChangePasswordError := TChangePassError.Create(nil);
  FFirstMSG := TStringList.Create;
end;

destructor TUserCommonMSG.Destroy;
begin
  FreeAndNil(FChangePasswordError);
  FreeAndNil(FFirstMSG);
  inherited;
end;



procedure TUserCommonMSG.SetFErroTrocaSenha(const Value: TChangePassError);
begin
 FChangePasswordError := Value;
end;

procedure TUserCommonMSG.SetFFirstMSG(const Value: TStrings);
begin
  FFirstMSG.Assign(Value);
end;

{ TLoginFormMSG }

procedure TLoginFormMSG.Assign(Source: TPersistent);
begin
  if Source is TLoginFormMSG then begin
    with Source as TLoginFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelUser := LabelUser;
      Self.LabelPassword := LabelPassword;
      Self.BtOk := BtOK;
      Self.BtCancel := BtCancel;
    end;
  end else inherited;
end;

constructor TLoginFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
  FTopImage := TPicture.Create;
  FLeftImage := TPicture.Create;
  FBottomImage := TPicture.Create;
end;

destructor TLoginFormMSG.Destroy;
begin
  FreeAndNil(FTopImage);
  FreeAndNil(FLeftImage);
  FreeAndNil(FBottomImage);
  inherited;
end;

procedure TLoginFormMSG.SetFBottomImage(const Value: TPicture);
begin
  FBottomImage.Assign(Value);
end;

procedure TLoginFormMSG.SetFLeftImage(const Value: TPicture);
begin
  FLeftImage.Assign(Value);
end;

procedure TLoginFormMSG.SetFTopImage(const Value: TPicture);
begin
  FTopImage.Assign(Value);
end;

{ TCadUserFormMSG }

procedure TCadUserFormMSG.Assign(Source: TPersistent);
begin
  if Source is TCadUserFormMSG then begin
    with Source as TCadUserFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelDescription := LabelDescription;
      Self.ColName := ColName;
      Self.ColLogin := ColLogin;
      Self.ColEmail := ColEmail;
      Self.BtAdd := BtAdd;
      Self.BtChange := BtChange;
      Self.BtDelete := BtDelete;
      Self.BtRights := BtRights;
      Self.BtPassword := BtPassword;
      Self.BtClose := BtClose;
      Self.PromptDelete := PromptDelete;
      Self.PromptDelete_WindowCaption := PromptDelete_WindowCaption; //added by fduenas
    end;
  end else inherited;
end;

constructor TCadUserFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TCadUserFormMSG.Destroy;
begin
  inherited;
end;

{ TAddUserFormMSG }

procedure TAddUserFormMSG.Assign(Source: TPersistent);
begin
  if Source is TAddUserFormMSG then begin
    with Source as TAddUserFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelAdd := LabelAdd;
      Self.LabelChange := LabelChange;
      Self.LabelName := LabelName;
      Self.LabelLogin := LabelLogin;
      Self.LabelEmail := LabelEmail;
      Self.LabelPerfil := LabelPerfil;
      Self.CheckPrivileged := CheckPrivileged;
      Self.BtSave := BtSave;
      Self.BtCancel := BtCancel;
    end;
  end else inherited;
end;

constructor TAddUserFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TAddUserFormMSG.Destroy;
begin
  inherited;
end;

{ TPermissFormMSG }

procedure TPermissFormMSG.Assign(Source: TPersistent);
begin
  if Source is TPermissFormMSG then begin
    with Source as TPermissFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelUser := LabelUser;
      Self.LabelProfile := LabelProfile;
      Self.PageMenu := PageMenu;
      Self.PageActions := PageActions;
      Self.BtUnlock := BtUnlock;
      Self.BtLock := BtLock;
      Self.BtSave := BtSave;
      Self.BtCancel := BtCancel;
    end;
  end else inherited;
end;

constructor TPermissFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TPermissFormMSG.Destroy;
begin
  inherited;
end;

{ TTrocaSenhaFormMSG }

procedure TTrocaSenhaFormMSG.Assign(Source: TPersistent);
begin
  if Source is TTrocaSenhaFormMSG then begin
    with Source as TTrocaSenhaFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelDescription := LabelDescription;
      Self.LabelCurrentPassword := LabelCurrentPassword;
      Self.LabelNewPassword := LabelNewPassword;
      Self.LabelConfirm := LabelConfirm;
      Self.BtSave := BtSave;
      Self.BtCancel := BtCancel;
    end;
  end else inherited;
end;

constructor TTrocaSenhaFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TTrocaSenhaFormMSG.Destroy;
begin
  inherited;
end;

{ TChangePassError }

procedure TChangePassError.Assign(Source: TPersistent);
begin
  if Source is TChangePassError then begin
    with Source as TchangePassError do begin
      Self.InvalidCurrentPassword := InvalidCurrentPassword;
      Self.NewPasswordError := NewPasswordError;
      Self.NewEqualCurrent := NewEqualCurrent;
      Self.PasswordRequired := PasswordRequired;
      Self.MinPasswordLength := MinPasswordLength;
    end;
  end else inherited;

end;

constructor TChangePassError.Create(Aowner: TComponent);
begin
  inherited Create;
end;

destructor TChangePassError.Destroy;
begin
  inherited;
end;

{ TResetPassword }

procedure TResetPassword.Assign(Source: TPersistent);
begin
  if Source is TResetPassword then begin
    Self.WindowCaption :=  TResetPassword(Source).WindowCaption;
    Self.LabelPassword := TResetPassword(Source).LabelPassword;
  end else inherited;
end;

constructor TResetPassword.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TResetPassword.Destroy;
begin
  inherited;
end;

{ TProfileUserFormMSG }

procedure TProfileUserFormMSG.Assign(Source: TPersistent);
begin
  if Source is TProfileUserFormMSG then begin
    with Source as TProfileUserFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelDescription := LabelDescription;
      Self.ColProfile := ColProfile;
      Self.BtAdd := BtAdd;
      Self.BtChange := BtChange;
      Self.BtDelete := BtDelete;
      Self.BtRights := BtRights;   //BGM
      Self.BtClose := BtClose;
      Self.PromptDelete := PromptDelete;
      Self.PromptDelete_WindowCaption := PromptDelete_WindowCaption; //added by fduenas
    end;
  end else inherited;
end;

constructor TProfileUserFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TProfileUserFormMSG.Destroy;
begin
  inherited;
end;

{ TAddProfileFormMSG }

procedure TAddProfileFormMSG.Assign(Source: TPersistent);
begin
  if Source is TAddProfileFormMSG then begin
    with Source as TAddProfileFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelAdd := LabelAdd;
      Self.LabelChange := LabelChange;
      Self.LabelName := LabelName;
      Self.BtSave := BtSave;
      Self.BtCancel := BtCancel;
    end;
  end else inherited;
end;

constructor TAddProfileFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TAddProfileFormMSG.Destroy;
begin
  inherited;
end;

{ TLogControlFormMSG }

procedure TLogControlFormMSG.Assign(Source: TPersistent);
begin
  if Source is TLogControlFormMSG then begin
    with Source as TLogControlFormMSG do begin
      Self.WindowCaption := WindowCaption;
      Self.LabelDescription := LabelDescription;
      Self.LabelUser := LabelUser;
      Self.LabelDate := LabelDate;
      Self.LabelLevel := LabelLevel;
      Self.ColLevel := ColLevel;
      Self.ColMessage := ColMessage;
      Self.ColUser := ColUser;
      Self.ColDate := ColDate;
      Self.BtFilter := BtFilter;
      Self.BtDelete := BtDelete;
      Self.BtClose := BtClose;
      Self.PromptDelete := PromptDelete;
      Self.PromptDelete_WindowCaption := PromptDelete_WindowCaption; //added by fduenas
      Self.OptionUserAll := OptionUserAll; //added by fduenas
      Self.OptionLevelLow := OptionLevelLow; //added by fduenas
      Self.OptionLevelNormal := OptionLevelNormal; //added by fduenas
      Self.OptionLevelHigh := OptionLevelHigh; //added by fduenas
      Self.OptionLevelCritic := OptionLevelCritic; //added by fduenas
      Self.DeletePerformed := DeletePerformed; //added by fduenas
    end;
  end else inherited;
end;

constructor TLogControlFormMSG.Create(AOwner: TComponent);
begin
  inherited Create;
end;

destructor TLogControlFormMSG.Destroy;
begin

  inherited;
end;

{ TAppMessagesMSG }

procedure TAppMessagesMSG.Assign(Source: TPersistent);
begin
  if Source is TAppMessagesMSG then
  begin
    with Source as TAppMessagesMSG do
    begin
      Self.MsgsForm_BtNew :=  MsgsForm_BtNew;
      Self.MsgsForm_BtReplay := MsgsForm_BtReplay;
      Self.MsgsForm_BtForward := MsgsForm_BtForward;
      Self.MsgsForm_BtDelete := MsgsForm_BtDelete;
      Self.MsgsForm_WindowCaption := MsgsForm_WindowCaption;
      Self.MsgsForm_ColFrom := MsgsForm_ColFrom;
      Self.MsgsForm_ColSubject := MsgsForm_ColSubject;
      Self.MsgsForm_ColDate := MsgsForm_ColDate;
      Self.MsgsForm_PromptDelete := MsgsForm_PromptDelete;
      Self.MsgsForm_PromptDelete_WindowCaption := MsgsForm_PromptDelete_WindowCaption; //added by fduenas
      Self.MsgsForm_BtClose := MsgsForm_BtClose; //added by fduenas
      Self.MsgsForm_NoMessagesSelected := MsgsForm_NoMessagesSelected; //added by fduenas
      Self.MsgsForm_NoMessagesSelected_WindowCaption := MsgsForm_NoMessagesSelected_WindowCaption; //added by fduenas

      Self.MsgRec_BtClose := MsgRec_BtClose;
      Self.MsgRec_WindowCaption := MsgRec_WindowCaption;
      Self.MsgRec_Title := MsgRec_Title;
      Self.MsgRec_LabelFrom := MsgRec_LabelFrom;
      Self.MsgRec_LabelDate := MsgRec_LabelDate;
      Self.MsgRec_LabelSubject := MsgRec_LabelSubject;
      Self.MsgRec_LabelMessage := MsgRec_LabelMessage;

      Self.MsgSend_BtSend := MsgSend_BtSend;
      Self.MsgSend_BtCancel := MsgSend_BtCancel;
      Self.MsgSend_WindowCaption := MsgSend_WindowCaption;
      Self.MsgSend_Title := MsgSend_Title;
      Self.MsgSend_GroupTo := MsgSend_GroupTo;
      Self.MsgSend_RadioUser := MsgSend_RadioUser;
      Self.MsgSend_RadioAll := MsgSend_RadioAll;
      Self.MsgSend_GroupMessage := MsgSend_GroupMessage;
      Self.MsgSend_LabelSubject := MsgSend_LabelSubject;
      Self.MsgSend_LabelMessageText := MsgSend_LabelMessageText;
    end;
  end else inherited;
end;

constructor TAppMessagesMSG.Create(Aowner: TComponent);
begin
  inherited Create;
end;

destructor TAppMessagesMSG.Destroy;
begin
  inherited;
end;

end.
