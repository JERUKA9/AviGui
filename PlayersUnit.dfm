object PlayersForm: TPlayersForm
  Left = 0
  Top = 0
  Caption = 'PlayersForm'
  ClientHeight = 361
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    615
    361)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 331
    Width = 49
    Height = 22
    Caption = 'Set All'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 63
    Top = 331
    Width = 49
    Height = 22
    Caption = 'Clear All'
    OnClick = SpeedButton2Click
  end
  object ListView1: TListView
    Left = 8
    Top = 16
    Width = 601
    Height = 306
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Attr'
        Width = 40
      end
      item
        Caption = 'Path'
        Width = 370
      end>
    ColumnClick = False
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 447
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 532
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
