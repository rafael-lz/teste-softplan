unit TS.API.ConsultaDeEnderecosPelaViaCEP;

interface

uses
  IDHTTP,
  TS.Lib.Lista,
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Aplicacao.ConsultaDeEnderecos,
  TS.API.ConversorDeEnderecosDaViaCEP;

type
  //TConsultaDeEnderecosPelaViaCEP
  TConsultaDeEnderecosPelaViaCEP = class sealed(TInterfacedObject, IConsultaDeEnderecos)
  private const
    FDelimitadorDeURL = '/';
  private
    FEnderecoDaAPI: string;
    FConversorDeEnderecos: IConversorDeEnderecosDaViaCEP;
    FHTTP: TIDHTTP;
    function ExecutarAPI(const AURL: string): ILista<IEndereco>;
  public
    constructor Create(const AEnderecoDaAPI: string; const AConversorDeEnderecos: IConversorDeEnderecosDaViaCEP);
    destructor Destroy; override;
    function Buscar(const ACEP: ICEP): IEndereco; overload;
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>; overload;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  IDURI,
  IDSSLOpenSSL,
  TS.Lib.Lista.Utils,
  TS.Aplicacao.ConsultaDeEnderecos.Erros;

{ TConsultaDeEnderecosPelaViaCEP }

constructor TConsultaDeEnderecosPelaViaCEP.Create(const AEnderecoDaAPI: string;
  const AConversorDeEnderecos: IConversorDeEnderecosDaViaCEP);
begin
  if AEnderecoDaAPI = '' then
    raise EArgumentException.Create('O endereço da API é obrigatório.');
  if not Assigned(AConversorDeEnderecos) then
    raise EArgumentNilException.Create('O conversor de endereços é obrigatório.');
  FEnderecoDaAPI := AEnderecoDaAPI + IfThen(EndsStr(AEnderecoDaAPI, FDelimitadorDeURL), FDelimitadorDeURL, '');
  FConversorDeEnderecos := AConversorDeEnderecos;
  FHTTP := TIDHTTP.Create(nil);
  FHTTP.IOHandler := TIDSSLIOHandlerSocketOpenSSL.Create(FHTTP);
  TIDSSLIOHandlerSocketOpenSSL(FHTTP.IOHandler).SSLOptions.Method := sslvTLSv1_2;
end;

destructor TConsultaDeEnderecosPelaViaCEP.Destroy;
begin
  FreeAndNil(FHTTP);
  inherited;
end;

function TConsultaDeEnderecosPelaViaCEP.ExecutarAPI(const AURL: string): ILista<IEndereco>;
var
  lResposta: TStream;
begin
  lResposta := TMemoryStream.Create;
  try
    try
      FHTTP.Get(AURL + FDelimitadorDeURL + FConversorDeEnderecos.Formato, lResposta);
    except
      on E: Exception do
        raise EConsultaDeEnderecos.Create('Não foi possível executar a consulta de endereços.', E.Message);
    end;

    if lResposta.Size > 0 then
    begin
      lResposta.Position := 0;
      Result := FConversorDeEnderecos.Converter(lResposta);
    end
    else
      Result := TListas.Criar<IEndereco>;
  finally
    FreeAndNil(lResposta);
  end;
end;

function TConsultaDeEnderecosPelaViaCEP.Buscar(const ACEP: ICEP): IEndereco;
var
  lEnderecos: ILista<IEndereco>;
begin
  if not Assigned(ACEP) then
    raise EArgumentNilException.Create('O CEP é obrigatório.');
  lEnderecos := ExecutarAPI(FEnderecoDaAPI + FDelimitadorDeURL + ACEP.Numero);
  if lEnderecos.Quantidade > 0 then
    Result := lEnderecos[0]
  else
    Result := nil;
end;

function TConsultaDeEnderecosPelaViaCEP.Buscar(const AUF: IUF; const ALocalidade,
  ALogradouro: string): ILista<IEndereco>;
begin
  if not Assigned(AUF) then
    raise EArgumentNilException.Create('A UF é obrigatória.');
  Result := ExecutarAPI(FEnderecoDaAPI +
    FDelimitadorDeURL + AUF.Sigla +
    FDelimitadorDeURL + TIDURI.ParamsEncode(ALocalidade) +
    FDelimitadorDeURL + TIDURI.ParamsEncode(ALogradouro));
end;

end.
