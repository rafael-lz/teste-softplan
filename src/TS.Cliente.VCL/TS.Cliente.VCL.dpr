program TS.Cliente.VCL;

uses
  System.SysUtils,
  System.UITypes,
  VCL.Forms,
  VCL.Dialogs,
  TS.Cliente.ProvedorDeServicos.Padrao,
  TS.Cliente.Principal in 'Units\TS.Cliente.Principal.pas' {frmPrincipal},
  TS.Cliente.Enderecos in 'Units\TS.Cliente.Enderecos.pas' {frmEnderecos},
  TS.Cliente.Consulta in 'Units\TS.Cliente.Consulta.pas',
  TS.Cliente.ConsultaPorCEP in 'Units\TS.Cliente.ConsultaPorCEP.pas' {frmConsultaPorCEP},
  TS.Cliente.ConsultaPorEndereco in 'Units\TS.Cliente.ConsultaPorEndereco.pas' {frmConsultaPorEndereco};

{$R *.res}

var
  ptrMainForm: ^TForm;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Teste - Softplan';
  ptrMainForm := @Application.MainForm;
  try
    ptrMainForm^ := TfrmPrincipal.Create(Application, TProvedorDeServicos.Criar);
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOk], 0);
  end;

  Application.Run;
end.
