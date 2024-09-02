unit TS.Cliente.ProvedorDeServicos;

interface

uses
  TS.Aplicacao.ServicoDeBuscaPeloCEP,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco;

type
  //IProvedorDeServicos
  IProvedorDeServicos = interface
    ['{7B2DFE76-D9B6-409F-BC8E-AB1C232D2F00}']
    function CriarServicoDeBuscaPeloCEPLocal: IServicoDeBuscaPeloCEP;
    function CriarServicoDeBuscaPeloCEPRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloCEP;
    function CriarServicoDeBuscaPeloEnderecoLocal: IServicoDeBuscaPeloEndereco;
    function CriarServicoDeBuscaPeloEnderecoRemoto(const AEmXML: Boolean): IServicoDeBuscaPeloEndereco;
  end;

implementation

end.
