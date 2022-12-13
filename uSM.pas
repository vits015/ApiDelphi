unit uSM;

interface

uses System.SysUtils, System.Classes, System.Json,
    DataSnap.DSProviderDataModuleAdapter,
    Datasnap.DSServer, Datasnap.DSAuth, REST.Json, uPessoa, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.Generics.Collections;

type
  TServerMethods1 = class(TDSServerModule)
    conn: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDQuery: TFDQuery;
    procedure DSServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function getPessoas: TJSONObject;
    function getPessoa(aid : integer) : TJsonObject;
    function acceptPessoas(Aid : Integer; obj:TJSONObject):TJsonValue;
    function cancelPessoas(Aid : Integer):TJsonValue;
    function updatePessoas(json : TJSONObject) : TJsonValue;
  end;

implementation


{$R *.dfm}


{ TServerMethods1 }

function TServerMethods1.acceptPessoas(Aid: Integer ; obj:TJSONObject): TJsonValue;
begin
  try
    FDQuery.SQL.Text:= 'UPDATE pessoa set idpessoa='  +     obj.GetValue('id').ToString
                         +  ', flnatureza = '   + chr(39)+  StringReplace(obj.GetValue('natureza').ToString,'"','',[rfReplaceAll])     +chr(39)
                         +  ', nmprimeiro = '   + chr(39)+  StringReplace(obj.GetValue('nmprimeiro').ToString,'"','',[rfReplaceAll])   +chr(39)
                         +  ', dsdocumento = '  + chr(39)+  StringReplace(obj.GetValue('documento').ToString ,'"','',[rfReplaceAll])   +chr(39)
                         +  ', nmsegundo = '    + chr(39)+  StringReplace(obj.GetValue('nmsegundo').ToString ,'"','',[rfReplaceAll])   +chr(39)
                         +  ', dtregistro = '   + chr(39)+  StringReplace(obj.GetValue('dtregistro').ToString,'"','',[rfReplaceAll])   +chr(39)
                         +  ' where idpessoa = '+ aid.ToString;
    FDQuery.ExecSQL;

    if FDQuery.RowsAffected > 0 then
      Result:= TJsonString.Create('o id: ' + Aid.ToString + ' foi alterado com sucesso!')
    else
      Result:= TJsonString.Create('o id: ' + Aid.ToString + ' não foi encontrado!');

    except on e:exception do
    begin
      result:= TJsonString.Create('Erro: ' + e.Message);
    end;
  end;
end;

function TServerMethods1.cancelPessoas(Aid: Integer): TJsonValue;
begin

  try
    FDQuery.SQL.Text := 'delete from pessoa where idpessoa = ' + aid.ToString;
    FDQuery.ExecSQL;

    if FDQuery.RowsAffected > 0 then
      Result:= TJsonString.Create('o item: ' + Aid.ToString + ' foi excluído com sucesso!')
    else
      Result:= TJsonString.Create('o id: ' + Aid.ToString + ' não foi encontrado!');

    except on e:exception do
    begin
      result:= TJsonString.Create('Erro: ' + e.Message);
    end;

  end;

end;

procedure TServerMethods1.DSServerModuleCreate(Sender: TObject);
begin
  FDPhysPgDriverLink.VendorHome := './';
end;

function TServerMethods1.getPessoa(Aid: Integer): TJsonObject;
var
  jsonObjRetorno : TJsonObject;
begin

  try
    try
      FDQuery.SQL.Text := 'SELECT * FROM Pessoa WHERE idpessoa= ' + Aid.ToString;
      FDQuery.Open;

      FDQuery.First;

      jsonObjRetorno:= TJSONObject.Create;
      while not FDQuery.Eof do
      begin
        JsonObjRetorno.AddPair('id', TJSONNumber.Create(FDQuery.FieldByName('idpessoa').AsInteger));
        JsonObjRetorno.AddPair('natureza', TJSONNumber.Create(FDQuery.FieldByName('flnatureza').AsInteger));
        JsonObjRetorno.AddPair('documento', FDQuery.FieldByName('dsdocumento').AsString);
        JsonObjRetorno.AddPair('nmprimeiro', FDQuery.FieldByName('nmprimeiro').AsString);
        JsonObjRetorno.AddPair('nmsegundo', FDQuery.FieldByName('nmsegundo').AsString);
        JsonObjRetorno.AddPair('dtregistro', DateToStr(FDQuery.FieldByName('dtregistro').AsDateTime));
        FDQuery.Next;
      end;

    except on e:exception do
      begin
        jsonObjRetorno.AddPair('erro: ', e.Message)
      end;
    end;
  finally
    result:= jsonObjRetorno;
  end;





end;

function TServerMethods1.getPessoas: TJSONObject;
var
  JsonObjRetorno ,obj: TJsonObject;

  arrayJson : TJSONArray;
  objPessoa : TPessoa;
  arrayPessoas : TObjectList<TPessoa>;
//  erro: boolean;

begin
//  erro:= false;
  try

    try
      FDQuery.SQL.Text := 'SELECT * FROM Pessoa ORDER BY idpessoa';
      FDQuery.Open;

      FDQuery.First;

      arrayPessoas := TObjectList<TPessoa>.Create;

      while not FDQuery.eof do
      begin
        objPessoa := TPessoa.Create;
        objPessoa.id:= FDQuery.FieldByName('idpessoa').AsInteger;
        objPessoa.natureza:= FDQuery.FieldByName('flnatureza').AsInteger;
        objPessoa.documento:= FDQuery.FieldByName('dsdocumento').AsString;
        objPessoa.nmprimeiro:= FDQuery.FieldByName('nmprimeiro').AsString;
        objPessoa.nmsegundo:= FDQuery.FieldByName('nmsegundo').AsString;
        objPessoa.dtregistro:= FDQuery.FieldByName('dtregistro').AsString;

        arrayPessoas.Add(objPessoa);
        FDQuery.Next;
      end;

      arrayJson := TJSONArray.Create;

      for objPessoa in arrayPessoas do
      begin
        JsonObjRetorno := TJSONObject.Create;
        JsonObjRetorno := TJson.ObjectToJsonObject(objPessoa);
        arrayJson.AddElement(JsonObjRetorno);
      end;
      result := Tjsonobject.create;
      result := result.AddPair('pessoas', arrayJson);

    except on e:exception do
      begin
//        erro:= true;
        result:= nil;
      end;

    end;

  finally
//    objPessoa.Free;
//    JsonObjRetorno.Free;
//    arrayPessoas.DisposeOf;
  end;

end;

function TServerMethods1.updatePessoas(json: TJSONObject): TJsonValue;
var
  VPessoa : TPessoa;
  erro:boolean;
  msgErro:String;
begin
  erro:= false;
  VPessoa := TJson.JsonToObject<TPessoa>(json.ToJSON);
  try
    try
      FDQuery.SQL.Text:= 'insert into pessoa values (' +
      VPessoa.id.ToString + ', ' +VPessoa.natureza.ToString + ', ' + chr(39)+VPessoa.documento+chr(39) +
      ', ' + chr(39)+VPessoa.nmprimeiro+chr(39) + ', ' + chr(39)+VPessoa.nmsegundo+chr(39) + ', ' +
      chr(39)+VPessoa.dtregistro+chr(39) + ')';
      FDQuery.ExecSQL;
      Result := TJSONString.Create('A pessoa '+ VPessoa.id.ToString+ ' ' + VPessoa.nmprimeiro + ' foi incluída com sucesso!');
      except on E:Exception do
      begin
        erro:=true;
        msgErro:= e.Message;
      end;
    end;
  finally
    if erro then
      Result:= TJSONString.Create(msgErro);
    VPessoa.Free;
  end;
end;

end.

