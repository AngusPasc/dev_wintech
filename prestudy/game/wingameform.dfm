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
  object btnMjTest: TButton
    Left = 584
    Top = 47
    Width = 75
    Height = 25
    Caption = 'btnMj'
    TabOrder = 0
    OnClick = btnMjTestClick
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
  object btnPokerTest: TButton
    Left = 584
    Top = 16
    Width = 75
    Height = 25
    Caption = 'btnPoker'
    TabOrder = 2
    OnClick = btnPokerTestClick
  end
  object pnlDDZ: TPanel
    Left = 424
    Top = 96
    Width = 265
    Height = 321
    TabOrder = 3
    object btnDDZ1: TButton
      Left = 14
      Top = 16
      Width = 75
      Height = 25
      Caption = 'DDZ Start'
      TabOrder = 0
      OnClick = btnDDZ1Click
    end
    object btnPlayer1: TButton
      Left = 96
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Player 1'
      TabOrder = 1
      OnClick = btnPlayer1Click
    end
    object btnPlayer2: TButton
      Left = 96
      Top = 149
      Width = 75
      Height = 25
      Caption = 'Player 2'
      TabOrder = 2
      OnClick = btnPlayer2Click
    end
    object btnPlayer3: TButton
      Left = 96
      Top = 230
      Width = 75
      Height = 25
      Caption = 'Player 3'
      TabOrder = 3
      OnClick = btnPlayer3Click
    end
    object edtCard1: TEdit
      Left = 96
      Top = 47
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object edtCard2: TEdit
      Left = 96
      Top = 125
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object edtCard3: TEdit
      Left = 96
      Top = 203
      Width = 121
      Height = 21
      TabOrder = 6
    end
  end
end
