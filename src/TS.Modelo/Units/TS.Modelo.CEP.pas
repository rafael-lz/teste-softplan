unit TS.Modelo.CEP;

interface

type
  //ICEP
  ICEP = interface
    ['{311B01E3-CDA9-4962-9116-8B4F0070F69E}']
    function GetNumero: string;
    function Formatar: string;
    property Numero: string read GetNumero;
  end;

implementation

end.
