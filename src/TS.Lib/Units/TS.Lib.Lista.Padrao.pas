unit TS.Lib.Lista.Padrao;

interface

uses
  System.Generics.Collections,
  TS.Lib.Lista;

type
  //TLista<T>
  TLista<T> = class sealed(TInterfacedObject, ILista<T>)
  private
    FItens: System.Generics.Collections.TList<T>;
    function GetItem(const AIndice: Integer): T;
    procedure SetItem(const AIndice: Integer; const AValue: T);
    function GetQuantidade: Integer;
    procedure ChecarIndice(const AIndice: Integer);
  public
    constructor Create; overload;
    constructor Create(const AItens: ILista<T>); overload;
    destructor Destroy; override;
    function Adicionar(const AItem: T): Integer; overload;
    procedure Adicionar(const AItens: ILista<T>); overload;
    procedure Excluir(const AIndice: Integer);
    procedure Limpar;
    property Items[const AIndice: Integer]: T read GetItem write SetItem; default;
    property Quantidade: Integer read GetQuantidade;
  end;

implementation

uses
  System.SysUtils;

{ TLista<T> }

constructor TLista<T>.Create;
begin
  FItens := System.Generics.Collections.TList<T>.Create;
end;

constructor TLista<T>.Create(const AItens: ILista<T>);
begin
  Create;
  Adicionar(AItens);
end;

destructor TLista<T>.Destroy;
begin
  FreeAndNil(FItens);
  inherited;
end;

function TLista<T>.GetItem(const AIndice: Integer): T;
begin
  ChecarIndice(AIndice);
  Result := FItens[AIndice];
end;

procedure TLista<T>.SetItem(const AIndice: Integer; const AValue: T);
begin
  ChecarIndice(AIndice);
  FItens[AIndice] := AValue;
end;

function TLista<T>.GetQuantidade: Integer;
begin
  Result := FItens.Count;
end;

procedure TLista<T>.ChecarIndice(const AIndice: Integer);
begin
  if (AIndice < 0) and (AIndice >= Quantidade) then
    raise EListError.CreateFmt('O índice %d é inválido.', [AIndice]);
end;

function TLista<T>.Adicionar(const AItem: T): Integer;
begin
  Result := FItens.Add(AItem);
end;

procedure TLista<T>.Adicionar(const AItens: ILista<T>);
var
  I: Integer;
begin
  if not Assigned(AItens) then
    raise EArgumentNilException.Create('Os itens são obrigatórios.');
  for I := 0 to Pred(AItens.Quantidade) do
    Adicionar(AItens[I]);
end;

procedure TLista<T>.Excluir(const AIndice: Integer);
begin
  ChecarIndice(AIndice);
  FItens.Delete(AIndice);
end;

procedure TLista<T>.Limpar;
begin
  FItens.Clear;
end;

end.
