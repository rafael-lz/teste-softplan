unit TS.Lib.Pool;

interface

type
  //IPool
  IPool<T> = interface
    ['{A1748C6B-4DEE-4F0B-BAD3-CC42C16E7939}']
    function Alocar: T;
    procedure Desalocar(const AInstancia: T);
  end;

implementation

end.
