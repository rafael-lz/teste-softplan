object frmConsultaPorEndereco: TfrmConsultaPorEndereco
  Left = 0
  Top = 0
  ActiveControl = cbUF
  BorderStyle = bsNone
  Caption = 'frmConsultaPorEndereco'
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
    Height = 140
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      652
      140)
    object lblUF: TLabel
      Left = 15
      Top = 20
      Width = 17
      Height = 15
      Caption = 'UF:'
      FocusControl = cbUF
    end
    object lblLocalidade: TLabel
      Left = 15
      Top = 50
      Width = 60
      Height = 15
      Caption = 'Localidade:'
      FocusControl = edtLocalidade
    end
    object lblLogradouro: TLabel
      Left = 15
      Top = 80
      Width = 65
      Height = 15
      Caption = 'Logradouro:'
      FocusControl = edtLogradouro
    end
    object lblRetorno: TLabel
      Left = 15
      Top = 110
      Width = 45
      Height = 15
      Caption = 'Retorno:'
      FocusControl = edtLogradouro
    end
    object btnConsultar: TButton
      Left = 560
      Top = 15
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Consultar'
      TabOrder = 5
      OnClick = btnConsultarClick
    end
    object rbJSON: TRadioButton
      Left = 90
      Top = 110
      Width = 50
      Height = 17
      Caption = 'JSON'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object rbXML: TRadioButton
      Left = 145
      Top = 110
      Width = 50
      Height = 17
      Caption = 'XML'
      TabOrder = 4
    end
    object cbUF: TComboBox
      Left = 90
      Top = 15
      Width = 75
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'AC'
        'AL'
        'AP'
        'AM'
        'BA'
        'CE'
        'DF'
        'ES'
        'GO'
        'MA'
        'MT'
        'MS'
        'MG'
        'PA'
        'PB'
        'PR'
        'PE'
        'PI'
        'RJ'
        'RN'
        'RS'
        'RO'
        'RR'
        'SC'
        'SP'
        'SE'
        'TO')
    end
    object edtLocalidade: TEdit
      Left = 90
      Top = 45
      Width = 300
      Height = 23
      TabOrder = 1
    end
    object edtLogradouro: TEdit
      Left = 90
      Top = 75
      Width = 300
      Height = 23
      TabOrder = 2
    end
  end
end
