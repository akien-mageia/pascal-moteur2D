unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UDessinObjet, UDessinDecor, UParamPhys, UForme, UPoids,
  UPositionSolide, UVitesse, UResultante, USolideMouvement;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButDessinObjet: TButton;
    ButDessinDecor: TButton;
    ButParamPhys: TButton;
    ButLancerSim: TButton;
    ButQuitter: TButton;
    Image1: TImage;
    Timer1: TTimer;
    procedure ButDessinDecorClick(Sender: TObject);
    procedure ButDessinObjetClick(Sender: TObject);
    procedure ButLancerSimClick(Sender: TObject);
    procedure ButParamPhysClick(Sender: TObject);
    procedure ButQuitterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;
  SimulationEnCours: boolean;
  Forme: CForme;
  Poids: CPoids;
  Vitesse: CVitesse;
  Resultante: CResultante;
  SolideMouvement: CSolideMouvement;
  PositionSolide: CPositionSolide;

implementation

{ TForm1 }

procedure TForm1.ButDessinObjetClick(Sender: TObject);
begin
    Form2.Show;
end;

procedure TForm1.ButLancerSimClick(Sender: TObject);
begin
     Forme := CForme.Create();
     Forme.SetMasse(100);

     Vitesse := CVitesse.Create(0,0,0);

     Poids := CPoids.Create(0,0,0);
     Poids.SetG(9.81);
     Poids.CalculForce(Forme, Vitesse);

     Resultante := CResultante.Create();
     Resultante.SetForce(Poids);

     PositionSolide := CPositionSolide.Create(0,0,0);

     SolideMouvement := CSolideMouvement.Create(Resultante, PositionSolide, Vitesse, Forme);

     SimulationEnCours := true;
end;

procedure TForm1.ButParamPhysClick(Sender: TObject);
begin
    Form4.Show;
end;

procedure TForm1.ButQuitterClick(Sender: TObject);
begin
    FormeBMP.Free;
    DecorBMP.Free;
    Halt;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    SimulationEnCours := false;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (SimulationEnCours) then
  begin
    Resultante.CalculForce;
    SolideMouvement.CalculPosition();

    FormeBMP.Transparent := True;
    FormeBMP.TransparentColor := FormeBMP.Canvas.Pixels[0,0];
    Image1.canvas.Draw(0,0,DecorBMP);
    Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel(), SolideMouvement.GetPositionSolide().GetYPixel(),FormeBMP);
  end;
end;

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

end.

