unit TS.Cliente.ConsultaPorCEP;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Controls,
  VCL.Forms,
  VCL.StdCtrls,
  VCL.Mask,
  VCL.ExtCtrls,
  TS.Modelo.CEP,
  TS.Modelo.Endereco,
  TS.Cliente.Consulta;

type
  //TfrmConsultaPorCEP
  TfrmConsultaPorCEP = class sealed(TfrmConsulta)
    pnlConsulta: TPanel;
    lblCEP: TLabel;
    edtCEP: TMaskEdit;
    lblRetorno: TLabel;
    rbJSON: TRadioButton;
    rbXML: TRadioButton;
    btnConsultar: TButton;
    procedure btnConsultarClick(Sender: TObject);
  private
    function LerCEP(out ACEP: ICEP): Boolean;
    procedure ConsultarCEPLocal(const ACEP: ICEP; const ASucesso: TProc<IEndereco>; const AFalha: TProc<Exception>);
    procedure ConsultarCEPRemoto(const ACEP: ICEP; const AEmXML: Boolean; const ASucesso: TProc<IEndereco>;
      const AFalha: TProc<Exception>);
    procedure MostrarErro(const AErro: Exception);
  public
    procedure Focar; override;
  end;

implementation

uses
  System.Threading,
  System.UITypes,
  VCL.Dialogs,
  TS.Modelo.CEP.Utils,
  TS.Aplicacao.ServicoDeBuscaPeloCEP,
  TS.Aplicacao.ServicoDeBuscaPeloCEP.Erros;

{$R *.dfm}

{ TfrmConsultaPorCEP }

function TfrmConsultaPorCEP.LerCEP(out ACEP: ICEP): Boolean;
begin
  try
    ACEP := CEPDe(edtCEP.Text);
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtWarning, [mbOk], 0);
      if edtCEP.CanFocus then
        edtCEP.SetFocus;
    end;
  end;

  Result := Assigned(ACEP);
end;

procedure TfrmConsultaPorCEP.ConsultarCEPLocal(const ACEP: ICEP; const ASucesso: TProc<IEndereco>;
  const AFalha: TProc<Exception>);
var
  lTarefa: ITask;
begin
  lTarefa := TTask.Create(procedure
    var
      lServicoDeBuscaPeloCEP: IServicoDeBuscaPeloCEP;
      lEndereco: IEndereco;
    begin
      try
        lServicoDeBuscaPeloCEP := ProvedorDeServicos.CriarServicoDeBuscaPeloCEPLocal;
        lEndereco := lServicoDeBuscaPeloCEP.Buscar(ACEP);
        TThread.Synchronize(TThread.Current, procedure
          begin
            ASucesso(lEndereco);
          end);
      except
        on E: Exception do
          TThread.Synchronize(TThread.Current, procedure
            begin
              AFalha(E);
            end);
      end;
    end);
  lTarefa.Start;
end;

procedure TfrmConsultaPorCEP.ConsultarCEPRemoto(const ACEP: ICEP; const AEmXML: Boolean;
  const ASucesso: TProc<IEndereco>; const AFalha: TProc<Exception>);
var
  lTarefa: ITask;
begin
  lTarefa := TTask.Create(procedure
    var
      lServicoDeBuscaPeloCEP: IServicoDeBuscaPeloCEP;
      lEndereco: IEndereco;
    begin
      try
        lServicoDeBuscaPeloCEP := ProvedorDeServicos.CriarServicoDeBuscaPeloCEPRemoto(AEmXML);
        lEndereco := lServicoDeBuscaPeloCEP.Buscar(ACEP);
        TThread.Synchronize(TThread.Current, procedure
          begin
            ASucesso(lEndereco);
          end);
      except
        on E: Exception do
          TThread.Synchronize(TThread.Current, procedure
            begin
              AFalha(E);
            end);
      end;
    end);
  lTarefa.Start;
end;

procedure TfrmConsultaPorCEP.MostrarErro(const AErro: Exception);
begin
  MessageDlg(AErro.Message, mtWarning, [mbOk], 0);
  if (AErro is ECEPInvalido) and edtCEP.CanFocus then
    edtCEP.SetFocus;
end;

procedure TfrmConsultaPorCEP.Focar;
begin
  if not Assigned(ActiveControl) and edtCEP.CanFocus then
    edtCEP.SetFocus;
end;

procedure TfrmConsultaPorCEP.btnConsultarClick(Sender: TObject);
var
  lCEP: ICEP;
begin
  if LerCEP(lCEP) then
  begin
    btnConsultar.Enabled := False;
    Screen.Cursor := crHourGlass;
    ConsultarCEPLocal(lCEP, procedure(AEndereco: IEndereco)
      begin
        if not Assigned(AEndereco) or
          (TaskMessageDlg('Endereço cadastrado no banco de dados', 'Você deseja:', mtConfirmation, [mbYes, mbNo], 0,
            mbNo, ['Efetuar uma nova consulta?', 'Mostrar o endereço cadastrado?']) = mrYes) then
        begin
          ConsultarCEPRemoto(lCEP, rbXML.Checked, procedure(AEndereco: IEndereco)
            begin
              MostrarEndereco(AEndereco);
              if not Assigned(AEndereco) then
                MessageDlg('CEP não encontrado.', mtWarning, [mbOK], 0);
              Screen.Cursor := crDefault;
              btnConsultar.Enabled := True;
            end, procedure(AErro: Exception)
            begin
              Screen.Cursor := crDefault;
              btnConsultar.Enabled := True;
              MostrarErro(AErro);
            end);
        end
        else
        begin
          MostrarEndereco(AEndereco);
          Screen.Cursor := crDefault;
          btnConsultar.Enabled := True;
        end;
      end, procedure(AErro: Exception)
      begin
        Screen.Cursor := crDefault;
        btnConsultar.Enabled := True;
        MostrarErro(AErro);
      end);
  end;
end;

end.
