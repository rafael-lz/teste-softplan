unit TS.Modelo.CEP.Padrao;

interface

uses
  TS.Modelo.CEP;

type
  //TCEP
  TCEP = class sealed(TInterfacedObject, ICEP)
  private
    FNumero: string;
    function GetNumero: string;
  public
    constructor Create(const ANumero: string);
    function Formatar: string;
    property Numero: string read GetNumero;
    class function De(const ANumero: string): TCEP;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.MaskUtils,
  System.RegularExpressions;

{ TCEP }

constructor TCEP.Create(const ANumero: string);
const
  lTamanho = 8;
begin
  if ANumero = '' then
    raise EArgumentException.Create('O CEP é obrigatório.');
  if Length(ANumero) <> lTamanho then
    raise EArgumentException.CreateFmt('O CEP deve ter %d caracteres.', [lTamanho]);
  if not TRegEx.IsMatch(ANumero, '^\d+$') then
    raise EArgumentException.Create('O CEP deve ter conter apenas números.');
  FNumero := ANumero;
end;

function TCEP.GetNumero: string;
begin
  Result := FNumero;
end;

function TCEP.Formatar: string;
begin
  Result := FormatMaskText('99.999-999;0', Numero);
end;

class function TCEP.De(const ANumero: string): TCEP;
begin
  Result := TCEP.Create(TRegEx.Replace(ANumero, '\D', ''));
end;

end.
