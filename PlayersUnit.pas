{$J+}//assignable constants
unit PlayersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TPlayersForm = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lblAttr: TLabel;
    edName: TEdit;
    edPath: TEdit;
    SpeedButton3: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure SpeedButton3Click(Sender: TObject);
    procedure edPathExit(Sender: TObject);
  private
    procedure SetInComboFlag;
    procedure UpdateAttrAndItem;
  public
    procedure SetCheckboxes;
  end;

var
  PlayersForm: TPlayersForm;

type
  TPlayerInfo = class
  private
    OrigPath: string;
  public
    Name: string;
    ExeName: string;
    Path: string;
    InCombo: boolean;
    New: boolean;
    Correct: boolean;
    function IsModified: boolean;
    constructor Create; overload;
    constructor Create(strings: TStrings); overload;
  end;

var
  Players: TList;
  ProgramFiles32Dir: string;
  ProgramFiles64Dir: string;
  strCSIDL_LOCAL_APPDATA: string;

function AppPath(): string;
function AppDir(): string;

implementation

{$R *.dfm}

{ TPlayerInfo }
function AppPath(): string;
begin
  result := GetModuleName(0);
end;

function AppDir(): string;
begin
  result := ExtractFilePath(GetModuleName(0));
end;

constructor TPlayerInfo.Create;
begin
end;

constructor TPlayerInfo.Create(strings: TStrings);
var
  n: integer;
  dir1,dir2: string;
begin
  if (strings.Count<>2) and (strings.Count<>4) then raise Exception.Create('Bad file Players.dat!');
  Name:=strings[0];
  if strings.Count=2 then
    ExeName:=strings[1]
  else
  begin
    dir1:=strings[1];
    dir2:=strings[2];
    ExeName:=strings[3];
    if dir1='ProgramFiles32Dir' then dir1:=ProgramFiles32Dir
    else if dir1='ProgramFiles64Dir' then dir1:=ProgramFiles64Dir
    else if dir1='CSIDL_LOCAL_APPDATA' then dir1:=strCSIDL_LOCAL_APPDATA;
    Path:=dir1+dir2+ExeName;
  end;
  OrigPath := Path;
end;

function TPlayerInfo.IsModified: boolean;
begin
  result:=not SameFileName(Path, OrigPath);
end;

procedure TPlayersForm.Button1Click(Sender: TObject);
begin
  SetInComboFlag;
end;

procedure TPlayersForm.edPathExit(Sender: TObject);
begin
  UpdateAttrAndItem;
end;

procedure TPlayersForm.FormCreate(Sender: TObject);
var
  i: integer;
  pi: TPlayerInfo;
  item: TListItem;
  sAttr: string;
begin
  for i:=0 to Players.Count-1 do
  begin
    pi:=Players[i];
    pi.Correct:=FileExists(pi.Path);
    item:=ListView1.Items.Add;
    item.Caption:=pi.Name;
    item.Data:=pi;
    if pi.New then
      sAttr:='n'
    else
      sAttr:='s';
    if pi.Correct then
      sAttr:=sAttr+'c'
    else
      sAttr:=sAttr+'b';
    if pi.IsModified() then
      sAttr:=sAttr+'m';
    item.SubItems.Add(sAttr);
    item.SubItems.Add(pi.Path);
  end;
end;

procedure TPlayersForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
const prevIndex: integer=-1;
var
  pi: TPlayerInfo;
  sAttr: string;
begin
  if not Item.Selected then exit;
  if Item.Index=prevIndex then exit;
  prevIndex:=Item.Index;
  pi:=Item.Data;
  if pi.New then
    sAttr:='new'
  else
    sAttr:='standard';
  if pi.Correct then
    sAttr:=sAttr+' correct'
  else
    sAttr:=sAttr+' bad';
  if pi.IsModified() then
    sAttr:=sAttr+' modified';
  lblAttr.Caption:=sAttr;
  edName.Text := pi.Name;
  edName.ReadOnly := not pi.New;
  edPath.Text := pi.Path;
end;

procedure TPlayersForm.SetCheckboxes;
var
   i: integer;
   pi: TPlayerInfo;
   item: TListItem;
begin
  for i:=0 to ListView1.Items.Count-1 do
  begin
    item:=ListView1.Items[i];
    pi:=item.Data;
    item.Checked:=pi.InCombo;
  end;
end;

procedure TPlayersForm.SetInComboFlag;
var
   i: integer;
   pi: TPlayerInfo;
   item: TListItem;
begin
  for i:=0 to ListView1.Items.Count-1 do
  begin
    item:=ListView1.Items[i];
    pi:=item.Data;
    pi.InCombo:=item.Checked;
  end;
end;

procedure TPlayersForm.SpeedButton1Click(Sender: TObject);
var
  i: integer;
  item: TListItem;
begin
  for i:=0 to ListView1.Items.Count-1 do
  begin
    item:=ListView1.Items[i];
    item.Checked:=true;
  end;
end;

procedure TPlayersForm.SpeedButton2Click(Sender: TObject);
var
  i: integer;
  item: TListItem;
begin
  for i:=0 to ListView1.Items.Count-1 do
  begin
    item:=ListView1.Items[i];
    item.Checked:=false;
  end;
end;

procedure TPlayersForm.SpeedButton3Click(Sender: TObject);
var
  pi: TPlayerInfo;
begin
  if edPath.Text<>'' then
  begin
    OpenDialog.InitialDir:=ExtractFileDir(edPath.Text);
    OpenDialog.FileName:=ExtractFileName(edPath.Text);
  end else
  begin
    OpenDialog.InitialDir:=AppDir;
    if ListView1.Selected<>nil then
    begin
      pi:=ListView1.Selected.Data;
      OpenDialog.FileName:=pi.ExeName;
    end else OpenDialog.FileName:='';
  end;
  if OpenDialog.Execute() then
  begin
    edPath.Text:=OpenDialog.FileName;
    UpdateAttrAndItem;
  end;
end;

procedure TPlayersForm.UpdateAttrAndItem;
var
  pi: TPlayerInfo;
  sAttr: string;
begin
  if ListView1.Selected=nil then
  begin
    ShowMessage('Not selected any item!');
    exit;
  end;
  pi:=ListView1.Selected.Data;
  pi.Path:=edPath.Text;
  pi.ExeName:=ExtractFileName(pi.Path);
  pi.Correct:=FileExists(pi.Path);
  if pi.New then
    sAttr:='n'
  else
    sAttr:='s';
  if pi.Correct then
    sAttr:=sAttr+'c'
  else
    sAttr:=sAttr+'b';
  if pi.IsModified() then
    sAttr:=sAttr+'m';
  ListView1.Selected.SubItems[0]:=sAttr;
  ListView1.Selected.SubItems[1]:=pi.Path;
  if pi.New then
    sAttr:='new'
  else
    sAttr:='standard';
  if pi.Correct then
    sAttr:=sAttr+' correct'
  else
    sAttr:=sAttr+' bad';
  if pi.IsModified() then
    sAttr:=sAttr+' modified';
  lblAttr.Caption:=sAttr;
end;

end.
