unit TS.Aplicacao.ServicoDeBuscaPeloCEP;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.Endereco;

type
  //IServicoDeBuscaPeloCEP
  IServicoDeBuscaPeloCEP = interface
    ['{8665F5BC-2798-4D22-B633-F328F659DE23}']
    function Buscar(const ACEP: ICEP): IEndereco;
  end;

implementation

end.
