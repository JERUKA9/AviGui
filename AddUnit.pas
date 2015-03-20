unit AddUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, ComCtrls;

type
  TAddForm = class(TForm)
    edPath: TEdit;
    edName: TEdit;
    SpeedButton3: TSpeedButton;
    OpenDialog: TOpenDialog;
    Button2: TButton;
    Button1: TButton;
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddForm: TAddForm;

implementation
uses
  Common, PlayersUnit;

{$R *.dfm}

procedure TAddForm.Button1Click(Sender: TObject);
var
  i: integer;
  item: TListItem;
begin
  edName.Text:=Trim(edName.Text);
  edPath.Text:=Trim(edPath.Text);
  if (edName.Text='') or (edPath.Text='') then
  begin
    ShowMessage('Fill both fields!');
    ModalResult:=mrNone;
  end;
  for i:=0 to PlayersForm.ListView1.Items.Count-1 do
  begin
    item:=PlayersForm.ListView1.Items[i];
    if item.Caption=edName.Text then
    begin
      ShowMessage('This name already exists!');
      ModalResult:=mrNone;
      exit;
    end;
  end;

end;

procedure TAddForm.SpeedButton3Click(Sender: TObject);
begin
  OpenDialog.InitialDir:=AppDir;
  if OpenDialog.Execute() then
    edPath.Text:=OpenDialog.FileName;
end;

end.
