unit FIntroduccionRecetas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ComboEdit,
  FMX.ScrollBox, FMX.Memo, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FMX.ListView, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.EditBox,
  FMX.NumberBox, System.ImageList, FMX.ImgList, Fmx.Bind.GenData,
  Data.Bind.ObjectScope;

type
  TFormIntroRecetas = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StyleBook1: TStyleBook;
    LabelNPlato: TLabel;
    MemoNombrePlato: TMemo;
    LabelAlimento: TLabel;
    LabelCantidad: TLabel;
    LVAlimentos: TListView;
    LVTipos: TListView;
    QueryAlimentos: TFDQuery;
    QueryTipos: TFDQuery;
    ConexionListado: TFDConnection;
    AddAlimento: TButton;
    ExecQuery: TFDQuery;
    QueryAlimentosNOMBRE: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    EditAlimento: TEdit;
    EditTipo: TEdit;
    QueryTiposTIPO: TStringField;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField2: TLinkFillControlToField;
    MemoMensajes: TMemo;
    PanelPrincipal: TPanel;
    MemoReceta: TMemo;
    LVIngredientes: TListView;
    QueryIngredientes: TFDQuery;
    QueriIngredientesNOMBRE: TStringField;
    QueriIngredientesCANTIDAD: TBCDField;
    QueriIngredientesTIPO: TStringField;
    BindSourceDB3: TBindSourceDB;
    BCierraReceta: TButton;
    EditCantidad: TNumberBox;
    QueryIngredientesIDALIMENTO: TIntegerField;
    ImageList1: TImageList;
    LinkFillControlToField3: TLinkFillControlToField;
    Label1: TLabel;
    LVEtiquetasAsignadas: TListView;
    EditEtiqueta: TEdit;
    QEtiquetas: TFDQuery;
    QEtiquetasETIQUETA: TStringField;
    BindSourceDB4: TBindSourceDB;
    LVEtiquetasLibres: TListView;
    LinkFillControlToField4: TLinkFillControlToField;
    QEtiquetasAsignada: TFDQuery;
    QEtiquetasAsignadaETIQUETA: TStringField;
    BindSourceDB5: TBindSourceDB;
    LinkFillControlToField5: TLinkFillControlToField;
    procedure CBAlimentoChange(Sender: TObject);
    procedure AddAlimentoClick(Sender: TObject);
    procedure CBAlimentoKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure LVTiposClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LVAlimentosChange(Sender: TObject);
    procedure EditTipoChange(Sender: TObject);
    procedure EditTipoKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure MemoRecetaExit(Sender: TObject);
    procedure BCierraRecetaClick(Sender: TObject);
    procedure MemoNombrePlatoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ConexionListadoBeforeConnect(Sender: TObject);
    procedure LVIngredientesChange(Sender: TObject);
    procedure LVIngredientesItemClickEx(const Sender: TObject;  ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure EditEtiquetaKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure EditEtiquetasChange(Sender: TObject);
    procedure LVEtiquetasDisponiblesChange(Sender: TObject);
    procedure LVEtiquetasAsignadasItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    bProcesaEventoAlimento:Boolean;
    Procedure MuestraError(Mensaje:String);
    Procedure CargaIngredientes(idPlato:Integer);
  public
    idPlato:Integer;
  end;

var
  FormIntroRecetas: TFormIntroRecetas;

implementation

Uses System.StrUtils,GestionDB;
{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.Surface.fmx MSWINDOWS}
{$R *.Windows.fmx MSWINDOWS}

procedure TFormIntroRecetas.MemoNombrePlatoExit(Sender: TObject);
Var sSQL:String;
begin
   If MemoNombrePlato.Lines.Text='' then begin
      MuestraError('Falta poner un nombre a la receta');
      exit;
   end;
   sSQL:='SELECT COUNT(*) AS CUENTA FROM PLATOS WHERE NOMBRE=:Nombre';
   If idPlato>-1 then begin
      sSQL:=sSQL+' AND IDPLATO<>'+IntToStr(IdPlato);
   end;

   ExecQuery.SQL.Text:=sSQL;
   ExecQuery.Open('',[MemoNombrePlato.Lines.Text]);
   If ExecQuery.FieldByName('CUENTA').AsInteger>0 then begin
      MuestraError('Hay una receta con el mismo nombre. Hay que cambiarle el nombre a esta.');
      exit;
   end;

   If idPlato<0 then begin
      sSQL:='SELECT COUNT(*) AS CUENTA FROM PLATOS WHERE NOMBRE=:Nombre';
      ExecQuery.SQL.Text:=sSQL;
      ExecQuery.Open('',[MemoNombrePlato.Lines.Text]);
      If ExecQuery.FieldByName('CUENTA').AsInteger=0 then begin
         ExecQuery.SQL.Text:='INSERT INTO PLATOS (NOMBRE) VALUES('''+MemoNombrePlato.Lines.Text+''')';
         ExecQuery.ExecSQL;
      end;
      ExecQuery.SQL.Text:='SELECT IDPLATO FROM PLATOS WHERE NOMBRE=:Nombre';
      ExecQuery.Open('',[MemoNombrePlato.Lines.Text]);
      IdPlato:=ExecQuery.FieldByName('IDPLATO').AsInteger;
   end;
   If idPlato<0 then begin
      MuestraError('Error al guardar el plato');
   end else begin
      ExecQuery.SQL.Text:='UPDATE PLATOS SET NOMBRE='''+MemoNombrePlato.Lines.Text+''' WHERE IDPLATO='+IntToStr(IdPlato);
      ExecQuery.ExecSQL;
      MemoRecetaExit(Sender);
   end;
end;

procedure TFormIntroRecetas.MemoRecetaExit(Sender: TObject);
begin
   If IdPlato<0 then begin
      MuestraError('Error al guardar la receta');
      exit;
   end;
   ExecQuery.SQL.Text:='UPDATE PLATOS SET RECETA='''+MemoReceta.Lines.Text+''' WHERE IDPLATO='+IntToStr(IdPlato);
   ExecQuery.ExecSQL;
end;

Procedure TFormIntroRecetas.MuestraError(Mensaje:String);
begin
   ShowMessage(Mensaje);
   MemoMensajes.Lines.Add(Mensaje);
end;

procedure TFormIntroRecetas.AddAlimentoClick(Sender: TObject);
Var sSQL,sCantidad:String;
Var idAlimento,idTipo:Integer;
begin
   //QueryAlimentos.Active:=False;
   If MemoNombrePlato.Lines.Text='' then begin
      MuestraError('Falta añadir nombre al plato');
      Exit;
   end;
   idAlimento:=-1;
   idTipo:=-1;
   ExecQuery.Close;
   If EditAlimento.Text<>'' then begin
      ExecQuery.SQL.Text:='SELECT COUNT(*) AS CUENTA FROM ALIMENTOS WHERE NOMBRE=:Nombre';
      ExecQuery.Open('',[EditAlimento.Text]);
      If ExecQuery.FieldByName('CUENTA').AsInteger=0 then begin
         ExecQuery.SQL.Text:='INSERT INTO ALIMENTOS (NOMBRE) VALUES('''+EditAlimento.Text+''')';
         ExecQuery.ExecSQL;
      end;
      ExecQuery.SQL.Text:='SELECT IDALIMENTO FROM ALIMENTOS WHERE NOMBRE=:Nombre';
      ExecQuery.Open('',[EditAlimento.Text]);
      IdAlimento:=ExecQuery.FieldByName('IDALIMENTO').AsInteger;
   end;
   If EditTipo.Text<>'' then begin
      ExecQuery.SQL.Text:='SELECT COUNT(*) AS CUENTA FROM UNIDADES WHERE TIPO=:Nombre';
      ExecQuery.Open('',[EditTipo.Text]);
      If ExecQuery.FieldByName('CUENTA').AsInteger=0 then begin
         ExecQuery.SQL.Text:='INSERT INTO UNIDADES (TIPO) VALUES('''+EditTipo.Text+''')';
         ExecQuery.ExecSQL;
      end;
      ExecQuery.SQL.Text:='SELECT IDUNIDAD FROM UNIDADES WHERE TIPO=:Nombre';
      ExecQuery.Open('',[EditTipo.Text]);
      idTipo:=ExecQuery.FieldByName('IDUNIDAD').AsInteger;
   end;

   If (IdPlato<0) then begin
      MemoNombrePlatoExit(Sender);
   end;
   If (IdPlato<0) then begin
      MuestraError('No se puede guardar el ingrediente. No hay una receta empezada.');
      exit;
   end;
   sCantidad:=EditCantidad.Text;

   If idAlimento>-1 then begin
      If idTipo<0 then begin
         MuestraError('Error al guardar los ingredientes');
         Exit;
      end else begin
         sSQL:='SELECT COUNT(*) AS CUENTA FROM INGREDIENTES WHERE IDPLATO=:Plato AND IDALIMENTO=:Alimento';
         ExecQuery.SQL.Text:=sSQL;
         ExecQuery.Open('',[idPlato,idAlimento]);
         If ExecQuery.FieldByName('CUENTA').AsInteger>0 then begin
            sSQL:='UPDATE INGREDIENTES SET ';
            sSQL:=sSQL+' IDUNIDAD='+IntToStr(idTipo)+' ,CANTIDAD='+ReplaceStr(sCantidad,',','.');
            sSQL:=sSQL+' WHERE IDPLATO='+IntToStr(idPlato)+' AND IDALIMENTO='+IntToStr(idAlimento);
         end else begin
            sSQL:='INSERT INTO INGREDIENTES (IDPLATO,IDALIMENTO,IDUNIDAD,CANTIDAD';
            sSQL:=sSQL+') VALUES ('+IntToStr(idPlato)+','+IntToStr(idAlimento)+','+IntToStr(idTipo)+','+ReplaceStr(sCantidad,',','.');
            sSQL:=sSQL+')';
         end;
         ExecQuery.SQL.Text:=sSQL;
         ExecQuery.ExecSQL;
      end;
      CargaIngredientes(idPlato);
   end;
   bProcesaEventoAlimento:=False;
   EditCantidad.Text:='0';
   EditAlimento.Text:='';
   EditTipo.Text:='';
   LVAlimentos.ItemIndex:=-1;
   LVTipos.ItemIndex:=-1;
   EditAlimento.SetFocus;
   //QueryAlimentos.Active:=True;
end;

procedure TFormIntroRecetas.CBAlimentoChange(Sender: TObject);
begin
   QueryAlimentos.Active:=False;
   QueryAlimentos.ParamByName('Alimento').AsString:='%'+EditAlimento.Text+'%';
   QueryAlimentos.Active:=True;
end;

procedure TFormIntroRecetas.CBAlimentoKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
   If ((Key=40)or(Key=39))and(bProcesaEventoAlimento) then LVAlimentos.ItemIndex:=LVAlimentos.ItemIndex+1
   else if ((Key=38)or(Key=37))and(bProcesaEventoAlimento) then LVAlimentos.ItemIndex:=LVAlimentos.ItemIndex-1
   else if (Key=13)and(bProcesaEventoAlimento) then LVAlimentosChange(Sender)
   else CBAlimentoChange(Sender);
   bProcesaEventoAlimento:=True;
end;

procedure TFormIntroRecetas.ConexionListadoBeforeConnect(Sender: TObject);
begin
   ConexionListado.Params.Values['Database']:=pGestionDB.GetDBDir;
end;

procedure TFormIntroRecetas.EditEtiquetasChange(Sender: TObject);
begin
   QEtiquetas.Active:=False;
   QEtiquetas.ParamByName('Etiqueta').AsString:='%'+EditEtiqueta.Text+'%';
   QEtiquetas.ParamByName('Plato').AsInteger:=IdPlato;
   QEtiquetas.Active:=True;
end;

procedure TFormIntroRecetas.EditEtiquetaKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   If (Key=40)or(Key=39) then LVEtiquetasLibres.ItemIndex:=LVEtiquetasLibres.ItemIndex+1
   else if (Key=38)or(Key=37) then LVEtiquetasLibres.ItemIndex:=LVEtiquetasLibres.ItemIndex-1
   else if (Key=13) then begin
      LVEtiquetasDisponiblesChange(Sender);
   end else EditEtiquetasChange(Sender);
end;


procedure TFormIntroRecetas.EditTipoChange(Sender: TObject);
begin
   QueryTipos.Active:=False;
   QueryTipos.ParamByName('Tipo').AsString:='%'+EditTipo.Text+'%';
   QueryTipos.Active:=True;
end;

procedure TFormIntroRecetas.EditTipoKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
   If (Key=40)or(Key=39) then LVTipos.ItemIndex:=LVTipos.ItemIndex+1
   else if (Key=38)or(Key=37) then LVTipos.ItemIndex:=LVTipos.ItemIndex-1
   else if (Key=13) then begin
      LVTiposClick(Sender);
   end else EditTipoChange(Sender);
end;

procedure TFormIntroRecetas.FormCreate(Sender: TObject);
begin
   idPlato:=-1;
end;

procedure TFormIntroRecetas.FormShow(Sender: TObject);
begin
   bProcesaEventoAlimento:=True;
   QueryAlimentos.Active:=False;
   QueryTipos.Active:=False;
   QueryIngredientes.Active:=False;
   QEtiquetas.Active:=False;
   QEtiquetasAsignada.Active:=False;
   MemoNombrePlato.Lines.Clear;
   MemoReceta.Lines.Clear;
   EditCantidad.Text:='';
   EditAlimento.Text:='';
   EditTipo.Text:='';
   EditEtiqueta.Text:='';
   Try
       ConexionListado.Connected:=True;
   Except
      On E:Exception do begin
         MuestraError('Error: '+E.Message);
      end;
   End;
   If ConexionListado.Connected then begin
      QueryAlimentos.Active:=True;
      QueryTipos.Active:=True;
      QEtiquetas.Active:=True;

      If idPlato>-1 then begin
         ExecQuery.SQL.Text:='SELECT NOMBRE,RECETA FROM PLATOS WHERE IDPLATO=:Plato';
         ExecQuery.Open('',[idPlato]);
         MemoNombrePlato.Lines.Text:=ExecQuery.FieldByName('NOMBRE').AsString;
         MemoReceta.Lines.Text:=ExecQuery.FieldByName('RECETA').AsString;
         QueryIngredientes.Open('',[idPlato]);
         QEtiquetas.Active:=False;
         QEtiquetas.ParamByName('Plato').AsInteger:=IdPlato;
         QEtiquetas.Active:=True;
         QEtiquetasAsignada.Active:=False;
         QEtiquetasAsignada.ParamByName('Plato').AsInteger:=IdPlato;
         QEtiquetasAsignada.Active:=True;
      end;
   end;
end;

procedure TFormIntroRecetas.LVAlimentosChange(Sender: TObject);
begin
   If LVAlimentos.ItemIndex>-1 then EditAlimento.Text:=LVAlimentos.Items[LVAlimentos.Selected.Index].Text;
   EditCantidad.SetFocus;
end;

procedure TFormIntroRecetas.LVEtiquetasAsignadasItemClickEx(
  const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
Const SQLDeEtiqueta='DELETE FROM ETIQUETAS WHERE IDPLATO=:IdPlato AND ETIQUETA=:Etiqueta';
begin
   If idPlato<0 then exit;
   If ItemObject.Name=('BDelete') then begin
      ExecQuery.ExecSQL(SQLDeEtiqueta,[IdPlato,LVEtiquetasAsignadas.Items[ItemIndex].Data['Text1'].AsString]);
      QEtiquetas.Close;
      QEtiquetasAsignada.Close;
      QEtiquetas.Open;
      QEtiquetasAsignada.Open;
   end;
end;

procedure TFormIntroRecetas.LVEtiquetasDisponiblesChange(Sender: TObject);
Const SQLAddEtiqueta='INSERT INTO ETIQUETAS (IDPLATO,ETIQUETA) VALUES (:Plato,:Etiqueta)';
begin
   If LVEtiquetasLibres.ItemIndex>-1 then EditEtiqueta.Text:=LVEtiquetasLibres.Items[LVEtiquetasLibres.Selected.Index].Data['Text1'].AsString;
   If EditEtiqueta.Text='' then exit;
   ExecQuery.ExecSQL(SQLAddEtiqueta,[IdPlato,EditEtiqueta.Text]);
   QEtiquetasAsignada.Close;
   QEtiquetasAsignada.Open;
   EditEtiqueta.Text:='';
   EditEtiquetasChange(Nil);
end;

procedure TFormIntroRecetas.LVIngredientesChange(Sender: TObject);
Var IdIngrediente:Integer;
begin
   If (IdPlato<0) then exit;
   LVAlimentos.ItemIndex:=-1;
   LVTipos.ItemIndex:=-1;
   EditAlimento.Text:=LVIngredientes.Items[LVIngredientes.Selected.Index].Data['Alimento'].AsString;
   EditCantidad.Text:=LVIngredientes.Items[LVIngredientes.Selected.Index].Data['CAntidad'].AsString;
   EditTipo.Text:=LVIngredientes.Items[LVIngredientes.Selected.Index].Data['Unidad'].AsString;
end;

procedure TFormIntroRecetas.LVIngredientesItemClickEx(const Sender: TObject;  ItemIndex: Integer; const LocalClickPos: TPointF;  const ItemObject: TListItemDrawable);
Const SQLDelIngrediente='DELETE FROM INGREDIENTES WHERE IDPLATO=:IdPlato AND IDALIMENTO=:IdQAlimento';
begin
   If idPlato<0 then exit;
   If ItemObject.Name=('BDelete') then begin
      ExecQuery.ExecSQL(SQLDelIngrediente,[IdPlato,LVIngredientes.Items[ItemIndex].Text]);
      CargaIngredientes(idPlato);
   end;
end;

procedure TFormIntroRecetas.LVTiposClick(Sender: TObject);
begin
   If LVTipos.ItemIndex>-1 then EditTipo.Text:=LVTipos.Items[LVTipos.Selected.Index].Text;
   AddAlimento.SetFocus;
end;

procedure TFormIntroRecetas.BCierraRecetaClick(Sender: TObject);
begin
   MemoRecetaExit(Sender);
   Close;
end;

Procedure TFormIntroRecetas.CargaIngredientes(idPlato:Integer);
begin
   If idPlato<0 then exit;
   QueryIngredientes.Open('',[idPlato]);
end;

end.
