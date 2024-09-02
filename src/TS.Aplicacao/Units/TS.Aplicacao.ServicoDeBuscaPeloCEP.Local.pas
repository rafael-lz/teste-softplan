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
    raise EArgumentNilException.Create('O reposit�rio de endere�os � obrigat�rio.');
  FRepositorioDeEnderecos := ARepositorioDeEnderecos;
end;

function TServicoDeBuscaPeloCEPLocal.Buscar(const ACEP: ICEP): IEndereco;
begin
  if not Assigned(ACEP) then
    raise ECEPInvalido.Create('O CEP � obrigat�rio.');
  Result := FRepositorioDeEnderecos.Buscar(ACEP);
end;

end.
