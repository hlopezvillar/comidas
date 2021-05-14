unit FListado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFormListadoAlimentos = class(TForm)
    ToolBar1: TToolBar;
    LVPlatos: TListView;
    FDConnection1: TFDConnection;
    QueryPlatos: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    QueryPlatosNOMBRE: TStringField;
    QueryPlatosIDPLATO: TFDAutoIncField;
    MemoMensajes: TMemo;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    BCerrar: TButton;
    BAddPlato: TButton;
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure LVPlatosChange(Sender: TObject);
    procedure BCerrarClick(Sender: TObject);
    procedure BAddPlatoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LVPlatosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    Procedure MuestraError(Mensaje:String);
  public
    { Public declarations }
  end;

var
  FormListadoAlimentos: TFormListadoAlimentos;

implementation


Uses System.IOUtils,FIntroduccionRecetas,GestionDB;

{$R *.fmx}

procedure TFormListadoAlimentos.BAddPlatoClick(Sender: TObject);
begin
   FormIntroRecetas.idPlato:=-1;
   FormIntroRecetas.ShowModal;
   QueryPlatos.Close;
   QueryPlatos.Open;
end;

procedure TFormListadoAlimentos.BCerrarClick(Sender: TObject);
begin
   Close;
end;

procedure TFormListadoAlimentos.FDConnection1BeforeConnect(Sender: TObject);
begin
   FDConnection1.Params.Values['Database']:=pGestionDB.GetDBDir;
end;

procedure TFormListadoAlimentos.FormShow(Sender: TObject);
begin
   QueryPlatos.Open;
end;

procedure TFormListadoAlimentos.LVPlatosChange(Sender: TObject);
begin
{   FormIntroRecetas.idPlato:=StrToInt(LVPlatos.Items[LVPlatos.Selected.Index].Detail);
   FormIntroRecetas.ShowModal;
   QueryPlatos.Close;
   QueryPlatos.Open;}
end;

procedure TFormListadoAlimentos.LVPlatosItemClick(const Sender: TObject;const AItem: TListViewItem);
begin
   FormIntroRecetas.idPlato:=StrToInt(AItem.Detail);
   FormIntroRecetas.ShowModal;
   QueryPlatos.Close;
   QueryPlatos.Open;
end;

Procedure TFormListadoAlimentos.MuestraError(Mensaje:String);
begin
   ShowMessage(Mensaje);
   MemoMensajes.Lines.Add(Mensaje);
end;


end.
