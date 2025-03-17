unit UCEditorForm_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vcl.Buttons,
  Vcl.ComCtrls, Vcl.ExtCtrls, UCBase, jpeg, ShellAPI;

type
  TUCEditorForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image5: TImage;
    lbComponente: TLabel;
    Panel3: TPanel;
    PageControl: TPageControl;
    TabPrincipal: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MenuCadUser: TComboBox;
    ActionCadUser: TComboBox;
    MenuCadPerf: TComboBox;
    ActionCadPerf: TComboBox;
    MenuTrocaSenha: TComboBox;
    ActionTrocaSenha: TComboBox;
    EditID: TEdit;
    cbDatabase: TComboBox;
    TabelaUsuarios: TEdit;
    TabelaPerm: TEdit;
    TabelaPermEX: TEdit;
    ckAutoStart: TCheckBox;
    ckXP: TCheckBox;
    TabLogin: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    SpeedButton1: TSpeedButton;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit9: TEdit;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit10: TEdit;
    cbExtractUser: TComboBox;
    TabLog: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    Panel4: TPanel;
    Image4: TImage;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Edit11: TEdit;
    CheckBox4: TCheckBox;
    MenuLog: TComboBox;
    ActionLog: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    TabLink: TTabSheet;
    Panel5: TPanel;
    Label27: TLabel;
    oxio: TImage;
    speedcase: TImage;
    softw: TImage;
    Panel6: TPanel;
    Image1: TImage;
    Panel7: TPanel;
    Image6: TImage;
    Panel8: TPanel;
    Image7: TImage;
    procedure TabelaPermChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure softwClick(Sender: TObject);
  private
    { Private declarations }
  public
    FUCComponent : TUserControl;
    FForm : String;
    FIUC : IOTAComponent;
  end;

var
  UCEditorForm: TUCEditorForm;

implementation



{$R *.dfm}

procedure TUCEditorForm.TabelaPermChange(Sender: TObject);
begin
  TabelaPermEX.Text := TabelaPerm.Text + 'EX';
end;

procedure TUCEditorForm.FormCreate(Sender: TObject);
begin
  cbExtractUser.ItemIndex := 0;
  PageControl.ActivePage := TabPrincipal;
end;

procedure TUCEditorForm.softwClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar('http://usercontrol.sourceforge.net/uclinkz.php?link=' + TComponent(Sender).Name + '&componente='+ lbComponente.Caption),nil,nil,sw_show);
end;

end.
