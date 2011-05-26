unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UDessinObjet, UDessinDecor, UParamPhys, UPoids, UPosition,
  UPositionSolide, UVitesse, UResultante, USolideMouvement;

type

  { TForm1 }
  TRecordIntersection = record
       fTable: array [0..160*160] of CPosition;
       fNbPoints: integer;
  end;

  TForm1 = class(TForm)
    ButDessinObjet: TButton;
    ButDessinDecor: TButton;
    ButParamPhys: TButton;
    ButLancerSim: TButton;
    ButQuitter: TButton;
    Button1: TButton;
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
    procedure Button1Click(Sender: TObject);
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
    function intersectionSolideDecor() : boolean;
    function rechercherPointContact() : CPosition;
    procedure remplissageTableauIntersection(aIndex, aEcartX, aEcartY: integer);
  end; 

var
  Form1: TForm1;
  SimulationEnCours, FormePlacee, InitialisationVitesseEnCours: boolean;
  Poids: CPoids;
  Vitesse: CVitesse;
  Resultante: CResultante;
  SolideMouvement: CSolideMouvement;
  PositionSolide: CPositionSolide;
  PointsIntersection: TRecordIntersection;
  compteur:integer;  // provisoire pour des tests sur la rapidité du timer
//  Xrouge,Yrouge: integer;


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

        Solide.SetMassePixel(0.1);  // en kg donc 100g par pixel soit un objet de quelques dizaines de kg
        Solide.CalculMasse();
        Solide.CalculJ();

        Vitesse := CVitesse.Create(0,0,0);

        Poids := CPoids.Create(0,0,0);
        Poids.SetG(9.81);
        Poids.CalculForce(Solide, Vitesse);

        Resultante := CResultante.Create();
        Resultante.SetForce(Poids);

        PositionSolide := CPositionSolide.Create(0,0,0);

        SolideMouvement := CSolideMouvement.Create(Resultante, PositionSolide, Vitesse, Solide);
        SolideMouvement.getPositionSolide().setAngle(0);

        PointsIntersection.fNbPoints := 0;

        compteur := 0;
 //       Xrouge:= 0;
 //       Yrouge := 0;
        SimulationEnCours := true;

        Image1.Canvas.Draw(0,0,DecorBMP);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (SimulationEnCours) then
  SolideMouvement.GetVitesse().setOmega(StrToFloat(Form1.Edit1.Text));
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

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
        if (intersectionSolideDecor() = false) then begin
            Image1.Canvas.Pen.Color := clBlack;
            Image1.Canvas.Pen.Width := 2;
            Image1.Canvas.Draw(0,0,DecorBMP);
            Image1.Canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                               SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                               SolideMouvement.getForme().getBMP[0]);
            FormePlacee := True;
            InitialisationVitesseEnCours := True;
        end
        else begin
            FormePlacee := False;
            InitialisationVitesseEnCours := False;
        end;
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
       CoefLancement := 0.07;
       InitialisationVitesseEnCours := False;
       SolideMouvement.GetVitesse().setX((X-SolideMouvement.GetPositionSolide().GetXPixel())*CoefLancement);
       SolideMouvement.GetVitesse().setY((Y-SolideMouvement.GetPositionSolide().GetYPixel())*CoefLancement);
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var pointContact: CPosition;
begin
  if (SimulationEnCours) and (FormePlacee) and (InitialisationVitesseEnCours = False) then
  begin
    compteur := compteur +1;
    Label2.Caption := 'Nombre d''itérations du timer : '+intToStr(compteur)+'. Angle : '+floatToStr(SolideMouvement.getPositionSolide.getAngle());
    Resultante.CalculForce;
    SolideMouvement.CalculPosition();

    if (intersectionSolideDecor())
    then begin
        pointContact := rechercherPointContact();
        Image1.canvas.Draw(0,0,DecorBMP);
        Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()/20)]);

//        Xrouge := pointContact.getXPixel + SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel();
//        Yrouge := 1+pointContact.getYPixel + SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel();
        SolideMouvement.getPositionSolide().setXPixel(300);     // Traitement arbitraire tant que la physique des collisions n'est pas gérée
        SolideMouvement.getPositionSolide().setYPixel(100);     // Sert juste à vérifier l'efficacité de la détection de collision
        end;

      Image1.canvas.Draw(0,0,DecorBMP);
      Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()/20)]);
  end;
end;

function TForm1.intersectionSolideDecor() : boolean;
var
    i, j, ecartX, ecartY, index: integer;
    test: boolean;
begin
    index := round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360);          // Je ne sais pas ce que c'est mais je pense qu'il faut le modifier (cf affichage de l'angle)
    ecartX := SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel();
    ecartY := SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel();
    i := SolideMouvement.getForme().getSommets[index][0];
    j := SolideMouvement.getForme().getSommets[index][1];
    test := false;

    while (i>=SolideMouvement.getForme().getSommets[index][0]) and (i<=SolideMouvement.getForme().getSommets[index][2]) and (test = false) do begin
        while (j>=SolideMouvement.getForme().getSommets[index][1]) and (j<=SolideMouvement.getForme().getSommets[index][3]) and (test = false) do
            if (DecorBMP.Canvas.Pixels[i+ecartX,j+ecartY] <> clWhite) and (SolideMouvement.getForme().getBMP[index].Canvas.Pixels[i,j] <> clWhite)
            then begin
                test := true;
                remplissageTableauIntersection(index, ecartX, ecartY);
            end
            else j:=j+1;
        j := SolideMouvement.getForme().getSommets[index][1];
        i := i+1;
        end;

    result := test;
end;

procedure TForm1.remplissageTableauIntersection(aIndex, aEcartX, aEcartY: integer);
var i, j: integer;
    pixel: CPosition;
    newPointsIntersection: TRecordIntersection;
begin
    i := SolideMouvement.getForme().getSommets[aIndex][0];
    j := SolideMouvement.getForme().getSommets[aIndex][1];
    newPointsIntersection.fNbPoints := 0;

    for i:=SolideMouvement.getForme().getSommets[aIndex][0] to SolideMouvement.getForme().getSommets[aIndex][2] do begin
        for j:=SolideMouvement.getForme().getSommets[aIndex][1] to SolideMouvement.getForme().getSommets[aIndex][3] do
            if (DecorBMP.Canvas.Pixels[i+aEcartX,j+aEcartY] <> clWhite) and (SolideMouvement.getForme().getBMP[aIndex].Canvas.Pixels[i,j] <> clWhite)
            then begin
                newPointsIntersection.fNbPoints := newPointsIntersection.fNbPoints + 1;
                pixel := CPosition.Create(i, j);
                newPointsIntersection.fTable[newPointsIntersection.fNbPoints - 1] := pixel;
                end;
        j := SolideMouvement.getForme().getSommets[aIndex][1];
        end;

    if newPointsIntersection.fNbPoints <> 0
    then PointsIntersection := newPointsIntersection;
end;

function TForm1.rechercherPointContact() : CPosition;
var test: boolean;
begin
    test := true;
    while (test) do begin
        SolideMouvement.getPositionSolide.SetXMetre(SolideMouvement.getPositionSolide.GetXMetre() - 0.01*SolideMouvement.getVitesse.GetX()/sqrt(SolideMouvement.getVitesse.GetX()*SolideMouvement.getVitesse.GetX()+SolideMouvement.getVitesse.GetY()*SolideMouvement.getVitesse.GetY()));
        SolideMouvement.getPositionSolide.SetYMetre(SolideMouvement.getPositionSolide.GetYMetre() - 0.01*SolideMouvement.getVitesse.GetY()/sqrt(SolideMouvement.getVitesse.GetX()*SolideMouvement.getVitesse.GetX()+SolideMouvement.getVitesse.GetY()*SolideMouvement.getVitesse.GetY()));
        test := intersectionSolideDecor();
    end;

    result := PointsIntersection.fTable[0];
end;

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

end.

