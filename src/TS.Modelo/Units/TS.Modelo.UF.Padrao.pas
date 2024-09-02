unit TS.Modelo.UF.Padrao;

interface

uses
  TS.Modelo.UF;

type
  //TUF
  TUF = class sealed(TInterfacedObject, IUF)
  private
    FSigla: string;
    function GetSigla: string;
  public
    constructor Create(const ASigla: string);
    property Sigla: string read GetSigla;
    class function De(const ASigla: string): TUF;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

{ TUF }

constructor TUF.Create(const ASigla: string);
begin
  if ASigla = '' then
    raise EArgumentException.Create('O UF é obrigatória.');
  if not TRegEx.IsMatch(ASigla,
      '^\s*(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO)?$') then
    raise EArgumentException.Create('UF inválida.');
  FSigla := ASigla;
end;

function TUF.GetSigla: string;
begin
  Result := FSigla;
end;

class function TUF.De(const ASigla: string): TUF;
begin
  Result := TUF.Create(UpperCase(ASigla));
end;

end.
