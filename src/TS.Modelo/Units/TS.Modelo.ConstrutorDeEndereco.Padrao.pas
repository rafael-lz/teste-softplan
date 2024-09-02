unit TS.Modelo.ConstrutorDeEndereco.Padrao;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Modelo.ConstrutorDeEndereco;

type
  //TConstrutorDeEndereco
  TConstrutorDeEndereco = class sealed(TInterfacedObject, IConstrutorDeEndereco)
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
    function ComCEP(const AValor: ICEP): IConstrutorDeEndereco;
    function ComLogradouro(const AValor: string): IConstrutorDeEndereco;
    function ComComplemento(const AValor: string): IConstrutorDeEndereco;
    function ComBairro(const AValor: string): IConstrutorDeEndereco;
    function ComLocalidade(const AValor: string): IConstrutorDeEndereco;
    function ComUF(const AValor: IUF): IConstrutorDeEndereco;
    function Construir: IEndereco;
    property CEP: ICEP read GetCEP;
    property Logradouro: string read GetLogradouro;
    property Complemento: string read GetComplemento;
    property Bairro: string read GetBairro;
    property Localidade: string read GetLocalidade;
    property UF: IUF read GetUF;
  end;

implementation

uses
  TS.Modelo.Endereco.Padrao,
  TS.Modelo.ConstrutorDeEndereco.Erros;

{ TConstrutorDeEndereco }

function TConstrutorDeEndereco.GetCEP: ICEP;
begin
  Result := FCEP;
end;

function TConstrutorDeEndereco.GetLogradouro: string;
begin
  Result := FLogradouro;
end;

function TConstrutorDeEndereco.GetComplemento: string;
begin
  Result := FComplemento;
end;

function TConstrutorDeEndereco.GetBairro: string;
begin
  Result := FBairro;
end;

function TConstrutorDeEndereco.GetLocalidade: string;
begin
  Result := FLocalidade;
end;

function TConstrutorDeEndereco.GetUF: IUF;
begin
  Result := FUF;
end;

function TConstrutorDeEndereco.ComCEP(const AValor: ICEP): IConstrutorDeEndereco;
begin
  FCEP := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.ComLogradouro(const AValor: string): IConstrutorDeEndereco;
begin
  FLogradouro := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.ComComplemento(const AValor: string): IConstrutorDeEndereco;
begin
  FComplemento := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.ComBairro(const AValor: string): IConstrutorDeEndereco;
begin
  FBairro := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.ComLocalidade(const AValor: string): IConstrutorDeEndereco;
begin
  FLocalidade := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.ComUF(const AValor: IUF): IConstrutorDeEndereco;
begin
  FUF := AValor;
  Result := Self;
end;

function TConstrutorDeEndereco.Construir: IEndereco;
begin
  if not Assigned(FCEP) then
    raise EConstrutorDeEndereco.Create('O CEP é obrigatório.');
  if FLocalidade = '' then
    raise EConstrutorDeEndereco.Create('A localidade é obrigatória.');
  if not Assigned(FUF) then
    raise EConstrutorDeEndereco.Create('A UF é obrigatória.');
  Result := TEndereco.Create(Self);
end;

end.
