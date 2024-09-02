unit TS.API.ConversorDeEnderecosDaViaCEP.EmXML;

interface

uses
  System.Classes,
  XML.XMLIntf,
  TS.Lib.Lista,
  TS.Modelo.Endereco,
  TS.API.ConversorDeEnderecosDaViaCEP;

type
  //TConversorDeEnderecosDaViaCEPEmXML
  TConversorDeEnderecosDaViaCEPEmXML = class sealed(TInterfacedObject, IConversorDeEnderecosDaViaCEP)
  private const
    FEnderecos = 'enderecos';
    FCEP = 'cep';
    FLogradouro = 'logradouro';
    FComplemento = 'complemento';
    FBairro = 'bairro';
    FLocalidade = 'localidade';
    FUF = 'uf';
  private
    FFormato: string;
    function GetFormato: string;
    function LerEnderecos(const AEnderecos: IXMLNode): ILista<IEndereco>;
    function LerEndereco(const AEndereco: IXMLNode): IEndereco;
  public
    constructor Create;
    destructor Destroy; override;
    function Converter(const ADados: TStream): ILista<IEndereco>;
    property Formato: string read GetFormato;
  end;

implementation

uses
  System.SysUtils,
  WinAPI.ActiveX,
  XML.XMLDoc,
  TS.Lib.Lista.Utils,
  TS.Modelo.CEP,
  TS.Modelo.CEP.Utils,
  TS.Modelo.UF,
  TS.Modelo.UF.Utils,
  TS.Modelo.ConstrutorDeEndereco,
  TS.Modelo.ConstrutorDeEndereco.Utils;

{ TConversorDeEnderecosDaViaCEPEmXML }

constructor TConversorDeEnderecosDaViaCEPEmXML.Create;
begin
  FFormato := 'xml';
  CoInitialize(nil);
end;

destructor TConversorDeEnderecosDaViaCEPEmXML.Destroy;
begin
  CoUninitialize;
  inherited;
end;

function TConversorDeEnderecosDaViaCEPEmXML.GetFormato: string;
begin
  Result := FFormato;
end;

function TConversorDeEnderecosDaViaCEPEmXML.LerEnderecos(const AEnderecos: IXMLNode): ILista<IEndereco>;
var
  I: Integer;
begin
  Result := TListas.Criar<IEndereco>;
  for I := 0 to Pred(AEnderecos.ChildNodes.Count) do
    Result.Adicionar(LerEndereco(AEnderecos.ChildNodes[I]));
end;

function TConversorDeEnderecosDaViaCEPEmXML.LerEndereco(const AEndereco: IXMLNode): IEndereco;
  function ProcurarNodo(const ANome: string; out ANodo: IXMLNode): Boolean;
  begin
    ANodo := AEndereco.ChildNodes.FindNode(ANome);
    Result := Assigned(ANodo);
  end;
var
  lConstrutor: IConstrutorDeEndereco;
  lNodo: IXMLNode;
begin
  lConstrutor := CriarConstrutorDeEndereco;
  if ProcurarNodo(FCEP, lNodo) then
    lConstrutor.ComCEP(CEPDe(lNodo.Text));
  if ProcurarNodo(FLogradouro, lNodo) then
    lConstrutor.ComLogradouro(lNodo.Text);
  if ProcurarNodo(FComplemento, lNodo) then
    lConstrutor.ComComplemento(lNodo.Text);
  if ProcurarNodo(FBairro, lNodo) then
    lConstrutor.ComBairro(lNodo.Text);
  if ProcurarNodo(FLocalidade, lNodo) then
    lConstrutor.ComLocalidade(lNodo.Text);
  if ProcurarNodo(FUF, lNodo) then
    lConstrutor.ComUF(CriarUF(lNodo.Text));
  Result := lConstrutor.Construir;
end;

function TConversorDeEnderecosDaViaCEPEmXML.Converter(const ADados: TStream): ILista<IEndereco>;
var
  lXML: IXMLDocument;
  lEnderecos: IXMLNode;
begin
  if not Assigned(ADados) then
    raise EArgumentNilException.Create('Os dados são obrigatórios.');
  Result := TListas.Criar<IEndereco>;
  lXML := TXMLDocument.Create(nil);
  lXML.LoadFromStream(ADados);
  if Assigned(lXML.DocumentElement.ChildNodes.FindNode(FCEP)) then
    Result.Adicionar(LerEndereco(lXML.DocumentElement))
  else
  begin
    lEnderecos := lXML.DocumentElement.ChildNodes.FindNode(FEnderecos);
    if Assigned(lEnderecos) then
      Result.Adicionar(LerEnderecos(lEnderecos));
  end;
end;

end.
