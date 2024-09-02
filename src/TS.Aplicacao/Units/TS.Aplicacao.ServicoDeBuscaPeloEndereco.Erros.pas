unit TS.Aplicacao.ServicoDeBuscaPeloEndereco.Erros;

interface

uses
  System.SysUtils;

type
  //Erros
  ELogradouroInvalido = class sealed(Exception);
  ELocalidadeInvalida = class sealed(Exception);
  EUFInvalida = class sealed(Exception);

implementation

end.
