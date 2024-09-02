unit TS.API.ConversorDeEnderecosDaViaCEP.EmJSON;

interface

uses
  System.Classes,
  System.JSON,
  TS.Lib.Lista,
  TS.Modelo.Endereco,
  TS.API.ConversorDeEnderecosDaViaCEP;

type
  //TConversorDeEnderecosDaViaCEPEmJSON
  TConversorDeEnderecosDaViaCEPEmJSON = class sealed(TInterfacedObject, IConversorDeEnderecosDaViaCEP)
  private const
    FCEP = 'cep';
    FLogradouro = 'logradouro';
    FComplemento = 'complemento';
    FBairro = 'bairro';
    FLocalidade = 'localidade';
    FUF = 'uf';
  private
    FFormato: string;
    function GetFormato: string;
    function LerEnderecos(const AEnderecos: TJSONArray): ILista<IEndereco>;
    function LerEndereco(const AEndereco: TJSONObject): IEndereco;
  public
    constructor Create;
    function Converter(const ADados: TStream): ILista<IEndereco>;
    property Formato: string read GetFormato;
  end;

implementation

uses
  System.SysUtils,
  TS.Lib.Lista.Utils,
  TS.Modelo.CEP,
  TS.Modelo.CEP.Utils,
  TS.Modelo.UF,
  TS.Modelo.UF.Utils,
  TS.Modelo.ConstrutorDeEndereco,
  TS.Modelo.ConstrutorDeEndereco.Utils;

{ TConversorDeEnderecosDaViaCEPEmJSON }

constructor TConversorDeEnderecosDaViaCEPEmJSON.Create;
begin
  FFormato := 'json';
end;

function TConversorDeEnderecosDaViaCEPEmJSON.GetFormato: string;
begin
  Result := FFormato;
end;

function TConversorDeEnderecosDaViaCEPEmJSON.LerEnderecos(const AEnderecos: TJSONArray): ILista<IEndereco>;
var
  I: Integer;
begin
  Result := TListas.Criar<IEndereco>;
  for I := 0 to Pred(AEnderecos.Count) do
    if AEnderecos[I] is TJSONObject then
      Result.Adicionar(LerEndereco(TJSONObject(AEnderecos[I])));
end;

function TConversorDeEnderecosDaViaCEPEmJSON.LerEndereco(const AEndereco: TJSONObject): IEndereco;
var
  lConstrutor: IConstrutorDeEndereco;
  lValor: TJSONValue;
begin
  lConstrutor := CriarConstrutorDeEndereco;
  if AEndereco.TryGetValue<TJSONValue>(FCEP, lValor) then
    lConstrutor.ComCEP(CEPDe(lValor.Value));
  if AEndereco.TryGetValue<TJSONValue>(FLogradouro, lValor) then
    lConstrutor.ComLogradouro(lValor.Value);
  if AEndereco.TryGetValue<TJSONValue>(FComplemento, lValor) then
    lConstrutor.ComComplemento(lValor.Value);
  if AEndereco.TryGetValue<TJSONValue>(FBairro, lValor) then
    lConstrutor.ComBairro(lValor.Value);
  if AEndereco.TryGetValue<TJSONValue>(FLocalidade, lValor) then
    lConstrutor.ComLocalidade(lValor.Value);
  if AEndereco.TryGetValue<TJSONValue>(FUF, lValor) then
    lConstrutor.ComUF(CriarUF(lValor.Value));
  Result := lConstrutor.Construir;
end;

function TConversorDeEnderecosDaViaCEPEmJSON.Converter(const ADados: TStream): ILista<IEndereco>;
var
  lDados: TArray<Byte>;
  lJSON: TJSONValue;
  lEndereco: TJSONObject;
begin
  if not Assigned(ADados) then
    raise EArgumentNilException.Create('Os dados são obrigatórios.');
  Result := TListas.Criar<IEndereco>;
  SetLength(lDados, ADados.Size);
  ADados.Read(Pointer(lDados)^, Length(lDados));
  lJSON := TJSONValue.ParseJSONValue(lDados, 0, Length(lDados));
  try
    if lJSON is TJSONObject then
    begin
      lEndereco := TJSONObject(lJSON);
      if Assigned(lEndereco.GetValue(FCEP)) then
        Result.Adicionar(LerEndereco(lEndereco));
    end
    else
      if lJSON is TJSONArray then
        Result.Adicionar(LerEnderecos(TJSONArray(lJSON)));
  finally
    FreeAndNil(lJSON);
  end;
end;

end.
