unit TS.Aplicacao.ConsultaDeEnderecos;

interface

uses
  TS.Lib.Lista,
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco;

type
  //IConsultaDeEnderecos
  IConsultaDeEnderecos = interface
    ['{FD02CC4E-64BB-47AC-82B0-C69C27C6E9F7}']
    function Buscar(const ACEP: ICEP): IEndereco; overload;
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>; overload;
  end;

implementation

end.
