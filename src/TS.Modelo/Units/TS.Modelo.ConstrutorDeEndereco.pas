unit TS.Modelo.ConstrutorDeEndereco;

interface

uses
  TS.Modelo.CEP,
  TS.Modelo.UF,
  TS.Modelo.Endereco;

type
  //IConstrutorDeEndereco
  IConstrutorDeEndereco = interface
    ['{78FF0F95-02E8-444C-BC41-ED35579475DF}']
    function GetCEP: ICEP;
    function GetLogradouro: string;
    function GetComplemento: string;
    function GetBairro: string;
    function GetLocalidade: string;
    function GetUF: IUF;
    function ComCEP(const AValor: ICEP): IConstrutorDeEndereco;
    function ComLogradouro(const AValor: string): IConstrutorDeEndereco;
    function ComComplemento(const AValor: string): IConstrutorDeEndereco;
    function ComBairro(const AValor: string): IConstrutorDeEndereco;
    function ComLocalidade(const AValor: string): IConstrutorDeEndereco;
    function ComUF(const AValor: IUF): IConstrutorDeEndereco;
    function Construir: IEndereco;
    property CEP: ICEP read GetCEP;
    property Logradouro: string read GetLogradouro;
    property Complemento: string read GetComplemento;
    property Bairro: string read GetBairro;
    property Localidade: string read GetLocalidade;
    property UF: IUF read GetUF;
  end;

implementation

end.
