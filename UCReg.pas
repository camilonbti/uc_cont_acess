unit UCReg;

interface

uses
  UCBase, ToolsAPI, System.Classes, TypInfo, Vcl.Controls,
  DesignIntf, DesignEditors;

type
  TUCComponentsVarProperty = class( TStringProperty )
     function GetAttributes: TPropertyAttributes; override;
     procedure Edit; override;
     function GetValue:String;override;
  end;


  TUCControlsEditor = class(TComponentEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


  TUCAboutVarProperty = class( TStringProperty )
     function GetAttributes: TPropertyAttributes; override;
     procedure Edit; override;
     function GetValue:String;override;
  end;

  TUCAboutXpStyleVarProperty = class( TStringProperty )
     function GetAttributes: TPropertyAttributes; override;
     procedure Edit; override;
     function GetValue:String;override;
  end;


procedure Register;
procedure ShowControlsEditor( Componente : TUCControls);


implementation

uses
{$IFDEF VER130}
{$ELSE}
  UCMail,
{$ENDIF}
  UCXPStyle, UCADOConn, UCObjSel_U, UCAbout, UCIdle, UCDBXConn, 
  System.SysUtils, Vcl.Forms, Vcl.Dialogs, UCIBXConn, UCBDEConn, UCAboutXpStyle_U;

{ TUCComponentsVarProperty }
procedure TUCComponentsVarProperty.Edit;
begin
  ShowControlsEditor(TUCControls(GetComponent(0)));
end;

function TUCComponentsVarProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TUCComponentsVarProperty.GetValue: String;
begin
  result:='Components...';
end;

{TUCControlsEditor}
procedure TUCControlsEditor.Edit;
begin
  ShowControlsEditor(TUCControls(Component));
end;

procedure TUCControlsEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TUCControlsEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Select Components...';
end;

function TUCControlsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ TUCAboutVarProperty }

procedure TUCAboutVarProperty.Edit;
begin
  with TAboutForm.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

function TUCAboutVarProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TUCAboutVarProperty.GetValue: String;
begin
  result:='About...';
end;

procedure Register;
begin
  RegisterComponents('UC Main', [TUserControl, TUCSettings, TUCControls, TUCXPStyle, TUCAppMessage, TUCIdle]);
  RegisterComponents('UC Connectors', [TUCADOConn, TUCIBXConn, TUCBDEConn, TUCDBXConn]);
{$IFDEF VER130}
{$ELSE}
  RegisterComponents('UC Main', [TMailUserControl]);
{$ENDIF}

  RegisterPropertyEditor( TypeInfo( TUCAboutVar ), nil, '', TUCAboutVarProperty );
  RegisterPropertyEditor( TypeInfo( TUCAboutXpStyleVar ), nil, '', TUCAboutXpStyleVarProperty );
  RegisterPropertyEditor( TypeInfo( TUCComponentsVar ), nil, '', TUCComponentsVarProperty );
  RegisterComponentEditor(TUCcontrols, TUCControlsEditor);

end;

procedure ShowControlsEditor( Componente : TUCControls);
var
  FUCControl : TUCControls;
  FEditor : IOTAEditor;
  FModulo : IOTAModule;
  FFormEditor : IOTAFormEditor;
  i : integer;
begin
  FUCControl := Componente;
  if not Assigned(FUCControl.UserControl) then
  begin
    MessageDlg('UserControl Property must be informed and component must be '+#13+#10+'displayed!', mtInformation, [mbOK], 0);
    Exit;
  end;
  with TUCObjSel.Create(nil) do
  begin
    FForm := TCustomForm(FUCControl.Owner);
    FUCComp := FUCControl.UserControl;
    FInitialObjs := TStringList.Create;
    TUCControls(Componente).ListComponents(FForm.Name, FInitialObjs);
    lbGroup.Caption := TUCControls(Componente).GroupName;
    ShowModal;
    Free;
  end;

  FModulo :=  (BorlandIDEServices as IOTAModuleServices).FindFormModule(FUCControl.UserControl.Owner.Name);
  if FModulo = nil then
  begin
    Showmessage('Modulo '+FUCControl.UserControl.Owner.Name+' nao encontrado!');
    Exit;
  end else begin
    for i := 0 to FModulo.GetModuleFileCount - 1 do
    begin
      FEditor := FModulo.GetModuleFileEditor(i);
      FEditor.QueryInterface(IOTAFormEditor, FFormEditor);
      if FFormEditor <> nil then
      begin
        FFormEditor.MarkModified;
        Break;
      end;
    end;
  end;
end;



{ TUCAboutXpStyleVarProperty }
procedure TUCAboutXpStyleVarProperty.Edit;
begin
  with TUCAboutXpStyle.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

function TUCAboutXpStyleVarProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TUCAboutXpStyleVarProperty.GetValue: String;
begin
  result:='About...';
end;

end.
