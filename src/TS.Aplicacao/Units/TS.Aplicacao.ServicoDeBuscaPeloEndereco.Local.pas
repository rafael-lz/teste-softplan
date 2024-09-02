unit TS.Aplicacao.ServicoDeBuscaPeloEndereco.Local;

interface

uses
  TS.Lib.Lista,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Aplicacao.RepositorioDeEnderecos,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco;

type
  //TServicoDeBuscaPeloEnderecoLocal
  TServicoDeBuscaPeloEnderecoLocal = class sealed(TInterfacedObject, IServicoDeBuscaPeloEndereco)
  private
    FRepositorioDeEnderecos: IRepositorioDeEnderecos;
  public
    constructor Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos);
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>;
  end;

implementation

uses
  System.SysUtils,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco.Erros;

{ TServicoDeBuscaPeloEnderecoLocal }

constructor TServicoDeBuscaPeloEnderecoLocal.Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos);
begin
  if not Assigned(ARepositorioDeEnderecos) then
    raise EArgumentNilException.Create('O repositório de endereços é obrigatório.');
  FRepositorioDeEnderecos := ARepositorioDeEnderecos;
end;

function TServicoDeBuscaPeloEnderecoLocal.Buscar(const AUF: IUF; const ALocalidade,
  ALogradouro: string): ILista<IEndereco>;
const
  nTamanhoMinimo = 3;
begin
  if not Assigned(AUF) then
    raise EUFInvalida.Create('A UF é obrigatória.');
  if Length(Trim(ALocalidade)) < nTamanhoMinimo then
    raise ELocalidadeInvalida.CreateFmt('A localidade deve ter pelo menos %d caracteres.', [nTamanhoMinimo]);
  if Length(Trim(ALogradouro)) < nTamanhoMinimo then
    raise ELogradouroInvalido.CreateFmt('O logradouro deve ter pelo menos %d caracteres.', [nTamanhoMinimo]);
  Result := FRepositorioDeEnderecos.Buscar(AUF, ALocalidade, ALogradouro);
end;

end.
