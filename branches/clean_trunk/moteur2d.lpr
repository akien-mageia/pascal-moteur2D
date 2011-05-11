program moteur2d;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UFaceAvant, LResources, UDessinObjet, UForme, UDessinDecor, UParamPhys, 
UPosition, UPositionSolide, UResultante, USolideMouvement, UTorseur, UVitesse, 
UArchimede, UFrottement, UMateriau, UPoids, UVent
  { you can add units after this };

{$IFDEF WINDOWS}{$R moteur2d.rc}{$ENDIF}

begin
  {$I moteur2d.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

