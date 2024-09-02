object frmEnderecos: TfrmEnderecos
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmEnderecos'
  ClientHeight = 638
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object pnlEnderecos: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 802
    Height = 628
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Nenhum endere'#231'o encontrado.'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object lvEnderecos: TListView
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 802
    Height = 628
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Columns = <
      item
        Caption = 'CEP'
        Width = 75
      end
      item
        Caption = 'Logradouro'
        Width = 200
      end
      item
        Caption = 'Complemento'
        Width = 125
      end
      item
        Caption = 'Bairro'
        Width = 200
      end
      item
        Caption = 'Localidade'
        Width = 125
      end
      item
        Caption = 'UF'
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    Visible = False
  end
end
