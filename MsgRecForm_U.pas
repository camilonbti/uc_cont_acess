unit MsgRecForm_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vcl.Buttons, Vcl.ExtCtrls,
  UCBase, System.Variants, UCXPStyle; //modified by fduenas

type
  TMsgRecForm = class(TForm)
    Panel1: TPanel;
    lbTitulo: TLabel;
    Image1: TImage;
    lbDE: TLabel;
    stDe: TStaticText;
    lbAssunto: TLabel;
    stAssunto: TStaticText;
    lbMensagem: TLabel;
    MemoMsg: TMemo;
    btFechar: TBitBtn;
    lbData: TLabel;
    stData: TStaticText;
    procedure btFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject); //added by fduenas
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MsgRecForm: TMsgRecForm;

implementation

uses UCMessages;

{$R *.dfm}

procedure TMsgRecForm.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TMsgRecForm.FormCreate(Sender: TObject);
begin
 //added by fduenas
 if not (Self.Owner is TUCAppMessage) then
    exit;
 with TUCAppMessage(Self.Owner).UserControl.Settings.AppMessages do
 begin
  Self.Caption := MsgRec_WindowCaption;
  lbTitulo.Caption := MsgRec_Title;
  lbDE.Caption := MsgRec_LabelFrom;
  lbData.Caption := MsgRec_LabelDate;
  lbAssunto.Caption := MsgRec_LabelSubject;
  lbMensagem.Caption := MsgRec_LabelMessage;
  btFechar.Caption := MsgRec_BtClose;
 end;
end;

end.
