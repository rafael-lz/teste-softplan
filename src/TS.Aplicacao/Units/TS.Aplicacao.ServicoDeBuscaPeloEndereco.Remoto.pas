unit TS.Aplicacao.ServicoDeBuscaPeloEndereco.Remoto;

interface

uses
  TS.Lib.Lista,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Aplicacao.RepositorioDeEnderecos,
  TS.Aplicacao.ConsultaDeEnderecos,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco;

type
  //TServicoDeBuscaPeloEnderecoRemoto
  TServicoDeBuscaPeloEnderecoRemoto = class sealed(TInterfacedObject, IServicoDeBuscaPeloEndereco)
  private
    FRepositorioDeEnderecos: IRepositorioDeEnderecos;
    FConsultaDeEnderecos: IConsultaDeEnderecos;
    procedure Gravar(const AEnderecos: ILista<IEndereco>);
  public
    constructor Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos;
      const AConsultaDeEnderecos: IConsultaDeEnderecos);
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>;
  end;

implementation

uses
  System.SysUtils,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco.Erros;

{ TServicoDeBuscaPeloEnderecoRemoto }

constructor TServicoDeBuscaPeloEnderecoRemoto.Create(const ARepositorioDeEnderecos: IRepositorioDeEnderecos;
  const AConsultaDeEnderecos: IConsultaDeEnderecos);
begin
  if not Assigned(ARepositorioDeEnderecos) then
    raise EArgumentNilException.Create('O repositório de endereços é obrigatório.');
  if not Assigned(AConsultaDeEnderecos) then
    raise EArgumentNilException.Create('A consulta de endereços é obrigatória.');
  FRepositorioDeEnderecos := ARepositorioDeEnderecos;
  FConsultaDeEnderecos := AConsultaDeEnderecos;
end;

procedure TServicoDeBuscaPeloEnderecoRemoto.Gravar(const AEnderecos: ILista<IEndereco>);
var
  I: Integer;
begin
  for I := 0 to Pred(AEnderecos.Quantidade) do
    if FRepositorioDeEnderecos.Existe(AEnderecos[I].CEP) then
      FRepositorioDeEnderecos.Alterar(AEnderecos[I])
    else
      FRepositorioDeEnderecos.Incluir(AEnderecos[I]);
end;

function TServicoDeBuscaPeloEnderecoRemoto.Buscar(const AUF: IUF; const ALocalidade,
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
  Result := FConsultaDeEnderecos.Buscar(AUF, ALocalidade, ALogradouro);
  if Result.Quantidade > 0 then
    Gravar(Result);
end;

end.
