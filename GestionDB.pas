unit GestionDB;

interface

Uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI;

Type CGestionDB=class(TObject)
   private
      ConexionDB: TFDConnection;
      MotorConsultas: TFDQuery;
      Function CheckEtiquetas:Boolean;
      Procedure ConectaDB;
   public
      Constructor Create;
      Function GetDBDir:String;
      Function Checkdatabase:Boolean;
end;

Const SQLTablas='SELECT name FROM sqlite_master WHERE type =''table'' AND name in (:Tabla)';
const DbName='organizador.db';

Var pGestionDB:CGestionDB;

implementation

Uses System.SysUtils,System.IOUtils;


Constructor CGestionDB.Create;
Begin
   ConexionDB:=TFDConnection.Create(Nil);
end;

Procedure CGestionDB.ConectaDB;
begin
   If ConexionDB.Connected then exit;
   ConexionDB.Params.Clear;
   ConexionDB.Params.Add('DriverID=SQLite');
   ConexionDB.Params.Add('Database='+GetDBDir);
   ConexionDB.Params.Add('LockingMode=Normal');
   ConexionDB.Params.Add('Synchronous=Normal');
   ConexionDB.Connected:=True;
   MotorConsultas:=TFDQuery.Create(Nil);
   MotorConsultas.Connection:=ConexionDB;
end;

Function CGestionDB.GetDBDir:String;
Begin
   {$IF DEFINED(MSWINDOWS)}
   Result:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+DbName;
   {$ELSE}
   Result:=TPath.GetPublicPath+PathDelim+DbName;
   {$ENDIF}
 end;

Function CGestionDB.CheckEtiquetas:Boolean;
Const TablaEtiquetas='CREATE TABLE ETIQUETAS ( IDPLATO INTEGER, ETIQUETA CHAR(50) NOT NULL, '+
                    '    PRIMARY KEY(IDPLATO,ETIQUETA) )';
Var SQL:String;
Begin
   Result:=false;
   MotorConsultas.Open(SQLTablas,['ETIQUETAS']);
   if MotorConsultas.FieldByName('name').AsString<>'ETIQUETAS' then begin
      MotorConsultas.Close;
      MotorConsultas.SQL.Text:=TablaEtiquetas;
      MotorConsultas.ExecSQL;
      MotorConsultas.ExecSQL('INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (-1,''Desayuno'')');
      MotorConsultas.ExecSQL('INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (-1,''Almuerzo'')');
      MotorConsultas.ExecSQL('INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (-1,''Comida'')');
      MotorConsultas.ExecSQL('INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (-1,''Merienda'')');
      MotorConsultas.ExecSQL('INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (-1,''Cena'')');
   end;
   Result:=True;
end;

Function CGestionDB.Checkdatabase:Boolean;
begin
    Result:=False;
    ConectaDB;
    Result:=CheckEtiquetas;
end;

end.
