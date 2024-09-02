unit TS.Modelo.Endereco;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.UF;

type
  //IEndereco
  IEndereco = interface
    ['{72D9E123-63EF-4CBB-A430-3C5A9E8CE0D0}']
    function GetCEP: ICEP;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetLocalidade: string;
    function GetUF: IUF;
    property CEP: ICEP read GetCEP;
    property Logradouro: string read GetLogradouro;
    property Complemento: string read GetComplemento;
    property Bairro: string read GetBairro;
    property Localidade: string read GetLocalidade;
    property UF: IUF read GetUF;
  end;

implementation

end.
