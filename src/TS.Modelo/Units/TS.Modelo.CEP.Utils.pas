unit TS.Modelo.CEP.Utils;

interface

uses
  TS.Modelo.CEP;

//Utils
function CriarCEP(const AValor: string): ICEP;
function CEPDe(const AValor: string): ICEP;

implementation

uses
  TS.Modelo.CEP.Padrao;

//Utils
function CriarCEP(const AValor: string): ICEP;
begin
  Result := TCEP.Create(AValor);
end;

function CEPDe(const AValor: string): ICEP;
begin
  Result := TCEP.De(AValor);
end;

end.
