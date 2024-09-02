unit TS.Aplicacao.RepositorioDeEnderecos;

interface

uses
  TS.Lib.Lista,
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco;

type
  //IRepositorioDeEnderecos
  IRepositorioDeEnderecos = interface
    ['{65C6DF7D-4779-4665-83D8-BA500E18874A}']
    procedure Incluir(const AEndereco: IEndereco);
    procedure Alterar(const AEndereco: IEndereco);
    function Buscar(const ACEP: ICEP): IEndereco; overload;
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>; overload;
    function Existe(const ACEP: ICEP): Boolean;
  end;

implementation

end.
