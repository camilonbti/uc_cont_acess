unit UCEMailForm_U;

interface

uses

  Winapi.Windows, Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, System.Variants, Vcl.Dialogs, Vcl.StdCtrls,
  vcl.ExtCtrls;

type
  TUCEMailForm = class(TForm)
    Panel1: TPanel;
    img: TImage;
    lbStatus: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UCEMailForm: TUCEMailForm;

implementation

{$R *.dfm}

end.
