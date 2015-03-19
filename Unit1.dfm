object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Tasks'
  end
  object SpeedButton1: TSpeedButton
    Left = 343
    Top = 99
    Width = 49
    Height = 17
    OnClick = SpeedButton1Click
  end
  object ListView1: TListView
    Left = 8
    Top = 27
    Width = 329
    Height = 190
    Columns = <
      item
        Width = 300
      end
      item
      end
      item
      end>
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
  object Button1: TButton
    Left = 8
    Top = 223
    Width = 137
    Height = 25
    Caption = 'Add Task(s)...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 223
    Width = 137
    Height = 25
    Caption = 'Remove Task(s)'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 343
    Top = 27
    Width = 75
    Height = 25
    Caption = 'Info'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ComboBox1: TComboBox
    Left = 343
    Top = 72
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 4
  end
  object OpenVideoDialog: TOpenDialog
    Filter = '*.mp4'
    Left = 408
    Top = 224
  end
  object OpenFFmpegDialog: TOpenDialog
    Left = 408
    Top = 160
  end
end
