unit TS.Modelo.UF.Utils;

interface

uses
  TS.Modelo.UF;

//Utils
function CriarUF(const ASigla: string): IUF;
function UFDe(const ASigla: string): IUF;

implementation

uses
  TS.Modelo.UF.Padrao;

//Utils
function CriarUF(const ASigla: string): IUF;
begin
  Result := TUF.Create(ASigla);
end;

function UFDe(const ASigla: string): IUF;
begin
  Result := TUF.De(ASigla);
end;

end.
