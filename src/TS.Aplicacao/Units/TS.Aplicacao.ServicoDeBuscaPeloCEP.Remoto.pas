unit TS.Aplicacao.ServicoDeBuscaPeloCEP.Remoto;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.Endereco,
  TS.Aplicacao.RepositorioDeEnderecos,
  TS.Aplicacao.ConsultaDeEnderecos,
  TS.Aplicacao.ServicoDeBuscaPeloCEP;

type
  //TServicoDeBuscaPeloCEPRemoto
  TServicoDeBuscaPeloCEPRemoto = class sealed(TInterfacedObject, IServicoDeBuscaPeloCEP)
  private
    FRepositorioDeEnderecos: IRepositorioDeEnderecos;
    FConsultaDeEnderecos: IConsultaDeEnderecos;
    procedure Gravar(const AEndereco: IEndereco);
  public
    constructor Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos;
      const AConsultaDeEnderecos: IConsultaDeEnderecos);
    function Buscar(const ACEP: ICEP): IEndereco;
  end;

implementation

uses
  System.SysUtils,
  TS.Aplicacao.ServicoDeBuscaPeloCEP.Erros;

{ TServicoDeBuscaPeloCEPRemoto }

constructor TServicoDeBuscaPeloCEPRemoto.Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos;
  const AConsultaDeEnderecos: IConsultaDeEnderecos);
begin
  if not Assigned(ARepositorioDeEnderecos) then
    raise EArgumentNilException.Create('O repositório de endereços é obrigatório.');
  if not Assigned(AConsultaDeEnderecos) then
    raise EArgumentNilException.Create('A consulta de endereços é obrigatória.');
  FRepositorioDeEnderecos := ARepositorioDeEnderecos;
  FConsultaDeEnderecos := AConsultaDeEnderecos;
end;

procedure TServicoDeBuscaPeloCEPRemoto.Gravar(const AEndereco: IEndereco);
begin
  if FRepositorioDeEnderecos.Existe(AEndereco.CEP) then
    FRepositorioDeEnderecos.Alterar(AEndereco)
  else
    FRepositorioDeEnderecos.Incluir(AEndereco);
end;

function TServicoDeBuscaPeloCEPRemoto.Buscar(const ACEP: ICEP): IEndereco;
begin
  if not Assigned(ACEP) then
    raise ECEPInvalido.Create('O CEP é obrigatório.');
  Result := FConsultaDeEnderecos.Buscar(ACEP);
  if Assigned(Result) then
    Gravar(Result);
end;

end.
