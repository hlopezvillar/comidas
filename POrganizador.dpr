program POrganizador;

uses
  System.StartUpCopy,
  FMX.Forms,
  FListado in 'FListado.pas' {FormListadoAlimentos},
  FIntroduccionRecetas in 'FIntroduccionRecetas.pas' {FormIntroRecetas},
  FPrincipal in 'FPrincipal.pas' {FormPrincipal},
  GestionDB in 'GestionDB.pas',
  FPlanificacionSemanal in 'FPlanificacionSemanal.pas' {FormPlanificaionSemanal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormIntroRecetas, FormIntroRecetas);
  Application.CreateForm(TFormListadoAlimentos, FormListadoAlimentos);
  Application.CreateForm(TFormPlanificaionSemanal, FormPlanificaionSemanal);
  Application.Run;
end.
