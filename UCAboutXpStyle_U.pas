unit UCAboutXpStyle_U;

interface

uses
  Winapi.Windows, Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Jpeg, Vcl.ExtCtrls, Vcl.StdCtrls, ShellApi, vcl.Buttons;

type
  TUCAboutXpStyle = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    procedure Label3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TUCAboutXpStyle.Label3Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'mailto:khaled@shagrouni.com', nil, nil, sw_show);
end;

procedure TUCAboutXpStyle.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TUCAboutXpStyle.Label4Click(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.shagrouni.com/english/software/xpmenu.html', nil, nil, sw_show);
end;

end.
