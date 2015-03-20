object PlayersForm: TPlayersForm
  Left = 0
  Top = 0
  Caption = 'PlayersForm'
  ClientHeight = 453
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
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 327
    Width = 49
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'Set All'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 63
    Top = 327
    Width = 49
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'Clear All'
    OnClick = SpeedButton2Click
  end
  object lblAttr: TLabel
    Left = 144
    Top = 336
    Width = 44
    Height = 13
    Caption = 'Standard'
  end
  object SpeedButton3: TSpeedButton
    Left = 567
    Top = 355
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = SpeedButton3Click
  end
  object ListView1: TListView
    Left = 8
    Top = 16
    Width = 601
    Height = 305
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
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = ListView1AdvancedCustomDrawItem
    OnChange = ListView1Change
  end
  object Button1: TButton
    Left = 447
    Top = 420
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
    ExplicitTop = 328
  end
  object Button2: TButton
    Left = 532
    Top = 420
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitTop = 328
  end
  object edName: TEdit
    Left = 8
    Top = 355
    Width = 153
    Height = 21
    TabOrder = 3
  end
  object edPath: TEdit
    Left = 167
    Top = 355
    Width = 394
    Height = 21
    TabOrder = 4
    OnExit = edPathExit
  end
  object btnAdd: TButton
    Left = 8
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 5
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 89
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 6
    OnClick = btnRemoveClick
  end
  object OpenDialog: TOpenDialog
    Left = 568
    Top = 376
  end
end
