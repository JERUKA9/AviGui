program AviGui;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PlayersUnit in 'PlayersUnit.pas' {PlayersForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPlayersForm, PlayersForm);
  Application.Run;
end.
