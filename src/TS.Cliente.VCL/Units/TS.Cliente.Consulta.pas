unit TS.Cliente.Consulta;

interface

uses
  System.Classes,
  VCL.Forms,
  TS.Lib.Lista,
  TS.Modelo.Endereco,
  TS.Cliente.ProvedorDeServicos,
  TS.Cliente.Enderecos;

type
  //TfrmConsulta
  TfrmConsulta = class abstract(TForm)
  private
    FProvedorDeServicos: IProvedorDeServicos;
    FEnderecos: TfrmEnderecos;
  protected
    procedure MostrarEndereco(const AEndereco: IEndereco);
    procedure MostrarEnderecos(const AEnderecos: ILista<IEndereco>);
    property ProvedorDeServicos: IProvedorDeServicos read FProvedorDeServicos;
    property Enderecos: TfrmEnderecos read FEnderecos;
  public
    procedure Focar; virtual; abstract;
    constructor Create(const AOwner: TComponent; const AProvedorDeServicos: IProvedorDeServicos); reintroduce;
  end;

  //Referências
  TTelaDeConsulta = class of TfrmConsulta;

implementation

uses
  System.SysUtils,
  VCL.Controls,
  TS.Lib.Lista.Utils;

{ TfrmConsulta }

constructor TfrmConsulta.Create(const AOwner: TComponent; const AProvedorDeServicos: IProvedorDeServicos);
begin
  inherited Create(AOwner);
  if not Assigned(AProvedorDeServicos) then
    raise EArgumentNilException.Create('O provedor de serviços é obrigatório.');
  FProvedorDeServicos := AProvedorDeServicos;
  FProvedorDeServicos := AProvedorDeServicos;
  FEnderecos := TfrmEnderecos.Create(Self);
  FEnderecos.Parent := Self;
  FEnderecos.BorderStyle := bsNone;
  FEnderecos.Align := alClient;
  FEnderecos.Show;
end;

procedure TfrmConsulta.MostrarEndereco(const AEndereco: IEndereco);
var
  lEnderecos: ILista<IEndereco>;
begin
  lEnderecos := TListas.Criar<IEndereco>;
  if Assigned(AEndereco) then
    lEnderecos.Adicionar(AEndereco);
  MostrarEnderecos(lEnderecos);
end;

procedure TfrmConsulta.MostrarEnderecos(const AEnderecos: ILista<IEndereco>);
begin
  Enderecos.Preencher(AEnderecos);
end;

end.
