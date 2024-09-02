unit TS.Persistencia.RepositorioDeEnderecosSQLite;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  TS.Lib.Lista,
  TS.Lib.Pool,
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Aplicacao.RepositorioDeEnderecos;

type
  //TRepositorioDeEnderecosSQLite
  TRepositorioDeEnderecosSQLite = class sealed(TInterfacedObject, IRepositorioDeEnderecos)
  private const
    FEndereco = 'endereco';
    FCodigo = 'codigo';
    FCEP = 'cep';
    FLogradouro = 'logradouro';
    FComplemento = 'complemento';
    FBairro = 'bairro';
    FLocalidade = 'localidade';
    FUF = 'uf';
  private
    FGerenciadorDeConexoes: IPool<TFDConnection>;
    function ConcatenarCampos: string;
    function LerEnderecos(const AConsulta: TDataSet): ILista<IEndereco>;
    function LerEndereco(const AConsulta: TDataSet): IEndereco;
  public
    constructor Create(const AGerenciadorDeConexoes: IPool<TFDConnection>);
    procedure Incluir(const AEndereco: IEndereco);
    procedure Alterar(const AEndereco: IEndereco);
    function Buscar(const ACEP: ICEP): IEndereco; overload;
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>; overload;
    function Existe(const ACEP: ICEP): Boolean;
  end;

implementation

uses
  System.SysUtils,
  TS.Lib.Lista.Utils,
  TS.Modelo.CEP.Utils,
  TS.Modelo.UF.Utils,
  TS.Modelo.ConstrutorDeEndereco.Utils;

{ TRepositorioDeEnderecosSQLite }

constructor TRepositorioDeEnderecosSQLite.Create(const AGerenciadorDeConexoes: IPool<TFDConnection>);
begin
  if not Assigned(AGerenciadorDeConexoes) then
    raise EArgumentNilException.Create('O gerenciador de conexões é obrigatório.');
  FGerenciadorDeConexoes := AGerenciadorDeConexoes;
end;

function TRepositorioDeEnderecosSQLite.ConcatenarCampos: string;
var
  lCampos: TStringBuilder;
begin
  lCampos := TStringBuilder.Create(FCodigo);
  try
    lCampos.Append(', ').Append(FCEP)
      .Append(', ').Append(FLogradouro)
      .Append(', ').Append(FComplemento)
      .Append(', ').Append(FBairro)
      .Append(', ').Append(FLocalidade)
      .Append(', ').Append(FUF);
    Result := lCampos.ToString;
  finally
    FreeAndNil(lCampos);
  end;
end;

function TRepositorioDeEnderecosSQLite.LerEnderecos(const AConsulta: TDataSet): ILista<IEndereco>;
begin
  Result := TListas.Criar<IEndereco>;
  while not AConsulta.Eof do
  begin
    Result.Adicionar(LerEndereco(AConsulta));
    AConsulta.Next;
  end;
end;

function TRepositorioDeEnderecosSQLite.LerEndereco(const AConsulta: TDataSet): IEndereco;
begin
  Result := CriarConstrutorDeEndereco
    .ComCEP(CriarCEP(AConsulta.FieldByName(FCEP).AsString))
    .ComLogradouro(AConsulta.FieldByName(FLogradouro).AsString)
    .ComComplemento(AConsulta.FieldByName(FComplemento).AsString)
    .ComBairro(AConsulta.FieldByName(FBairro).AsString)
    .ComLocalidade(AConsulta.FieldByName(FLocalidade).AsString)
    .ComUF(CriarUF(AConsulta.FieldByName(FUF).AsString))
    .Construir;
end;

procedure TRepositorioDeEnderecosSQLite.Incluir(const AEndereco: IEndereco);
var
  lConexao: TFDConnection;
  lComando: TFDQuery;
  lSQL: TStringBuilder;
begin
  lConexao := FGerenciadorDeConexoes.Alocar;
  try
    lComando := TFDQuery.Create(nil);
    try
      lComando.Connection := lConexao;
      lSQL := TStringBuilder.Create;
      try
        lSQL.Append('INSERT INTO ').Append(FEndereco).Append(' (').AppendLine;
        lSQL.Append('    ').Append(FCEP).AppendLine;
        lSQL.Append('  , ').Append(FLogradouro).AppendLine;
        lSQL.Append('  , ').Append(FComplemento).AppendLine;
        lSQL.Append('  , ').Append(FBairro).AppendLine;
        lSQL.Append('  , ').Append(FLocalidade).AppendLine;
        lSQL.Append('  , ').Append(FUF).AppendLine;
        lSQL.Append(')').AppendLine;
        lSQL.Append('VALUES (').AppendLine;
        lSQL.Append('    :').Append(FCEP).AppendLine;
        lSQL.Append('  , :').Append(FLogradouro).AppendLine;
        lSQL.Append('  , :').Append(FComplemento).AppendLine;
        lSQL.Append('  , :').Append(FBairro).AppendLine;
        lSQL.Append('  , :').Append(FLocalidade).AppendLine;
        lSQL.Append('  , :').Append(FUF).AppendLine;
        lSQL.Append(')');
        lComando.SQL.Text := lSQL.ToString;
      finally
        FreeAndNil(lSQL);
      end;

      lComando.ParamByName(FCEP).AsString := AEndereco.CEP.Numero;
      lComando.ParamByName(FLogradouro).AsString := AEndereco.Logradouro;
      lComando.ParamByName(FComplemento).AsString := AEndereco.Complemento;
      lComando.ParamByName(FBairro).AsString := AEndereco.Bairro;
      lComando.ParamByName(FLocalidade).AsString := AEndereco.Localidade;
      lComando.ParamByName(FUF).AsString := AEndereco.UF.Sigla;
      lComando.ExecSQL;
    finally
      FreeAndNil(lComando);
    end;
  finally
    FGerenciadorDeConexoes.Desalocar(lConexao);
  end;
end;

procedure TRepositorioDeEnderecosSQLite.Alterar(const AEndereco: IEndereco);
var
  lConexao: TFDConnection;
  lComando: TFDQuery;
  lSQL: TStringBuilder;
begin
  lConexao := FGerenciadorDeConexoes.Alocar;
  try
    lComando := TFDQuery.Create(nil);
    try
      lComando.Connection := lConexao;
      lSQL := TStringBuilder.Create;
      try
        lSQL.Append('UPDATE ').Append(FEndereco).AppendLine;
        lSQL.Append('   SET ').Append(FLogradouro).Append(' = :').Append(FLogradouro).AppendLine;
        lSQL.Append('     , ').Append(FComplemento).Append(' = :').Append(FComplemento).AppendLine;
        lSQL.Append('     , ').Append(FBairro).Append(' = :').Append(FBairro).AppendLine;
        lSQL.Append('     , ').Append(FLocalidade).Append(' = :').Append(FLocalidade).AppendLine;
        lSQL.Append('     , ').Append(FUF).Append(' = :').Append(FUF).AppendLine;
        lSQL.Append(' WHERE ').Append(FCEP).Append(' = :').Append(FCEP);
        lComando.SQL.Text := lSQL.ToString;
      finally
        FreeAndNil(lSQL);
      end;

      lComando.ParamByName(FLogradouro).AsString := AEndereco.Logradouro;
      lComando.ParamByName(FComplemento).AsString := AEndereco.Complemento;
      lComando.ParamByName(FBairro).AsString := AEndereco.Bairro;
      lComando.ParamByName(FLocalidade).AsString := AEndereco.Localidade;
      lComando.ParamByName(FUF).AsString := AEndereco.UF.Sigla;
      lComando.ParamByName(FCEP).AsString := AEndereco.CEP.Numero;
      lComando.ExecSQL;
    finally
      FreeAndNil(lComando);
    end;
  finally
    FGerenciadorDeConexoes.Desalocar(lConexao);
  end;
end;

function TRepositorioDeEnderecosSQLite.Buscar(const ACEP: ICEP): IEndereco;
var
  lConexao: TFDConnection;
  lConsulta: TFDQuery;
  lSQL: TStringBuilder;
begin
  if not Assigned(ACEP) then
    raise EArgumentNilException.Create('O CEP é obrigatório.');
  lConexao := FGerenciadorDeConexoes.Alocar;
  try
    lConsulta := TFDQuery.Create(nil);
    try
      lConsulta.Connection := lConexao;
      lSQL := TStringBuilder.Create;
      try
        lSQL.Append('SELECT ').Append(ConcatenarCampos).AppendLine;
        lSQL.Append('  FROM ').Append(FEndereco).AppendLine;;
        lSQL.Append(' WHERE ').Append(FCEP).Append(' = :').Append(FCEP);
        lConsulta.SQL.Text := lSQL.ToString;
      finally
        FreeAndNil(lSQL);
      end;

      lConsulta.ParamByName(FCEP).AsString := ACEP.Numero;
      lConsulta.Open;
      if not lConsulta.IsEmpty then
        Result := LerEndereco(lConsulta)
      else
        Result := nil;
    finally
      FreeAndNil(lConsulta);
    end;
  finally
    FGerenciadorDeConexoes.Desalocar(lConexao);
  end;
end;

function TRepositorioDeEnderecosSQLite.Buscar(const AUF: IUF; const ALocalidade,
  ALogradouro: string): ILista<IEndereco>;
const
  sCollate = 'COLLATE NOCASE';
var
  lConexao: TFDConnection;
  lConsulta: TFDQuery;
  lSQL: TStringBuilder;
begin
  if not Assigned(AUF) then
    raise EArgumentNilException.Create('A UF é obrigatória.');
  lConexao := FGerenciadorDeConexoes.Alocar;
  try
    lConsulta := TFDQuery.Create(nil);
    try
      lConsulta.Connection := lConexao;
      lSQL := TStringBuilder.Create;
      try
        lSQL.Append('SELECT ').Append(ConcatenarCampos).AppendLine;
        lSQL.Append('  FROM ').Append(FEndereco).AppendLine;;
        lSQL.Append(' WHERE ').Append(FLogradouro).Append(' = :').Append(FLogradouro).Append(' ').Append(sCollate).AppendLine;
        lSQL.Append('   AND ').Append(FLocalidade).Append(' = :').Append(FLocalidade).Append(' ').Append(sCollate).AppendLine;
        lSQL.Append('   AND ').Append(FUF).Append(' = :').Append(FUF);
        lConsulta.SQL.Text := lSQL.ToString;
      finally
        FreeAndNil(lSQL);
      end;

      lConsulta.ParamByName(FLogradouro).AsString := ALogradouro;
      lConsulta.ParamByName(FLocalidade).AsString := ALocalidade;
      lConsulta.ParamByName(FUF).AsString := AUF.Sigla;
      lConsulta.Open;
      Result := LerEnderecos(lConsulta);
    finally
      FreeAndNil(lConsulta);
    end;
  finally
    FGerenciadorDeConexoes.Desalocar(lConexao);
  end;
end;

function TRepositorioDeEnderecosSQLite.Existe(const ACEP: ICEP): Boolean;
var
  lConexao: TFDConnection;
  lConsulta: TFDQuery;
  lSQL: TStringBuilder;
begin
  if not Assigned(ACEP) then
    raise EArgumentNilException.Create('O CEP é obrigatório.');
  lConexao := FGerenciadorDeConexoes.Alocar;
  try
    lConsulta := TFDQuery.Create(nil);
    try
      lConsulta.Connection := lConexao;
      lSQL := TStringBuilder.Create;
      try
        lSQL.Append('SELECT ').Append(FCodigo).AppendLine;
        lSQL.Append('  FROM ').Append(FEndereco).AppendLine;;
        lSQL.Append(' WHERE ').Append(FCEP).Append(' = :').Append(FCEP);
        lConsulta.SQL.Text := lSQL.ToString;
      finally
        FreeAndNil(lSQL);
      end;

      lConsulta.ParamByName(FCEP).AsString := ACEP.Numero;
      lConsulta.Open;
      Result := lConsulta.FieldByName(FCodigo).AsInteger > 0;
    finally
      FreeAndNil(lConsulta);
    end;
  finally
    FGerenciadorDeConexoes.Desalocar(lConexao);
  end;
end;

end.
