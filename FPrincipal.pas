unit FPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo;

type
  TFormPrincipal = class(TForm)
    BGestionPlatos: TButton;
    StyleBook1: TStyleBook;
    MemoDebug: TMemo;
    BPlanSemanal: TButton;
    procedure BGestionPlatosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

Uses FListado,GestionDB;


procedure TFormPrincipal.BGestionPlatosClick(Sender: TObject);
begin
   FormListadoAlimentos.ShowModal;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   pGestionDB:=CGestionDB.Create;
   If Not(pGestionDB.Checkdatabase) then MemoDebug.Lines.Add('Falta la tabla Etiquetas');
   MemoDebug.Lines.Add(pGestionDB.GetDBDir);
end;

end.
