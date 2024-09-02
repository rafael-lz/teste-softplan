object frmConsultaPorCEP: TfrmConsultaPorCEP
  Left = 0
  Top = 0
  ActiveControl = edtCEP
  BorderStyle = bsNone
  Caption = 'frmConsultaPorCEP'
  ClientHeight = 518
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlConsulta: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      652
      80)
    object lblCEP: TLabel
      Left = 15
      Top = 20
      Width = 24
      Height = 15
      Caption = 'CEP:'
      FocusControl = edtCEP
    end
    object lblRetorno: TLabel
      Left = 15
      Top = 50
      Width = 45
      Height = 15
      Caption = 'Retorno:'
    end
    object edtCEP: TMaskEdit
      Left = 70
      Top = 15
      Width = 99
      Height = 23
      EditMask = '99999-999;1;_'
      MaxLength = 9
      TabOrder = 0
      Text = '     -   '
    end
    object btnConsultar: TButton
      Left = 560
      Top = 15
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Consultar'
      TabOrder = 3
      OnClick = btnConsultarClick
    end
    object rbJSON: TRadioButton
      Left = 70
      Top = 50
      Width = 50
      Height = 17
      Caption = 'JSON'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object rbXML: TRadioButton
      Left = 125
      Top = 50
      Width = 50
      Height = 17
      Caption = 'XML'
      TabOrder = 2
    end
  end
end
