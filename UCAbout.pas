unit UCAbout;

interface

uses

  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ShellAPI, vcl.Buttons, System.Variants, jpeg;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label10: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    Panel3: TPanel;
    Label9: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MemoAgrd: TMemo;
    Label1: TLabel;
    Image3: TImage;
    Label12: TLabel;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label4Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  ShellExecute(0,'open','mailto:qmd@usercontrol.com.br','','',sw_show);
end;

procedure TAboutForm.Label6Click(Sender: TObject);
begin
  ShellExecute(0,'open','http://usercontrol.com.br','','',sw_show);
end;

procedure TAboutForm.Image2Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://delphiland.dyns.cx', nil,nil, sw_show);
end;

procedure TAboutForm.Image3Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.curitiba.pr.gov.br/', nil,nil, sw_show);
end;

procedure TAboutForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.
