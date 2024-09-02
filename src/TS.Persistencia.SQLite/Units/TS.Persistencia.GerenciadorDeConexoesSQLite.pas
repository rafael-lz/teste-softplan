unit TS.Persistencia.GerenciadorDeConexoesSQLite;

interface

uses
  TS.Lib.Pool,
  FireDAC.Comp.Client;

type
  //TGerenciadorDeConexoesSQLite
  TGerenciadorDeConexoesSQLite = class sealed(TInterfacedObject, IPool<TFDConnection>)
  private const
    FNomeDaConexao = 'SQLite';
  private
    FGerenciador: TFDManager;
  public
    constructor Create(const ABancoDeDados: string);
    destructor Destroy; override;
    function Alocar: TFDConnection;
    procedure Desalocar(const AInstancia: TFDConnection);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  FireDAC.DApt,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  TS.Persistencia.GerenciadorDeConexoesSQLite.Erros;

{ TGerenciadorDeConexoesSQLite }

constructor TGerenciadorDeConexoesSQLite.Create(const ABancoDeDados: string);
var
  lParametros: TStrings;
begin
  if not FileExists(ABancoDeDados) then
    raise EArgumentException.CreateFmt('Banco de dados "%s" não encontrado.', [ABancoDeDados]);
  FGerenciador := TFDManager.Create(nil);
  lParametros := TStringList.Create;
  try
    lParametros.Add('Database=' + ABancoDeDados);
    lParametros.Add('Pooled=True');
    FGerenciador.AddConnectionDef(FNomeDaConexao, 'SQLite', lParametros);
  finally
    FreeAndNil(lParametros);
  end;
end;

destructor TGerenciadorDeConexoesSQLite.Destroy;
begin
  FGerenciador.CloseConnectionDef(FNomeDaConexao);
  FreeAndNil(FGerenciador);
  inherited;
end;

function TGerenciadorDeConexoesSQLite.Alocar: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  try
    Result.ConnectionDefName := FNomeDaConexao;
    Result.Connected := True;
  except
    on E: Exception do
    begin
      FreeAndNil(Result);
      raise EGerenciadorDeConexoesSQLite.Create('Não foi possível conectar no banco de dados.', E.Message);
    end;
  end;
end;

procedure TGerenciadorDeConexoesSQLite.Desalocar(const AInstancia: TFDConnection);
begin
  AInstancia.Close;
  AInstancia.Free;
end;

end.
