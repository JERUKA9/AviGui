unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, IniFiles, ShlObj, StrUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    OpenVideoDialog: TOpenDialog;
    Button3: TButton;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    OpenFFmpegDialog: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    IniPath: string;
    FFmpegDir: string;
    IniCanBeWritten: boolean;
    procedure ReadIniSettings;
    procedure WriteIniSettings;
    procedure FillPlayersFromDat;
    procedure FillPlayersCombo;
    function ForceFFmpeg: boolean;
    procedure SetDirConsts;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  PlayersUnit;

{$R *.dfm}

function AppPath(): string;
begin
  result := GetModuleName(0);
end;

function AppDir(): string;
begin
  result := ExtractFilePath(GetModuleName(0));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenVideoDialog.Execute then
    ListView1.AddItem(OpenVideoDialog.FileName, nil);
end;

const
  CSIDL_LOCAL_APPDATA = $001C;
  CSIDL_PROGRAM_FILES = $0026;

function getWinSpecialFolder(CSIDLFolder : integer) : string;
begin
  SetLength(Result, MAX_PATH);
  SHGetSpecialFolderPath(0, PChar(Result), CSIDLFolder, false);
  SetLength(Result, StrLen(PChar(Result)));
  if (Result <> '') then Result := IncludeTrailingBackslash(Result);
end;

function LastPos(const Part, Whole: string): integer;
var
  Reverse: string;
  RevPart: string;
begin
  Reverse:= ReverseString(Whole);
  RevPart:= ReverseString(Part);
  Result:= (Length(Whole) + 1) - Pos(RevPart, Reverse) - Length(RevPart)+1;
  if (Result > Length(Whole)) then Result:= 0;
end;

procedure TForm1.SetDirConsts;
var
  ProgramFiles: string;
  pos86,posBSL: integer;
begin
  strCSIDL_LOCAL_APPDATA:=getWinSpecialFolder(CSIDL_LOCAL_APPDATA);
  ProgramFiles:=ExcludeTrailingBackslash(getWinSpecialFolder(CSIDL_PROGRAM_FILES));
  posBSL:=LastDelimiter('\', ProgramFiles);
  if posBSL<1 then raise Exception.Create('Bad CSIDL_PROGRAM_FILES');
  ProgramFiles32Dir:=ProgramFiles+'\';
  pos86:=LastPos('(x86)', ProgramFiles);
  if pos86>posBSL then
  begin
    dec(pos86);
    while (pos86>0)and(ProgramFiles[pos86]=' ') do dec(pos86);
    SetLength(ProgramFiles, pos86);
    ProgramFiles64Dir:=ProgramFiles+'\';;
  end else
    ProgramFiles64Dir:=ProgramFiles;
end;

procedure TForm1.FillPlayersFromDat;
var
  i:integer;
  f: TextFile;
  Line: string;
  pi: TPlayerInfo;
  strings: TStringList;
begin
{$IFDEF WIN64}
  ShowMessage('Must be compiled as 32-bit to detect CSIDL_PROGRAM_FILES');
  RunError(1);
{$ENDIF}
  SetDirConsts;
  AssignFile(f,AppDir()+'Players.dat');
  Reset(f);
  strings:=TStringList.Create;
  while not eof(f) do
  begin
    readln(f, Line);
    Line:=Trim(Line);
    if Line='' then
    begin
      pi:=TPlayerInfo.Create(strings);
      Players.Add(pi);
      strings.Clear;
    end else strings.Add(Line);
  end;
  if strings.Count>0 then
  begin
    pi:=TPlayerInfo.Create(strings);
    Players.Add(pi);
  end;
  strings.Free;
  CloseFile(f);
end;

procedure TForm1.FillPlayersCombo;
var
  i:integer;
  pi: TPlayerInfo;
begin
  ComboBox1.Items.Clear;
  for i:=0 to Players.Count-1 do
  begin
    pi:=Players[i];
    if pi.InCombo then
      ComboBox1.Items.AddObject(pi.Name, pi);
  end;
  if ComboBox1.Items.Count>0 then
    ComboBox1.ItemIndex:=0
  else
    ComboBox1.ItemIndex:=-1;
end;

function TForm1.ForceFFmpeg: boolean;
  function ISDirCorrect(dir: string; out LackFile: string): boolean;
  const
    FilesToFind : array[0..2] of string = ('ffmpeg.exe', 'ffplay.exe', 'ffprobe.exe');
  var
    i: integer;
  begin
    if dir='' then
    begin
      LackFile:='ffmpeg.exe';
      result:=false;
      exit;
    end;
    LackFile:='';
    for i:=0 to High(FilesToFind) do
      if not FileExists(dir+FilesToFind[i]) then
      begin
        LackFile:=FilesToFind[i];
        result:=false;
        exit;
      end;
    result:=true;
  end;
var
  LackFile: string;
  warnStr: string;
  pi: TPlayerInfo;
  fillFirst: boolean;
begin
  result:=true;
  if FFmpegDir<>'' then
    OpenFFmpegDialog.InitialDir:=FFmpegDir
  else
    OpenFFmpegDialog.InitialDir:=AppDir;
  IniCanBeWritten:=FFmpegDir<>'';
  fillFirst:=FFmpegDir='';
  if (FFmpegDir<>'') and ISDirCorrect(FFmpegDir, LackFile) then exit;
  repeat
    if FFmpegDir<>'' then
      warnStr:=Format('No %s in directory %s, exit program?',[LackFile,FFmpegDir])
    else
      warnStr:='Please configure program. Yes - exit program? No - give FFmpeg directory, ';
    if MessageDlg(warnStr,mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      result:=false;
      exit;
    end;
    OpenFFmpegDialog.FileName:=LackFile;
    if OpenFFmpegDialog.Execute then FFmpegDir:=ExtractFilePath(OpenFFmpegDialog.FileName);
  until ISDirCorrect(FFmpegDir, LackFile);
  pi:=Players[0];
  pi.Path:=FFmpegDir+'ffplay.exe';
  if fillFirst then pi.InCombo:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  pi: TPlayerInfo;
begin
  IniPath := ChangeFileExt(AppPath, '.ini');
  Players:=TList.Create;
  pi:=TPlayerInfo.Create();
  pi.Name := 'ffplay';
  Players.Add(pi);
  FillPlayersFromDat;
  ReadIniSettings;
  if not ForceFFmpeg then halt;
  IniCanBeWritten:=true;
  ListView1.AddItem('d:\AviGui\h265.mp4', nil);
  ListView1.AddItem('d:\foto\1\20150307_kocica.mp4', nil);
  ListView1.AddItem('d:\wypal_trekstor\359\Filmy\Zeitgeist\Zeitgeist__Addendum_01_13__PL_.avi', nil);
  ListView1.AddItem('d:\wypal_trekstor\359\z Minolty\2004.09.02\Berta.MOV', nil);
  FillPlayersCombo;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i:integer;
  pi: TPlayerInfo;
begin
  if IniCanBeWritten then WriteIniSettings;
  for i:=0 to Players.Count-1 do
  begin
    pi:=Players[i];
    pi.Free;
  end;
  Players.Free;
end;

function WideStrScan(const Str:PWideChar; Chr:WideChar): PWideChar;
begin
  result:=Str;
  while not ((result^=chr)or(result^=#0)) do
    inc(result);
  if (result^=#0) then result:=nil else Assert(result^=Chr);
end;

function Exec(ExePath,CmdLine,Dir:UnicodeString; bHide:Boolean=false):integer;
{$ifdef LINUX}
-- not tested with UnicodeString
var
  i: integer;
  ArgList: TWideStringList;
  ArgArray: PPWideCharArray;
begin
  result := fork();
  case result of
    -1: begin result:=0; exit; end;
     0://Child
     begin
       for i := stderr + 1 to sysconf(_SC_OPEN_MAX)-1 do
         fcntl(i, F_SETFD, FD_CLOEXEC);
       ArgList := TWideStringList.Create;
       SeparateStrings([' '], [' '], [], PWideChar(CmdLine), ArgList);
       ArgList.Insert(0,ExePath);
       GetMem(ArgArray, (ArgList.Count+1)*sizeof(PWideChar));
       for i:=0 to ArgList.Count-1 do
         ArgArray[i] := WideStrNew(ArgList[i]);
       ArgArray[FArgList.Count] := nil;
       execvp(ArgArray[0], PPChar(ArgArray));
       __exit(EXIT_FAILURE); //if Ok, this be omited
       for i:=ArgList.Count-1 do StrDispose(ArgArray[i]);
       FreeMem(ArgArray);
     end;
end;
{$endif}
{$ifdef MSWINDOWS}
var
  StartupInfo: TStartupInfoW;
  ProcessInformation: TProcessInformation;
  Param0: UnicodeString;
begin
  FillChar(StartupInfo, sizeof(StartupInfo), 0);
  with StartupInfo do
  begin
    dwFlags:=STARTF_USESHOWWINDOW;
    if bHide then wShowWindow:=SW_HIDE
    else wShowWindow:=SW_SHOW;
    cb:=sizeof(TStartupInfo);
  end;
  FillChar(ProcessInformation, sizeof(ProcessInformation), 0);
  if WideStrScan(PWideChar(ExePath), ' ')<>nil then
     Param0 := '"'+ExePath+'"'
  else
     Param0 := ExePath;
  CreateProcessW(PWideChar(ExePath),PWideChar(Param0+' '+CmdLine),nil,nil,
       false,NORMAL_PRIORITY_CLASS,nil,PWideChar(Dir),StartupInfo,ProcessInformation);
  result:=ProcessInformation.hProcess;
end;
{$endif}

procedure TForm1.ListView1DblClick(Sender: TObject);
var
  sel: TListItem;
  arg: WideString;
  pi: TPlayerInfo;
begin
  sel:=ListView1.Selected;
  if sel=nil then exit;
  if ComboBox1.ItemIndex<0 then exit;
  arg:=sel.Caption;
  if WideStrScan(PWideChar(arg), ' ')<>nil then
     arg := '"'+arg+'"';
  pi:=ComboBox1.Items.Objects[ComboBox1.ItemIndex] as TPlayerInfo;
  Exec(pi.Path,arg,ExtractFileDir(sel.Caption));
end;

procedure TForm1.ReadIniSettings;
var
  iniFile: TIniFile;
  strings: TStringList;
  i,j,n: integer;
  Line,IsCombo,Name,Path: string;
  pi: TPlayerInfo;
  bFound: boolean;
begin
  iniFile := TIniFile.Create(IniPath);
  try
    FFmpegDir:=iniFile.ReadString('FFmpeg', 'Dir', '');
    strings:=TStringList.Create;
    iniFile.ReadSection('Players',strings);
    for i:=0 to strings.Count-1 do
    begin
      Line:=iniFile.ReadString('Players', strings[i], '');
      n:=Pos(';',Line);
      if n<1 then continue;
      IsCombo:=Copy(Line,1,n-1);
      Line:=Copy(Line,n+1, Length(Line)-n);
      n:=Pos(';',Line);
      if n<1 then continue;
      Name:=Copy(Line,1,n-1);
      Path:=Copy(Line,n+1, Length(Line)-n);
      bFound:=false;
      pi:=nil;
      for j:=0 to Players.Count-1 do
      begin
        pi:=Players[j];
        if pi.Name=Name then
        begin
          bFound:=true;
          break;
        end;
      end;
      if bFound then
        pi.Path:=Path
      else
      begin
        pi:=TPlayerInfo.Create;
        pi.Name:=Name;
        pi.Path:=path;
        Players.Add(pi);
      end;
      pi.InCombo:=IsCombo='1';
    end;
    strings.Free;
  finally
    iniFile.Free;
  end;
end;

procedure TForm1.WriteIniSettings;
var
  iniFile: TIniFile;
  i: integer;
  pi: TPlayerInfo;
begin
  iniFile := TIniFile.Create(IniPath);
  try
    iniFile.WriteString('FFmpeg', 'Dir', FFmpegDir);
    iniFile.EraseSection('Players');
    for i:=0 to ComboBox1.Items.Count-1 do
    begin
      pi:=ComboBox1.Items.Objects[i] as TPlayerInfo;
      iniFile.WriteString('Players', IntToStr(i), '1;'+pi.Name+';'+pi.Path);
    end;
    for i:=0 to Players.Count-1 do
    begin
      pi:=TPlayerInfo(Players[i]);
      if pi.Modified and not pi.InCombo then
        iniFile.WriteString('Players', IntToStr(ComboBox1.Items.Count+i), '0;'+pi.Name+';'+pi.Path);
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  PlayersForm.SetCheckboxes;
  if PlayersForm.ShowModal = mrOK then
    FillPlayersCombo;
end;


procedure TForm1.Button3Click(Sender: TObject);
var
  sel: TListItem;
  arg: WideString;
begin
  sel:=ListView1.Selected;
  if sel=nil then exit;
  arg:=sel.Caption;
  if WideStrScan(PWideChar(arg), ' ')<>nil then
     arg := '"'+arg+'"';
  Exec('d:\AviGui\ffprobe.exe',arg,ExtractFileDir(sel.Caption));
end;

end.
