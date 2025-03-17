unit MsgsForm_U;

interface

uses
  System.Variants, Winapi.Windows, Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  Vcl.ComCtrls, vcl.ToolWin, Vcl.StdCtrls, Vcl.ExtCtrls, UCXPStyle, System.ImageList,
  Vcl.ImgList;

type
  TPointMsg = ^PointMsg;
  PointMsg = record
    IdMsg : Integer;
    Msg : String;
  end;


  TMsgsForm = class(TForm)
    ImageList1: TImageList;
    ListView1: TListView;
    ToolBar1: TToolBar;
    btnova: TToolButton;
    ImageList2: TImageList;
    btResponder: TToolButton;
    btEncaminhar: TToolButton;
    btExcluir: TToolButton;
    Splitter1: TSplitter;
    btFechar: TToolButton;
    MemoMsg: TMemo;
    procedure btFecharClick(Sender: TObject);
    procedure btnovaClick(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1DblClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btEncaminharClick(Sender: TObject);
    procedure btResponderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FColuna : Integer;
    FAsc : Boolean;
    procedure MontaTela;
  public
    DSMsgs, DSUsuarios : TDataset;
  end;

var
  MsgsForm: TMsgsForm;

implementation

uses EnvMsgForm_U, MsgRecForm_U, UCBase;



{$R *.dfm}

procedure TMsgsForm.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TMsgsForm.btnovaClick(Sender: TObject);
begin
  EnvMsgForm := TEnvMsgForm.Create(Self.Owner);
  EnvMsgForm.DataSource1.DataSet := DSUsuarios;
  
  

  EnvMsgForm.Showmodal;
  FreeAndNil(EnvMsgForm);
end;

function FmtDtHr(dt : String) : String;
begin
  Result := Copy(dt,7,2)+'/'+Copy(dt,5,2)+'/'+Copy(dt,1,4)+' '+Copy(dt,9,2)+':'+Copy(dt,11,2);
end;

procedure TMsgsForm.MontaTela;

var
  TempPoint : TPointMsg;
begin
 DSMsgs.Open;
 while not DSMsgs.Eof do
 begin
   with ListView1.Items.Add do
   begin
     ImageIndex := -1;
     StateIndex := -1;
     Caption := DSMsgs.FieldByName('de').asString;
     SubItems.Add(DSMsgs.fieldbyname('Subject').asString);
     SubItems.Add(FmtDtHr(DSMsgs.fieldbyname('DtSend').asString));
     New(TempPoint);
     TempPoint.IdMsg := DSMsgs.fieldbyname('idMsg').asInteger;
     TempPoint.Msg := DSMsgs.fieldbyname('Msg').asString;
     Data := TempPoint;
   end;
   DSMsgs.Next;
{$IFDEF VER130}
  ListView1.Selected := nil;
{$ELSE}
   ListView1.ItemIndex :=0;
{$ENDIF}

 end;
 DSMsgs.Close;
end;

procedure TMsgsForm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ListView1.SelCount > 1 then
  begin
    btResponder.Enabled := False;
    btEncaminhar.Enabled := False;
  end else begin
    btResponder.Enabled := True;
    btEncaminhar.Enabled := True;
  end;
  MemoMsg.Text := TPointMsg(Item.Data).Msg;
end;

procedure TMsgsForm.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if FColuna = Column.Index then
  begin
    FAsc := not FAsc;
    ListView1.Columns[FColuna].ImageIndex := Integer(FAsc);
  end
  else
  begin
    ListView1.Columns[FColuna].ImageIndex := -1;
    FColuna := Column.Index;
    FAsc := True;
    ListView1.Columns[FColuna].ImageIndex := Integer(FAsc);
  end;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TMsgsForm.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if FColuna = 0 then
  begin
    if FAsc then Compare := CompareText(Item1.Caption,Item2.Caption)
    else Compare := CompareText(Item2.Caption,Item1.Caption)
  end
  else
  begin
   ix := FColuna - 1;
   if FAsc then Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix])
   else Compare := CompareText(Item2.SubItems[ix],Item1.SubItems[ix]);
  end;

end;

procedure TMsgsForm.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected = nil then
     exit; //added to prevent AV error {fduenas}
  MsgRecForm := TMsgRecForm.Create(Self.Owner); //midifed by fduenas

  MsgRecForm.MemoMsg.Text := TPointMsg(ListView1.Selected.Data).Msg;
  MsgRecForm.stDe.Caption := ListView1.Selected.Caption;
  MsgRecForm.stAssunto.Caption := ListView1.Selected.SubItems[0];
  MsgRecForm.stData.Caption := ListView1.Selected.SubItems[1];


  MsgRecForm.ShowModal;
  FreeAndNil(MsgRecForm);

end;

procedure TMsgsForm.btExcluirClick(Sender: TObject);
var
  contador : integer;
begin
{$IFDEF VER130}
  if ListView1.Selected = nil then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mbOK);
    Exit;
  end;

{$ELSE}
  if ListView1.ItemIndex = -1 then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mb_OK);
    Exit;
  end;
{$ENDIF}

  if ListView1.SelCount = 1 then
  begin
   TUCAppMessage(Owner).DeleteAppMessage(TPointMsg(ListView1.Selected.Data).idMsg);
   {$IFDEF VER130}
     ListView1.Selected.Delete;
   {$ELSE}
     ListView1.DeleteSelected;
   {$ENDIF}
  end
  else begin
   for contador := 0 to LIstView1.Items.Count -1 do
     if ListView1.items[contador].selected then TUCAppMessage(Owner).DeleteAppMessage(TPointMsg(ListView1.items[contador].Data).idMsg);
   {$IFDEF VER130}
     ListView1.Selected.Delete;
   {$ELSE}
     ListView1.DeleteSelected;
   {$ENDIF}
  end;

end;

procedure TMsgsForm.btEncaminharClick(Sender: TObject);
var
  contador : integer;
begin
{$IFDEF VER130}
  if ListView1.Selected = nil then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mb_OK);
    Exit;
  end;

{$ELSE}
  if ListView1.ItemIndex = -1 then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mb_OK);
    Exit;
  end;
{$ENDIF}
  try
    EnvMsgForm := TEnvMsgForm.Create(Self.Owner);
    EnvMsgForm.DataSource1.DataSet := DSUsuarios;
    if EnvMsgForm.dbUsuario.Text <> '' then EnvMsgForm.dbUsuario.Enabled := False;
    EnvMsgForm.EditAssunto.Text := Copy('Enc: '+ ListView1.Selected.SubItems[0],1, EnvMsgForm.EditAssunto.MaxLength) ;
    EnvMsgForm.MemoMsg.Text := TPointMsg(ListView1.Selected.Data).Msg;
    for contador := 0 to EnvMsgForm.MemoMsg.Lines.Count -1 do
      EnvMsgForm.MemoMsg.Lines[contador] := '>'+ EnvMsgForm.MemoMsg.Lines[contador];
    EnvMsgForm.MemoMsg.Lines.Insert(0,ListView1.Selected.Caption + ' '+ ListView1.Selected.SubItems[1]);
    EnvMsgForm.MemoMsg.Text := Copy(EnvMsgForm.MemoMsg.Text,1,EnvMsgForm.MemoMsg.MaxLength);
    
    
    EnvMsgForm.Showmodal;
  finally
    FreeAndNil(EnvMsgForm);
  end;
end;

procedure TMsgsForm.btResponderClick(Sender: TObject);
begin
{$IFDEF VER130}
  if ListView1.Selected = nil then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mbOK);
    Exit;
  end;

{$ELSE}
  if ListView1.ItemIndex = -1 then
  begin
    //Modfied by fduenas
    MessageBox(Handle, PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected),
               PChar(TUCAppMessage(Owner).UserControl.Settings.AppMessages.MsgsForm_NoMessagesSelected_WindowCaption),
               MB_ICONINFORMATION or mb_OK);
    Exit;
  end;
{$ENDIF}
  try
    EnvMsgForm := TEnvMsgForm.Create(Self.Owner);
    EnvMsgForm.rbUsuario.Checked := True;
    EnvMsgForm.rbTodos.Enabled := False;
    DSMsgs.Open;
    DSMsgs.Locate('idMsg',TPointMsg(ListView1.Selected.Data).idMsg,[]);
    EnvMsgForm.DataSource1.DataSet := DSUsuarios;
    EnvMsgForm.dbUsuario.KeyValue := DSMsgs.fieldbyname('UsrFrom').asInteger;
    if EnvMsgForm.dbUsuario.Text <> '' then EnvMsgForm.dbUsuario.Enabled := False;
    EnvMsgForm.EditAssunto.Text := Copy('Re: '+ ListView1.Selected.SubItems[0],1, EnvMsgForm.EditAssunto.MaxLength) ;
    
    
    EnvMsgForm.Showmodal;
  finally
    DSMsgs.Close;
    FreeAndNil(EnvMsgForm);
  end;
end;

procedure TMsgsForm.FormShow(Sender: TObject);
begin
  MontaTela;
end;

end.
