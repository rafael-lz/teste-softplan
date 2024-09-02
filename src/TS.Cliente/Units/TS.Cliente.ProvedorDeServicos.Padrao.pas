unit TS.Cliente.ProvedorDeServicos.Padrao;

interface

uses
  System.Classes,
  TS.Aplicacao.ServicoDeBuscaPeloCEP,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco,
  TS.Aplicacao.RepositorioDeEnderecos,
  TS.Aplicacao.ConsultaDeEnderecos,
  TS.Cliente.ProvedorDeServicos;

type
  //TProvedorDeServicos
  TProvedorDeServicos = class sealed(TInterfacedObject, IProvedorDeServicos)
  private
    FParametros: TStrings;
    FBancoDeDadosSQLite: string;
    FEnderecoDaAPIViaCEP: string;
    FRepositorioDeEnderecos: IRepositorioDeEnderecos;
    function CriarRepositorioDeEnderecos: IRepositorioDeEnderecos;
    function CriarConsultaDeEnderecos(const AEmXML: Boolean): IConsultaDeEnderecos;
  public
    constructor Create(const AParametros: TStrings);
    destructor Destroy; override;
    function CriarServicoDeBuscaPeloCEPLocal: IServicoDeBuscaPeloCEP;
    function CriarServicoDeBuscaPeloCEPRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloCEP;
    function CriarServicoDeBuscaPeloEnderecoLocal: IServicoDeBuscaPeloEndereco;
    function CriarServicoDeBuscaPeloEnderecoRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloEndereco;
    class function Criar: TProvedorDeServicos;
  end;

implementation

uses
  System.SysUtils,
  TS.Aplicacao.ServicoDeBuscaPeloCEP.Local,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco.Local,
  TS.Aplicacao.ServicoDeBuscaPeloCEP.Remoto,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco.Remoto,
  TS.Persistencia.GerenciadorDeConexoesSQLite,
  TS.Persistencia.RepositorioDeEnderecosSQLite,
  TS.API.ConversorDeEnderecosDaViaCEP,
  TS.API.ConversorDeEnderecosDaViaCEP.EmJSON,
  TS.API.ConversorDeEnderecosDaViaCEP.EmXML,
  TS.API.ConsultaDeEnderecosPelaViaCEP,
  TS.Cliente.ProvedorDeServicos.Erros;

{ TProvedorDeServicos }

constructor TProvedorDeServicos.Create(const AParametros: TStrings);
begin
  if not Assigned(AParametros) then
    raise EArgumentNilException.Create('Parâmetros não informados.');
  FParametros := TStringList.Create;
  FParametros.Assign(AParametros);
  FBancoDeDadosSQLite := Trim(FParametros.Values['Persistencia.SQLite.BancoDeDados']);
  if FBancoDeDadosSQLite = '' then
    raise EParametroNaoEncontrado.Create('Banco de dados SQLite não configurado.');
  if ExtractFilePath(FBancoDeDadosSQLite) = '' then
    FBancoDeDadosSQLite := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + FBancoDeDadosSQLite;
  FEnderecoDaAPIViaCEP := Trim(FParametros.Values['API.ViaCEP.EnderecoDaAPI']);
  if FEnderecoDaAPIViaCEP = '' then
    raise EParametroNaoEncontrado.Create('Endereço da API ViaCEP não configurado.');
  FRepositorioDeEnderecos := CriarRepositorioDeEnderecos;
end;

destructor TProvedorDeServicos.Destroy;
begin
  FreeAndNil(FParametros);
  inherited;
end;

function TProvedorDeServicos.CriarRepositorioDeEnderecos: IRepositorioDeEnderecos;
begin
  Result := TRepositorioDeEnderecosSQLite.Create(TGerenciadorDeConexoesSQLite.Create(FBancoDeDadosSQLite));
end;

function TProvedorDeServicos.CriarConsultaDeEnderecos(const AEmXML: Boolean): IConsultaDeEnderecos;
var
  lConversorDeEnderecos: IConversorDeEnderecosDaViaCEP;
begin
  if AEmXML then
    lConversorDeEnderecos := TConversorDeEnderecosDaViaCEPEmXML.Create
  else
    lConversorDeEnderecos := TConversorDeEnderecosDaViaCEPEmJSON.Create;
  Result := TConsultaDeEnderecosPelaViaCEP.Create(FEnderecoDaAPIViaCEP, lConversorDeEnderecos);
end;

function TProvedorDeServicos.CriarServicoDeBuscaPeloCEPLocal: IServicoDeBuscaPeloCEP;
begin
  Result := TServicoDeBuscaPeloCEPLocal.Create(FRepositorioDeEnderecos);
end;

function TProvedorDeServicos.CriarServicoDeBuscaPeloCEPRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloCEP;
begin
  Result := TServicoDeBuscaPeloCEPRemoto.Create(FRepositorioDeEnderecos, CriarConsultaDeEnderecos(AEmXML));
end;

function TProvedorDeServicos.CriarServicoDeBuscaPeloEnderecoLocal: IServicoDeBuscaPeloEndereco;
begin
  Result := TServicoDeBuscaPeloEnderecoLocal.Create(FRepositorioDeEnderecos);
end;

function TProvedorDeServicos.CriarServicoDeBuscaPeloEnderecoRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloEndereco;
begin
  Result := TServicoDeBuscaPeloEnderecoRemoto.Create(FRepositorioDeEnderecos, CriarConsultaDeEnderecos(AEmXML));
end;

class function TProvedorDeServicos.Criar: TProvedorDeServicos;
var
  sNomeDoArquivoDeParametros: string;
  lParametros: TStrings;
begin
  sNomeDoArquivoDeParametros := ChangeFileExt(ParamStr(0), '.properties');
  if not FileExists(sNomeDoArquivoDeParametros) then
    raise EFileNotFoundException.Create('Arquivo de parâmetros não encontrado.');
  lParametros := TStringList.Create;
  try
    lParametros.LoadFromFile(sNomeDoArquivoDeParametros);
    Result := TProvedorDeServicos.Create(lParametros);
  finally
    FreeAndNil(lParametros);
  end;
end;

end.
