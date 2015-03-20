object AddForm: TAddForm
  Left = 0
  Top = 0
  Caption = 'Add New'
  ClientHeight = 100
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    447
    100)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton3: TSpeedButton
    Left = 416
    Top = 34
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = SpeedButton3Click
  end
  object edPath: TEdit
    Left = 16
    Top = 35
    Width = 394
    Height = 21
    TabOrder = 1
  end
  object edName: TEdit
    Left = 16
    Top = 8
    Width = 153
    Height = 21
    TabOrder = 0
  end
  object Button2: TButton
    Left = 364
    Top = 67
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 583
    ExplicitTop = 453
  end
  object Button1: TButton
    Left = 288
    Top = 67
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = Button1Click
    ExplicitLeft = 507
    ExplicitTop = 453
  end
  object OpenDialog: TOpenDialog
    Left = 408
    Top = 65535
  end
end
