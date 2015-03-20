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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure SetInComboFlag;
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
    function IsModified: boolean;
    constructor Create; overload;
    constructor Create(strings: TStrings); overload;
  end;

var
  Players: TList;
  ProgramFiles32Dir: string;
  ProgramFiles64Dir: string;
  strCSIDL_LOCAL_APPDATA: string;

implementation

{$R *.dfm}

{ TPlayerInfo }

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

procedure TPlayersForm.FormCreate(Sender: TObject);
var
  i: integer;
  pi: TPlayerInfo;
  item: TListItem;
begin
  for i:=0 to Players.Count-1 do
  begin
    pi:=Players[i];
    item:=ListView1.Items.Add;
    item.Caption:=pi.Name;
    item.Data:=pi;
    if pi.IsModified() then
      item.SubItems.Add('sm')
    else
      item.SubItems.Add('s');
    item.SubItems.Add(pi.Path);
  end;
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


end.
