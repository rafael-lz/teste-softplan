unit TS.Aplicacao.ServicoDeBuscaPeloCEP.Local;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.Endereco,
  TS.Aplicacao.RepositorioDeEnderecos,
  TS.Aplicacao.ServicoDeBuscaPeloCEP;

type
  //TServicoDeBuscaPeloCEPLocal
  TServicoDeBuscaPeloCEPLocal = class sealed(TInterfacedObject, IServicoDeBuscaPeloCEP)
  private
    FRepositorioDeEnderecos: IRepositorioDeEnderecos;
  public
    constructor Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos);
    function Buscar(const ACEP: ICEP): IEndereco;
  end;

implementation

uses
  System.SysUtils,
  TS.Aplicacao.ServicoDeBuscaPeloCEP.Erros;

{ TServicoDeBuscaPeloCEPLocal }

constructor TServicoDeBuscaPeloCEPLocal.Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos);
begin
  if not Assigned(ARepositorioDeEnderecos) then
    raise EArgumentNilException.Create('O repositório de endereços é obrigatório.');
  FRepositorioDeEnderecos := ARepositorioDeEnderecos;
end;

function TServicoDeBuscaPeloCEPLocal.Buscar(const ACEP: ICEP): IEndereco;
begin
  if not Assigned(ACEP) then
    raise ECEPInvalido.Create('O CEP é obrigatório.');
  Result := FRepositorioDeEnderecos.Buscar(ACEP);
end;

end.
