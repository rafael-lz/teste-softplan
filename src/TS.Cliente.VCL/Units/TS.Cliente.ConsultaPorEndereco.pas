unit TS.Cliente.ConsultaPorEndereco;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Controls,
  VCL.Forms,
  VCL.StdCtrls,
  VCL.Mask,
  VCL.ExtCtrls,
  TS.Lib.Lista,
  TS.Modelo.UF,
  TS.Modelo.Endereco,
  TS.Cliente.Consulta;

type
  //TfrmConsultaPorEndereco
  TfrmConsultaPorEndereco = class sealed(TfrmConsulta)
    pnlConsulta: TPanel;
    lblUF: TLabel;
    cbUF: TComboBox;
    edtLocalidade: TEdit;
    lblLocalidade: TLabel;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    lblRetorno: TLabel;
    rbJSON: TRadioButton;
    rbXML: TRadioButton;
    btnConsultar: TButton;
    procedure btnConsultarClick(Sender: TObject);
  private
    function LerUF(out AUF: IUF): Boolean;
    function LerLocalidade(out ALocalidade: string): Boolean;
    function LerLogradouro(out ALogradouro: string): Boolean;
    procedure ConsultarEnderecoLocal(const AUF: IUF; const ALocalidade, ALogradouro: string;
      const ASucesso: TProc<ILista<IEndereco>>; const AFalha: TProc<Exception>);
    procedure ConsultarEnderecoRemoto(const AUF: IUF; const ALocalidade, ALogradouro: string; const AEmXML: Boolean;
      const ASucesso: TProc<ILista<IEndereco>>; const AFalha: TProc<Exception>);
    procedure MostrarErro(const AErro: Exception);
  public
    procedure Focar; override;
  end;

implementation

uses
  System.Threading,
  System.UITypes,
  VCL.Dialogs,
  TS.Modelo.UF.Utils,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco,
  TS.Aplicacao.ServicoDeBuscaPeloEndereco.Erros;

{$R *.dfm}

{ TfrmConsultaPorEndereco }

function TfrmConsultaPorEndereco.LerUF(out AUF: IUF): Boolean;
begin
  try
    AUF := UFDe(cbUF.Text);
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtWarning, [mbOk], 0);
      if cbUF.CanFocus then
        cbUF.SetFocus;
    end;
  end;

  Result := Assigned(AUF);
end;

function TfrmConsultaPorEndereco.LerLocalidade(out ALocalidade: string): Boolean;
begin
  ALocalidade := Trim(edtLocalidade.Text);
  Result := True;
end;

function TfrmConsultaPorEndereco.LerLogradouro(out ALogradouro: string): Boolean;
begin
  ALogradouro := Trim(edtLogradouro.Text);
  Result := True;
end;

procedure TfrmConsultaPorEndereco.ConsultarEnderecoLocal(const AUF: IUF; const ALocalidade, ALogradouro: string;
  const ASucesso: TProc<ILista<IEndereco>>; const AFalha: TProc<Exception>);
var
  lTarefa: ITask;
begin
  lTarefa := TTask.Create(procedure
    var
      lServicoDeBuscaPeloEndereco: IServicoDeBuscaPeloEndereco;
      lEnderecos: ILista<IEndereco>;
    begin
      try
        lServicoDeBuscaPeloEndereco := ProvedorDeServicos.CriarServicoDeBuscaPeloEnderecoLocal;
        lEnderecos := lServicoDeBuscaPeloEndereco.Buscar(AUF, ALocalidade, ALogradouro);
        TThread.Synchronize(TThread.Current, procedure
          begin
            ASucesso(lEnderecos);
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

procedure TfrmConsultaPorEndereco.ConsultarEnderecoRemoto(const AUF: IUF; const ALocalidade, ALogradouro: string;
  const AEmXML: Boolean; const ASucesso: TProc<ILista<IEndereco>>; const AFalha: TProc<Exception>);
var
  lTarefa: ITask;
begin
  lTarefa := TTask.Create(procedure
    var
      lServicoDeBuscaPeloEndereco: IServicoDeBuscaPeloEndereco;
      lEnderecos: ILista<IEndereco>;
    begin
      try
        lServicoDeBuscaPeloEndereco := ProvedorDeServicos.CriarServicoDeBuscaPeloEnderecoRemoto(AEmXML);
        lEnderecos := lServicoDeBuscaPeloEndereco.Buscar(AUF, ALocalidade, ALogradouro);
        TThread.Synchronize(TThread.Current, procedure
          begin
            ASucesso(lEnderecos);
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

procedure TfrmConsultaPorEndereco.MostrarErro(const AErro: Exception);
begin
  MessageDlg(AErro.Message, mtWarning, [mbOk], 0);
  if AErro is EUFInvalida then
  begin
    if cbUF.CanFocus then
      cbUF.SetFocus;
  end
  else if (AErro is ELocalidadeInvalida) then
  begin
    if edtLocalidade.CanFocus then
     edtLocalidade.SetFocus;
  end
  else if (AErro is ELogradouroInvalido) then
  begin
    if edtLogradouro.CanFocus then
      edtLogradouro.SetFocus;
  end;
end;

procedure TfrmConsultaPorEndereco.Focar;
begin
  if not Assigned(ActiveControl) and cbUF.CanFocus then
    cbUF.SetFocus;
end;

procedure TfrmConsultaPorEndereco.btnConsultarClick(Sender: TObject);
var
  lUF: IUF;
  sLocalidade: string;
  sLogradouro: string;
begin
  if LerUF(lUF) and LerLocalidade(sLocalidade) and LerLogradouro(sLogradouro) then
  begin
    btnConsultar.Enabled := False;
    Screen.Cursor := crHourGlass;
    ConsultarEnderecoLocal(lUF, sLocalidade, sLogradouro, procedure(AEnderecos: ILista<IEndereco>)
      begin
        if (AEnderecos.Quantidade = 0) or
          (TaskMessageDlg('Endereço cadastrado no banco de dados', 'Você deseja:', mtConfirmation, [mbYes, mbNo], 0,
            mbNo, ['Efetuar uma nova consulta?', 'Mostrar o endereço cadastrado?']) = mrYes) then
        begin
          ConsultarEnderecoRemoto(lUF, sLocalidade, sLogradouro, rbXML.Checked, procedure(AEnderecos: ILista<IEndereco>)
            begin
              MostrarEnderecos(AEnderecos);
              if AEnderecos.Quantidade = 0 then
                MessageDlg('Endereço não encontrado.', mtWarning, [mbOk], 0);
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
          MostrarEnderecos(AEnderecos);
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
