unit TS.Cliente.Enderecos;

interface

uses
  System.Classes,
  VCL.Controls,
  VCL.Forms,
  VCL.ComCtrls,
  VCL.StdCtrls,
  VCL.ExtCtrls,
  TS.Lib.Lista,
  TS.Modelo.Endereco;

type
  //TfrmEnderecos
  TfrmEnderecos = class sealed(TForm)
    pnlEnderecos: TPanel;
    lvEnderecos: TListView;
  public
    procedure Preencher(const AEnderecos: ILista<IEndereco>);
  end;

implementation

uses
  System.SysUtils;

{$R *.dfm}

{ TfrmEnderecos }

procedure TfrmEnderecos.Preencher(const AEnderecos: ILista<IEndereco>);
var
  lEndereco: TListItem;
  I: Integer;
begin
  if not Assigned(AEnderecos) then
    raise EArgumentNilException.Create('Os endereços são obrigatórios.');
  lvEnderecos.Items.BeginUpdate;
  try
    lvEnderecos.Items.Clear;
    for I := 0 to Pred(AEnderecos.Quantidade) do
    begin
      lEndereco := lvEnderecos.Items.Add;
      lEndereco.Caption := AEnderecos[I].CEP.Formatar;
      lEndereco.SubItems.Add(AEnderecos[I].Logradouro);
      lEndereco.SubItems.Add(AEnderecos[I].Complemento);
      lEndereco.SubItems.Add(AEnderecos[I].Bairro);
      lEndereco.SubItems.Add(AEnderecos[I].Localidade);
      lEndereco.SubItems.Add(AEnderecos[I].UF.Sigla);
    end;
  finally
    lvEnderecos.Items.EndUpdate;
  end;

  lvEnderecos.Visible := lvEnderecos.Items.Count > 0;
  pnlEnderecos.Visible := not lvEnderecos.Visible;
end;

end.
