unit TS.Lib.Falha;

interface

uses
  System.SysUtils;

type
  //EFalha
  EFalha = class abstract(Exception)
  private
    FDetalhes: string;
  public
    constructor Create(const AMensagem, ADetalhes: string);
    property Detalhes: string read FDetalhes;
  end;

implementation

{ EFalha }

constructor EFalha.Create(const AMensagem, ADetalhes: string);
begin
  inherited Create(AMensagem);
  FDetalhes := ADetalhes;
end;

end.
