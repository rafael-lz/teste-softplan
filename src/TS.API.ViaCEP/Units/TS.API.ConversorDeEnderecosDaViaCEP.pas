unit TS.API.ConversorDeEnderecosDaViaCEP;

interface

uses
  System.Classes,
  TS.Lib.Lista,
  TS.Modelo.Endereco;

type
  //IConversorDeEnderecosDaViaCEP
  IConversorDeEnderecosDaViaCEP = interface
    ['{C832B18B-C680-459A-B057-4B7E9068E142}']
    function GetFormato: string;
    function Converter(const ADados: TStream): ILista<IEndereco>;
    property Formato: string read GetFormato;
  end;

implementation

end.
