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
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure ButDessinDecorClick(Sender: TObject);
    procedure ButDessinObjetClick(Sender: TObject);
    procedure ButLancerSimClick(Sender: TObject);
    procedure ButParamPhysClick(Sender: TObject);
    procedure ButQuitterClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
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
  compteur:integer;  // provisoire pour des tests sur la rapidité du timer


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

        compteur := 0;
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

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if (SimulationEnCours) then
  SolideMouvement.GetVitesse().setOmega(StrToFloat(Edit1.Text));
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
var CoefLancement: Real;
begin
  if (InitialisationVitesseEnCours) then
     begin
       CoefLancement := 20;
       InitialisationVitesseEnCours := False;
       SolideMouvement.GetVitesse().setX((X-SolideMouvement.GetPositionSolide().GetXPixel())*CoefLancement);
       SolideMouvement.GetVitesse().setY((Y-SolideMouvement.GetPositionSolide().GetYPixel())*CoefLancement);
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (SimulationEnCours) and (FormePlacee) and (InitialisationVitesseEnCours = False) then
  begin
    compteur := compteur +1;
    Label2.Caption := 'Nombre d''itérations du timer : '+intToStr(compteur)+'. Angle : '+floatToStr(SolideMouvement.getPositionSolide.getAngle());
    Resultante.CalculForce;
    SolideMouvement.CalculPosition();

    if (collisionDetectee())
    then begin
        SolideMouvement.getPositionSolide().setXPixel(300);     // Traitement arbitraire tant que la physique des collisions n'est pas gérée
        SolideMouvement.getPositionSolide().setYPixel(100);     // Sert juste à vérifier l'efficacité de la détection de collision
        end;

    Image1.canvas.Draw(0,0,DecorBMP);
    Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360)]);
  end;
end;

function TForm1.collisionDetectee() : boolean;
var
    i, j, ecartX, ecartY, index: integer;
    test: boolean;
begin
    index := round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360);
    ecartX := SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel();
    ecartY := SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel();
    i := SolideMouvement.getForme().getSommets[index][0];
    j := SolideMouvement.getForme().getSommets[index][1];
    test := false;
    while (i>=SolideMouvement.getForme().getSommets[index][0]) and (i<=SolideMouvement.getForme().getSommets[index][2]) and (test = false) do begin
        while (j>=SolideMouvement.getForme().getSommets[index][1]) and (j<=SolideMouvement.getForme().getSommets[index][3]) and (test = false) do
            if (DecorBMP.Canvas.Pixels[i+ecartX,j+ecartY] <> clWhite) and (SolideMouvement.getForme().getBMP[index].Canvas.Pixels[i,j] <> clWhite)
            then test := true
            else j := j+1;
        j := SolideMouvement.getForme().getSommets[index][1];
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

