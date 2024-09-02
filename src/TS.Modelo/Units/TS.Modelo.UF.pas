unit TS.Modelo.UF;

interface

type
  //IUF
  IUF = interface
    ['{656E47B7-0921-4D73-B173-E4D6983BB3A1}']
    function GetSigla: string;
    property Sigla: string read GetSigla;
  end;

implementation

end.
