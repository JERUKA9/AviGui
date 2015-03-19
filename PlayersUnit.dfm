object PlayersForm: TPlayersForm
  Left = 0
  Top = 0
  Caption = 'PlayersForm'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 32
    Top = 16
    Width = 377
    Height = 275
    Checkboxes = True
    Columns = <
      item
        Width = 300
      end>
    ColumnClick = False
    GridLines = True
    ShowColumnHeaders = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 471
    Top = 266
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 552
    Top = 266
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
