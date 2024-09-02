unit TS.Lib.Lista.Utils;

interface

uses
  TS.Lib.Lista;

type
  //TListas
  TListas = class sealed
  public
    class function Criar<T>: ILista<T>; overload;
    class function Criar<T>(const AItens: ILista<T>): ILista<T>; overload;
  end;

implementation

uses
  TS.Lib.Lista.Padrao;

{ TListas }

class function TListas.Criar<T>: ILista<T>;
begin
  Result := TLista<T>.Create;
end;

class function TListas.Criar<T>(const AItens: ILista<T>): ILista<T>;
begin
  Result := TLista<T>.Create(AItens);
end;

end.
