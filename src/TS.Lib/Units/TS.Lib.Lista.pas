unit TS.Lib.Lista;

interface

type
  //ILista
  ILista<T> = interface
    ['{56679246-BDCE-4368-9104-B6BF72AD8DA5}']
    function GetItem(const AIndice: Integer): T;
    procedure SetItem(const AIndice: Integer; const AValue: T);
    function GetQuantidade: Integer;
    function Adicionar(const AItem: T): Integer; overload;
    procedure Adicionar(const AItens: ILista<T>); overload;
    procedure Excluir(const AIndice: Integer);
    procedure Limpar;
    property Items[const AIndice: Integer]: T read GetItem write SetItem; default;
    property Quantidade: Integer read GetQuantidade;
  end;

implementation

end.
