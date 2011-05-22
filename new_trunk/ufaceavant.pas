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
    function collisionDetectee() : boolean;
  end; 

var
  Form1: TForm1;
  SimulationEnCours, FormePlacee, InitialisationVitesseEnCours: boolean;
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
  if (SimulationEnCours = false) then
  begin
    if (Solide <> Nil) then begin
        Solide.SetMasse(1);      // 1 kg

        Vitesse := CVitesse.Create(0,0,0);

        Poids := CPoids.Create(0,0,0);
        Poids.SetG(9.81);
        Poids.CalculForce(Solide, Vitesse);

        Resultante := CResultante.Create();
        Resultante.SetForce(Poids);

        PositionSolide := CPositionSolide.Create(0,0,0);

        SolideMouvement := CSolideMouvement.Create(Resultante, PositionSolide, Vitesse, Solide);
        SolideMouvement.getPositionSolide().setAngle(0);

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
    SolideMouvement.Free;
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
                           SolideMouvement.getForme().getBMP[0]);
        FormePlacee := True;
        InitialisationVitesseEnCours := True
     end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (InitialisationVitesseEnCours) then
    begin
        Image1.Canvas.Draw(0,0,DecorBMP);
        Image1.Canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                           SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                           SolideMouvement.getForme().getBMP[0]);
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

    if (collisionDetectee())
    then begin
        SolideMouvement.getPositionSolide().setXPixel(300);     // Traitement arbitraire tant que la physique des collisions n'est pas gérée
        SolideMouvement.getPositionSolide().setYPixel(100);     // Sert juste à vérifier l'efficacité de la détection de collision
        end
    else begin
        if SolideMouvement.getPositionSolide().getAngle() < 340     // Temporaire, a supprimer quand la rotation sera gérée par CalculPosition
        then SolideMouvement.getPositionSolide().setAngle(SolideMouvement.getPositionSolide().getAngle() + 20)
        else SolideMouvement.getPositionSolide().setAngle(0);
        end;

    Image1.canvas.Draw(0,0,DecorBMP);
    Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360)]);
  end;
end;

function TForm1.collisionDetectee() : boolean;
var
    i, j, ecartX, ecartY, index, couleurNeutre: integer;
    test: boolean;
begin
    couleurNeutre := SolideMouvement.getForme().getBMP[0].Canvas.Pixels[0,0];
    index := round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360);
    ecartX := SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel();
    ecartY := SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel();
    i := 0;
    j := 0;
    test := false;
    while (i<SolideMouvement.getForme().getBMP[index].Width) and (test = false) do begin
        while (j<SolideMouvement.getForme().getBMP[index].Height) and (test = false) do
            if ((SolideMouvement.getForme().getBMP[index].Canvas.Pixels[i,j] <> couleurNeutre) and (DecorBMP.Canvas.Pixels[i+ecartX,j+ecartY] <> couleurNeutre))
            then test := true
            else j := j+1;
        j := 0;
        i := i+1;
        end;
    result := test;
end;

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

end.

