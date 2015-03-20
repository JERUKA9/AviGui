program AviGui;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PlayersUnit in 'PlayersUnit.pas' {PlayersForm},
  AddUnit in 'AddUnit.pas' {AddForm},
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPlayersForm, PlayersForm);
  Application.CreateForm(TAddForm, AddForm);
  Application.Run;
end.
