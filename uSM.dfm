object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  OnCreate = DSServerModuleCreate
  Height = 520
  Width = 904
  object conn: TFDConnection
    Params.Strings = (
      'Database=TestWK'
      'User_Name=postgres'
      'Password=admin'
      'Server=localhost'
      'DriverID=PG')
    Connected = True
    Left = 488
    Top = 176
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 'C:\Users\vitor\OneDrive\Documentos\projetos\WKTest\Win32\Debug'
    Left = 480
    Top = 240
  end
  object FDQuery: TFDQuery
    Connection = conn
    Left = 272
    Top = 256
  end
end
