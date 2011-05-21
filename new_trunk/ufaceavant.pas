unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UDessinObjet, UDessinDecor, UParamPhys, UPoids,
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
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;
  SimulationEnCours, FormePlacee, InitialisationVitesseEnCours: boolean;
  Poids: CPoids;
  Vitesse: CVitesse;
  Resultante: CResultante;
  SolideMouvement: CSolideMouvement;
  PositionSolide: CPositionSolide;
  Angle: integer;   // Temporaire, pour tester la rotation tant qu'on ne peut pas l'extraire des calculs

implementation

{ TForm1 }

procedure TForm1.ButDessinObjetClick(Sender: TObject);
begin
    Form2.Show;
end;

procedure TForm1.ButLancerSimClick(Sender: TObject);
begin
  if (SimulationEnCours = false) then
  begin
    if (Solide <> Nil) then begin
        Solide.SetMasse(100);

        Vitesse := CVitesse.Create(0,0,0);

        Poids := CPoids.Create(0,0,0);
        Poids.SetG(9.81);
        Poids.CalculForce(Solide, Vitesse);

        Resultante := CResultante.Create();
        Resultante.SetForce(Poids);

        PositionSolide := CPositionSolide.Create(0,0,0);

        SolideMouvement := CSolideMouvement.Create(Resultante, PositionSolide, Vitesse, Solide);

        Angle := 0;

        SimulationEnCours := true;
    end;
  end;
end;

procedure TForm1.ButParamPhysClick(Sender: TObject);
begin
    Form4.Show;
end;

procedure TForm1.ButQuitterClick(Sender: TObject);
begin
    Solide.Free;
    DecorBMP.Free;
    Halt;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    SimulationEnCours := False;
    InitialisationVitesseEnCours := False
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (SimulationEnCours) then
     begin
        SolideMouvement.GetPositionSolide().SetXPixel(X);
        SolideMouvement.GetPositionSolide().SetYPixel(Y);
        Image1.Canvas.Pen.Color := clBlack;
        Image1.Canvas.Pen.Width := 2;
        Image1.Canvas.Draw(0,0,DecorBMP);
        Image1.Canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                           SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                           Solide.getBMP[0]);
        FormePlacee := True;
        InitialisationVitesseEnCours := True
     end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (InitialisationVitesseEnCours) then
    begin
        Image1.canvas.Draw(0,0,DecorBMP);
        Image1.Canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                           SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                           Solide.getBMP[0]);
        Image1.Canvas.Line(X, Y,
                           SolideMouvement.GetPositionSolide().GetXPixel(),
                           SolideMouvement.GetPositionSolide().GetYPixel());
    end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  InitialisationVitesseEnCours := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (SimulationEnCours) and (FormePlacee) and (InitialisationVitesseEnCours = False) then
  begin
    Resultante.CalculForce;
    SolideMouvement.CalculPosition();
    if Angle < 340                        // Temporaire, a supprimer quand la rotation sera gérée par CalculPosition
    then Angle := Angle+20
    else Angle := 0;

    Image1.canvas.Draw(0,0,DecorBMP);
    Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       Solide.getBMP[round(Angle*Solide.getNbBMP/360)]);
  end;
end;

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

end.

