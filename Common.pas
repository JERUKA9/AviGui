unit Common;

interface
uses
  SysUtils;

function AppPath(): string;
function AppDir(): string;

implementation

function AppPath(): string;
begin
  result := GetModuleName(0);
end;

function AppDir(): string;
begin
  result := ExtractFilePath(GetModuleName(0));
end;

end.
