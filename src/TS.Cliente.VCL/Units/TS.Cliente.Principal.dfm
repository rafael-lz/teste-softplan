object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 683
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object pcOpcoes: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 683
    ActivePage = tsConsultaPorCEP
    Align = alClient
    TabOrder = 0
    OnChange = pcOpcoesChange
    ExplicitWidth = 796
    ExplicitHeight = 682
    object tsConsultaPorCEP: TTabSheet
      Caption = 'Consulta por CEP'
    end
    object tsConsultaPorEndereco: TTabSheet
      Caption = 'Consulta por Endere'#231'o'
      ImageIndex = 1
    end
  end
end
