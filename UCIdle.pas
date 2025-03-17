unit UCIdle;

interface

uses
  System.Classes, UCBase, Vcl.Dialogs, Winapi.Windows, Vcl.Forms,
  Vcl.ExtCtrls, Messages; //WM_TIMER ;

type

  TUCIdle = class(TComponent)
  private
    FTimeOut: Integer;
    FOnIdle: TNotifyEvent;
    FUserControl: TUserControl; //changed from FUCComp to FUserControl
    FOnAppMessage : TMessageEvent;
    FInternalTimer : TTimer;
    FChanged : Boolean;
    procedure UCAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure OnInternalTimer(Sender : TObject);
    procedure SetUserControl(const Value: TUserControl);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override; //added by fduenas
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoIdle;
//    procedure Create(AOwner: TComponent);override;
  published
    property UserControl : TUserControl read FUserControl write SetUserControl; //changed by fduenas
    property OnIdle : TNotifyEvent read FOnIdle write FOnIdle;
    property Timeout : Integer read FTimeOut write FTimeOut;
  end;


implementation

{ TUCIdle }

constructor TUCIdle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TUCIdle.DoIdle;
begin
  if Assigned(UserControl) and (UserControl.CurrentUser.UserID <> 0 ) then
    UserControl.Logoff;
  if Assigned(OnIdle) then OnIdle(Self);
end;

procedure TUCIdle.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    if (Assigned(UserControl)) or (Assigned(OnIdle))then
    begin
      if Assigned(Application.OnMessage) then FOnAppMessage := Application.OnMessage;
      Application.OnMessage := UCAppMessage;
      FInternalTimer := TTimer.Create(self);
      FInternalTimer.Enabled := False;
      FInternalTimer.Interval := Timeout;
      FInternalTimer.OnTimer := OnInternalTimer;
      FInternalTimer.Enabled := True;
    end;
end;

procedure TUCIdle.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  If AOperation = opRemove then
     If AComponent = FUserControl then
        FUserControl := nil;
  inherited Notification(AComponent, AOperation) ;

end;

procedure TUCIdle.OnInternalTimer(Sender: TObject);
begin
  if not FChanged then DoIdle
  else FChanged := False;
end;

procedure TUCIdle.SetUserControl(const Value: TUserControl);
begin
  FUserControl := Value;
  if Value <> nil then
     Value.FreeNotification(self);
end;                     

procedure TUCIdle.UCAppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (msg.message = wm_mousemove) or (msg.message = wm_keydown) then FChanged := True;
//  FChanged := (msg.message = wm_mousemove) or (msg.message = wm_keydown);
  if Assigned(FOnAppMessage) then FOnAppMessage(Msg, Handled);
end;

end.
