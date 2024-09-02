unit TS.Aplicacao.ServicoDeBuscaPeloEndereco;

interface

uses
  TS.Lib.Lista,
  TS.Modelo.UF,
  TS.Modelo.Endereco;

type
  //IServicoDeBuscaPeloEndereco
  IServicoDeBuscaPeloEndereco = interface
    ['{DBCDD19A-E661-4BEB-A0C0-AD47A0FE9034}']
    function Buscar(const AUF: IUF; const ALocalidade, ALogradouro: string): ILista<IEndereco>;
  end;

implementation

end.
