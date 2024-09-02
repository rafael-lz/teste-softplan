unit TS.Modelo.Endereco.Padrao;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Modelo.ConstrutorDeEndereco;

type
  //TEndereco
  TEndereco = class sealed(TInterfacedObject, IEndereco)
  private
    FCEP: ICEP;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: IUF;
    function GetCEP: ICEP;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetLocalidade: string;
    function GetUF: IUF;
  public
    constructor Create(const AConstrutor: IConstrutorDeEndereco);
    property CEP: ICEP read GetCEP;
    property Logradouro: string read GetLogradouro;
    property Complemento: string read GetComplemento;
    property Bairro: string read GetBairro;
    property Localidade: string read GetLocalidade;
    property UF: IUF read GetUF;
  end;

implementation

uses
  System.SysUtils;

{ TEndereco }

constructor TEndereco.Create(const AConstrutor: IConstrutorDeEndereco);
begin
  if not Assigned(AConstrutor) then
    raise EArgumentNilException.Create('O construtor de endereços é obrigatório.');
  FCEP := AConstrutor.CEP;
  FLogradouro := AConstrutor.Logradouro;
  FComplemento := AConstrutor.Complemento;
  FBairro := AConstrutor.Bairro;
  FLocalidade := AConstrutor.Localidade;
  FUF := AConstrutor.UF;
end;

function TEndereco.GetCEP: ICEP;
begin
  Result := FCEP;
end;

function TEndereco.GetLogradouro: string;
begin
  Result := FLogradouro;
end;

function TEndereco.GetComplemento: string;
begin
  Result := FComplemento;
end;

function TEndereco.GetBairro: string;
begin
  Result := FBairro;
end;

function TEndereco.GetLocalidade: string;
begin
  Result := FLocalidade;
end;

function TEndereco.GetUF: IUF;
begin
  Result := FUF;
end;

end.
