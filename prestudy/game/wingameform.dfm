object frmWinGame: TfrmWinGame
  Left = 188
  Top = 141
  Caption = 'frmWinGame'
  ClientHeight = 470
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 472
    Top = 216
    Width = 75
    Height = 25
    Caption = 'btnMj'
    TabOrder = 0
    OnClick = btn1Click
  end
  object mmo1: TMemo
    Left = 8
    Top = 16
    Width = 401
    Height = 425
    Lines.Strings = (
      'mmo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btn2: TButton
    Left = 472
    Top = 304
    Width = 75
    Height = 25
    Caption = 'btnPoker'
    TabOrder = 2
    OnClick = btn2Click
  end
end
