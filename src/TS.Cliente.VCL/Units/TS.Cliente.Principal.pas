unit TS.Cliente.Principal;

interface

uses
  System.Classes,
  VCL.Controls,
  VCL.Forms,
  VCL.ComCtrls,
  TS.Cliente.ProvedorDeServicos,
  TS.Cliente.Consulta;

type
  //TfrmPrincipal
  TfrmPrincipal = class sealed(TForm)
    pcOpcoes: TPageControl;
    tsConsultaPorCEP: TTabSheet;
    tsConsultaPorEndereco: TTabSheet;
    procedure pcOpcoesChange(Sender: TObject);
  private
    FProvedorDeServicos: IProvedorDeServicos;
    FConsultaPorCEP: TfrmConsulta;
    FConsultaPorEndereco: TfrmConsulta;
    procedure MostrarConsulta(const AConsulta: TfrmConsulta; const AAba: TTabSheet);
  protected
    procedure DoShow; override;
  public
    constructor Create(const AOwner: TComponent; const AProvedorDeServicos: IProvedorDeServicos); reintroduce;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.UI.Intf,
  FireDAC.Comp.UI,
  FireDAC.VCLUI.Wait,
  TS.Cliente.ConsultaPorCEP,
  TS.Cliente.ConsultaPorEndereco;

{$R *.dfm}

{ TfrmPrincipal }

constructor TfrmPrincipal.Create(const AOwner: TComponent; const AProvedorDeServicos: IProvedorDeServicos);
begin
  inherited Create(AOwner);
  if not Assigned(AProvedorDeServicos) then
    raise EArgumentNilException.Create('O provedor de serviços é obrigatório.');
  FProvedorDeServicos := AProvedorDeServicos;
  Caption := Application.Title;
  pcOpcoes.ActivePageIndex := 0;
  FConsultaPorCEP := TfrmConsultaPorCEP.Create(Self, FProvedorDeServicos);
  MostrarConsulta(FConsultaPorCEP, tsConsultaPorCEP);
  FConsultaPorEndereco := TfrmConsultaPorEndereco.Create(Self, FProvedorDeServicos);
  MostrarConsulta(FConsultaPorEndereco, tsConsultaPorEndereco);
end;

procedure TfrmPrincipal.MostrarConsulta(const AConsulta: TfrmConsulta; const AAba: TTabSheet);
begin
  AConsulta.Parent := AAba;
  AConsulta.BorderStyle := bsNone;
  AConsulta.Align := alClient;
  AConsulta.Show;
end;

procedure TfrmPrincipal.DoShow;
begin
  inherited;
  pcOpcoesChange(nil);
end;

procedure TfrmPrincipal.pcOpcoesChange(Sender: TObject);
begin
  if Assigned(pcOpcoes.ActivePage) and (pcOpcoes.ActivePage.ControlCount > 0) and
      (pcOpcoes.ActivePage.Controls[0] is TfrmConsulta) then
    TfrmConsulta(pcOpcoes.ActivePage.Controls[0]).Focar;
end;

end.
