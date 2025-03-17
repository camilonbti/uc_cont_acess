unit UCObjSel_U;

interface

uses

  Winapi.Windows, Messages, Vcl.ExtCtrls, System.SysUtils,  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  vcl.Buttons, Vcl.ComCtrls, Vcl.Menus, UCBase, Data.DB, UCConsts,
  vcl.ActnList, UCXPStyle, System.Variants;

type
  TQControl = class(TControl)
  published
    property Caption;
  end;

  TUCObjSel = class(TForm)
    DispList: TListView;
    SelList: TListView;
    Panel1: TPanel;
    lbForm: TLabel;
    Image1: TImage;
    lbTitle: TLabel;
    lbCompDisp: TLabel;
    lbCompSel: TLabel;
    btsellall: TSpeedButton;
    btsel: TSpeedButton;
    btunsel: TSpeedButton;
    btunselall: TSpeedButton;
    BtOK: TBitBtn;
    btCancel: TBitBtn;
    lbGrupo: TLabel;
    lbGroup: TLabel;
    cbFilter: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btsellallClick(Sender: TObject);
    procedure btunselallClick(Sender: TObject);
    procedure btselClick(Sender: TObject);
    procedure btunselClick(Sender: TObject);
    procedure DispListDblClick(Sender: TObject);
    procedure SelListDblClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure BtOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbFilterClick(Sender: TObject);
    procedure cbFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FListButtons, FListLabelEdits : TStringList;
    procedure MakeDispItems;
  public
    FForm : TCustomForm;
    FUCComp : TUserControl;
    FInitialObjs : TStringList;
  end;

var
  UCObjSel: TUCObjSel;

implementation

{$R *.dfm}

procedure TUCObjSel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TUCObjSel.FormShow(Sender: TObject);
begin
  lbForm.Left := lbTitle.Left+lbTitle.Width+10; //added by fduenas to
                                                //adjust window name
  lbgroup.Left := lbGrupo.Left+lbGrupo.Width+10; //added by fduenas to
                                                //adjust window name
  lbForm.Caption := FForm.Name;
  FInitialObjs.Text := UpperCase(FInitialObjs.Text);
  SelList.Items.Clear;
  MakeDispItems;
end;

procedure TUCObjSel.MakeDispItems;
var
  FObj : TComponent;
  FClasse : String;
  Contador : Integer;
begin
  DispList.Items.Clear;
  for Contador := 0 to Pred(FForm.ComponentCount) do
  begin
    FObj := FForm.Components[Contador];
    FClasse := UpperCase(FObj.ClassName);
    if (FObj is TControl) or (FObj is TMenuItem) or (FObj is TField) or (FObj is TAction)then
    begin
      if  (cbFilter.ItemIndex <= 0) or
          ((cbFilter.ItemIndex = 1) and (FListButtons.IndexOf(FClasse) > -1)) or
          ((cbFilter.ItemIndex = 2) and (FObj is TField)) or
          ((cbFilter.ItemIndex = 3) and (FListLabelEdits.IndexOf(FClasse) > -1)) or
          ((cbFilter.ItemIndex = 4) and (FObj is TMenuItem)) then
        if FInitialObjs.IndexOf(UpperCase(FObj.Name)) = -1 then
          with DispList.Items.Add do
          begin
            Caption := FObj.ClassName;
            SubItems.Add(FObj.Name);
            if FObj is TMenuItem then SubItems.Add(StringReplace(TMenuItem(FObj).Caption,'&','',[rfReplaceAll]))
            else if FObj is TAction then SubItems.Add(StringReplace(TAction(FObj).Caption,'&','',[rfReplaceAll]))
            else if FObj is TField then SubItems.Add(TField(FObj).DisplayName)
            else SubItems.Add(StringReplace(TQControl(FForm.Components[Contador]).Caption,'&','',[rfReplaceAll]));
          end;
    end;
  end;
end;

procedure TUCObjSel.btsellallClick(Sender: TObject);
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(DispList.Items.Count) do
  begin
    FInitialObjs.Add(DispList.Items[Contador].SubItems[0]);
    with SelList.Items.Add do
    begin
      Caption := DispList.Items[Contador].SubItems[1];
      SubItems.Add(DispList.Items[Contador].SubItems[0]);
      SubItems.Add(DispList.Items[Contador].Caption);
    end;
  end;
  DispList.Items.Clear;
end;

procedure TUCObjSel.btunselallClick(Sender: TObject);
begin
  SelList.Items.Clear;
  FInitialObjs.Clear;
  MakeDispItems;
end;

procedure TUCObjSel.btselClick(Sender: TObject);
var
  Contador : Integer;
begin
  for Contador := 0 to DispList.Items.Count -1 do
    if DispList.Items.Item[Contador].Selected then
    begin
      FInitialObjs.Add(DispList.Items[Contador].SubItems[0]);
      with SelList.Items.Add do
      begin
        Caption := DispList.Items[Contador].SubItems[1];
        SubItems.Add(DispList.Items[Contador].SubItems[0]);
        SubItems.Add(DispList.Items[Contador].Caption);
      end;
    end;

  Contador := 0;
  while Contador <= Pred(DispList.Items.Count) do
  begin
    if DispList.Items[Contador].Selected then
      DispList.Items[Contador].Delete
    else Inc(Contador);
  end;
end;

procedure TUCObjSel.btunselClick(Sender: TObject);
var
  Contador : Integer;
  Obj : TComponent;
begin
  if SelList.SelCount = 0 then Exit;
  for Contador := 0 to Pred(SelList.Items.Count) do
    if SelList.Items.Item[Contador].Selected then
    begin
      if FInitialObjs.IndexOf(DispList.Items[Contador].SubItems[0]) > -1 then
        FInitialObjs.Delete(FInitialObjs.IndexOf(DispList.Items[Contador].SubItems[0]));
      if SelList.Items[Contador].SubItems.Count > 1 then
        with DispList.Items.Add do
        begin
          if SelList.Items[Contador].SubItems.Count > 1 then
            Caption := SelList.Items[Contador].SubItems[1];
          SubItems.Add(SelList.Items[Contador].SubItems[0]);

          Obj := FForm.FindComponent(SelList.Items[Contador].SubItems[0]);
          if Obj is TMenuItem then SubItems.Add(TMenuItem(Obj).Caption)
          else if Obj is TAction then SubItems.Add(TMenuItem(Obj).Caption)
          else if Obj is TField then SubItems.Add(TField(Obj).DisplayName)
          else SubItems.Add(TQControl(Obj).Caption);
        end;
    end;

  Contador := 0;
  while Contador <= Pred(SelList.Items.Count) do
  begin
    if SelList.Items[Contador].Selected then
      SelList.Items[Contador].Delete
    else Inc(Contador);
  end;
end;

procedure TUCObjSel.DispListDblClick(Sender: TObject);
begin
  btsel.Click;
end;

procedure TUCObjSel.SelListDblClick(Sender: TObject);
begin
//  btunsel.Click;
  if Sellist.Items.Count = 0 then Exit;
  if SelList.SelCount = 1 then Sellist.Selected.EditCaption;
end;

procedure TUCObjSel.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TUCObjSel.BtOKClick(Sender: TObject);
var
  Contador : Integer;
begin
  if FUCComp.ExtraRight.Count > 0 then
  begin
    Contador := 0;
    while Contador <= Pred(FUCComp.ExtraRight.Count) do
    begin
      if UpperCase(FUCComp.ExtraRight[Contador].FormName) = UpperCase(FForm.Name) then
        FUCComp.ExtraRight.Delete(Contador)
      else
        Inc(Contador);
    end;
  end;

  for Contador := 0 to Pred(SelList.Items.Count) do
    with FUCComp.ExtraRight.Add do
    begin
      Caption := SelList.Items[Contador].Caption;
      CompName := SelList.Items[Contador].SubItems[0];
      FormName := FForm.Name;
      GroupName := lbGroup.Caption;
    end;
  Close;
end;

procedure TUCObjSel.FormActivate(Sender: TObject);
var
  Contador : Integer;
begin
  for Contador := 0 to Pred(FUCComp.ExtraRight.Count) do
    if UpperCase(FUCComp.ExtraRight[Contador].FormName) = UpperCase(FForm.Name) then
      if FForm.FindComponent(FUCComp.ExtraRight[Contador].CompName) <> nil then
        with SelList.Items.Add do
        begin
          Caption := FUCComp.ExtraRight[Contador].Caption;
          SubItems.Add(FUCComp.ExtraRight[Contador].CompName);
          if FForm.FindComponent(FUCComp.ExtraRight[Contador].CompName) <> nil then
            SubItems.Add(FForm.FindComponent(FUCComp.ExtraRight[Contador].CompName).ClassName);
        end;
end;

procedure TUCObjSel.FormCreate(Sender: TObject);
begin
  cbFilter.ItemIndex := 0;
  FListButtons := TStringList.Create;
  FListButtons.CommaText := 'TButton,TSpeedButton,TBitBtn,TRxSpeedButton,TRxSpinButton,TRxSwitch,'+
                            'TLMDButton,TLMDMMButton,TLMDShapeButton,TLMD3DEffectButton,TLMDWndButtonShape,'+
                            'TJvHTButton,TJvBitBtn,TJvImgBtn,TJvArrowButton,TJvTransparentButton,TJvTransparentButton2,TJvSpeedButton';
  FListButtons.Text := UpperCase(FListButtons.Text);
  FListLabelEdits := TStringList.Create;
  FListLabelEdits.CommaText := 'TEdit,TLabel,TStaticText,TLabeledEdit,TRxLabel,TComboEdit,TFileNameEdit,TDirectoryEdit,'+
                               'TDateEdit,TDateTimePicker,TRxCalcEdit,TCurrencyEdit,TRxSpinEdit'; // lazy for continue... :P
  FListLabelEdits.Text := UpperCase(FListLabelEdits.Text);

  lbTitle.Caption := Const_Contr_TitleLabel;
  lbGrupo.Caption := Const_Contr_GroupLabel;
  lbCompDisp.Caption := Const_Contr_CompDispLabel;
  lbCompSel.Caption := Const_Contr_CompSelLabel;
  SelList.Columns[0].Caption := Const_Contr_DescCol;
  btCancel.Caption := Const_Contr_BTCancel;
  BtOK.Caption := Const_Contr_BtOK;

  //Lines Bellow added by fduenas
  btSellAll.Hint := Const_Contr_BtSellAllHint;
  btSel.Hint := Const_Contr_BtSelHint;
  btUnSel.Hint := Const_Contr_BtUnSelHint;
  btUnSelAll.Hint := Const_Contr_BtUnSelAllHint;
  //
end;

procedure TUCObjSel.cbFilterClick(Sender: TObject);
begin
  MakeDispItems;
end;

procedure TUCObjSel.cbFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MakeDispItems;
end;

end.
