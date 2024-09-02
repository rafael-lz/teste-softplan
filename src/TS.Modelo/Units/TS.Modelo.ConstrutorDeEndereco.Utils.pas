unit TS.Modelo.ConstrutorDeEndereco.Utils;

interface

uses
  TS.Modelo.ConstrutorDeEndereco;

//Utils
function CriarConstrutorDeEndereco: IConstrutorDeEndereco;

implementation

uses
  TS.Modelo.ConstrutorDeEndereco.Padrao;

//Utils
function CriarConstrutorDeEndereco: IConstrutorDeEndereco;
begin
  Result := TConstrutorDeEndereco.Create;
end;

end.
