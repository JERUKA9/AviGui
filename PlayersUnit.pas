unit PlayersUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TPlayersForm = class(TForm)
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure SetInComboFlag;
  public
    procedure SetCheckboxes;
  end;

var
  PlayersForm: TPlayersForm;

type
  TPlayerInfo = class
  public
    Name: string;
    ExeName: string;
    Path: string;
    InCombo: boolean;
    Modified: boolean;
    constructor Create; overload;
    constructor Create(strings: TStrings); overload;
  end;

var
  Players: TList;

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
  end;
end;

procedure TPlayersForm.Button1Click(Sender: TObject);
begin
  SetInComboFlag;
end;

procedure TPlayersForm.FormCreate(Sender: TObject);
var
  i: integer;
  pi: TPlayerInfo;
begin
  for i:=0 to Players.Count-1 do
  begin
    pi:=Players[i];
    ListView1.AddItem(pi.Name, pi);
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

end.
