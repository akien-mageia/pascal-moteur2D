unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UDessinObjet, UDessinDecor, UParamPhys, UPoids, UArchimede, UFrottement,
  UPosition, UPositionSolide, UVitesse, UResultante, USolideMouvement, Math;

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
    function detectionZoneDuDecor() : integer;
    function calculTangente(aZoneDuDecor : integer) : CPosition;
    Procedure chercherPixelAutourDuPointDeContactHoraire(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
    Procedure chercherPixelAutourDuPointDeContactTrigo(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
  end; 

var
  Form1: TForm1;
  SimulationEnCours, FormePlacee, InitialisationVitesseEnCours, PointTrouve: boolean;
  SolideMouvement: CSolideMouvement;
  PositionSolide: CPositionSolide;
  PointsIntersection: TRecordIntersection;
  compteur:integer;  // provisoire pour des tests sur la rapidité du timer
  pointContact: CPosition;


implementation

{ TForm1 }

procedure TForm1.ButDessinObjetClick(Sender: TObject);
begin
    Form2.Show;
end;

procedure TForm1.ButLancerSimClick(Sender: TObject);
var Vitesse: CVitesse;
    Poids: CPoids;
    Archimede: CArchimede;
    Frottement: CFrottement;
    Resultante: CResultante;
begin
  if (SimulationEnCours = false) then
  begin
    if (Solide <> Nil) and (DecorBMP <> Nil) then begin

        Vitesse := CVitesse.Create(0,0,0);

        Poids := CPoids.Create(0,0,0);
        Poids.SetG(9.81);
        Poids.CalculForce(Solide, Vitesse);

        Archimede := CArchimede.Create(0,0,0);
        Archimede.setRho(1.184);  // Masse volumique de l'air sec a 25 deg C en kg/m^3
        Archimede.calculForce(Solide, Vitesse);

        Frottement := CFrottement.Create(0,0,0);
        Frottement.setCoef(0.2);  // Coefficient arbitraire (TODO: calculer le vrai coefficient a partir de la viscosite du fluide et de la forme de l'objet)
        Frottement.calculForce(Solide, Vitesse);

        Resultante := CResultante.Create();
        Resultante.SetForce(Poids);
        Resultante.SetForce(Archimede);
        Resultante.SetForce(Frottement);

        PositionSolide := CPositionSolide.Create(0,0,0);

        SolideMouvement := CSolideMouvement.Create(Resultante, PositionSolide, Vitesse, Solide);
        SolideMouvement.getPositionSolide().setAngle(0);

        PointsIntersection.fNbPoints := 0;
        pointContact := CPosition.Create(0, 0);

        compteur := 0;
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
var testContactX, testContactY: integer;
    testVecteurTangent: CPosition;
begin
  if (SimulationEnCours) and (FormePlacee) and (InitialisationVitesseEnCours = False) then
  begin
    compteur := compteur +1;
    Label2.Caption := 'Timer : '+intToStr(compteur)+'. Angle : '+floatToStr(SolideMouvement.getPositionSolide.getAngle())+'. Zone : '+floatToStr(detectionZoneDuDecor())+'. Atan : '+floatToStr(arctan2(SolideMouvement.getVitesse.GetY(), SolideMouvement.getVitesse.GetX()));
    SolideMouvement.getResultante().CalculForce(SolideMouvement.getForme(), SolideMouvement.getVitesse());
    SolideMouvement.CalculPosition();

    if (intersectionSolideDecor())
    then begin
        pointContact := rechercherPointContact();
        Image1.canvas.Draw(0,0,DecorBMP);
        Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()/20)]);

        Image1.canvas.Pixels[pointContact.GetXPixel(), pointContact.GetYPixel()] := clRed;
        testVecteurTangent := calculTangente(detectionZoneDuDecor());
        Image1.canvas.Pen.Color := clBlue;
        Image1.canvas.Line(pointContact.GetXPixel(), pointContact.GetYPixel(), pointContact.GetXPixel() + testVecteurTangent.getXPixel, pointContact.GetYPixel() + testVecteurTangent.getYPixel);
        Image1.canvas.Pen.Color := clBlack;

        SolideMouvement.getPositionSolide().setXPixel(300);     // Traitement arbitraire tant que la physique des collisions n'est pas gérée
        SolideMouvement.getPositionSolide().setYPixel(100);     // Sert juste à vérifier l'efficacité de la détection de collision
        end;

     // Image1.canvas.Draw(0,0,DecorBMP);
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
    index := round(SolideMouvement.getPositionSolide().getAngle()*SolideMouvement.getForme().getNbBMP/360);
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
                pixel := CPosition.Create(i+SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(), j+SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel());
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

    result := PointsIntersection.fTable[round(PointsIntersection.fNbPoints/2)];
end;

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
    Form3.Show;
end;

function TForm1.detectionZoneDuDecor() : integer;
var res: integer;
begin
    if SolideMouvement.getVitesse.GetX() = 0
    then if SolideMouvement.getVitesse.GetY() > 0
         then res := 6
         else res := 2
    else res := round (((7*Pi)/8 + arctan2(SolideMouvement.getVitesse.GetY(), SolideMouvement.getVitesse.GetX()))/(2*Pi)*8);
    result := res;
end;



function TForm1.calculTangente(aZoneDuDecor : integer) : CPosition;
var PositionPixelPlein1, PositionPixelPlein2 : CPosition;
    VecteurTangent, Vecteur1, Vecteur2 : Cposition;
    PointTrouve : boolean;
    NormeVecteurTangent : real;
    X1,Y1,X2,Y2 : integer;
begin
    PositionPixelPlein1 := CPosition.Create(0,0);
    PositionPixelPlein2 := CPosition.Create(0,0);
    VecteurTangent := CPosition.Create(0,0);
    Vecteur1 := CPosition.Create(0,0);
    Vecteur2 := CPosition.Create(0,0);
    Case aZoneDuDecor of
       0 : begin
            X1 := 1 ; Y1 := 1 ; X2 := 1 ; Y2 := 0;
           end;
       1 : begin
            X1 := 0 ; Y1 := 1 ; X2 := 1 ; Y2 := 1;
           end;
       2 : begin
            X1 := -1 ; Y1 := 1 ; X2 := 0 ; Y2 := 1;
           end;
       3 : begin
            X1 := -1 ; Y1 := 0 ; X2 := -1 ; Y2 := 1;
           end;
       4 : begin
            X1 := -1 ; Y1 := -1 ; X2 := -1 ; Y2 := 0;
           end;
       5 : begin
            X1 := 0 ; Y1 := -1 ; X2 := -1 ; Y2 := -1;
           end;
       6 : begin
            X1 := 1 ; Y1 := -1 ; X2 := 0 ; Y2 := -1;
           end;
       7 : begin
           X1 := 1 ; Y1 := 0 ; X2 := 1 ; Y2 := -1;
           end;
       end;


           chercherPixelAutourDuPointDeContactHoraire(X1,Y1,X1,Y1, PositionPixelPlein1, PointTrouve);
           if (PointTrouve = false) then
               begin
                  VecteurTangent.SetXMetre(1/Sqrt(2));              // ne devrait jamais servir car on ne peut pas dessiner de pixels esseules mais je donne une tangente aleatoire pour eviter un plantage ou boucle infinie au cas ou
                  VecteurTangent.SetYMetre(1/Sqrt(2));
               end
            else
              begin
                chercherPixelAutourDuPointDeContactTrigo(X2,Y2,X2,Y2, PositionPixelPlein2, PointTrouve);
                if (PointTrouve = false) then
                   begin
                      NormeVecteurTangent := sqrt((PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())*(PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())+(PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre())*(PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre()));
                      VecteurTangent.SetXMetre((PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())/NormeVecteurTangent);
                      VecteurTangent.SetYMetre((PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre())/NormeVecteurTangent);
                   end
                else
                  begin
                      NormeVecteurTangent := sqrt((PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())*(PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())+(PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre())*(PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre()));
                      Vecteur1.SetXMetre((PositionPixelPlein1.GetXMetre()-PointContact.GetXMetre())/NormeVecteurTangent);
                      Vecteur1.SetYMetre((PositionPixelPlein1.GetYMetre()-PointContact.GetYMetre())/NormeVecteurTangent);
                      NormeVecteurTangent := sqrt((PositionPixelPlein2.GetXMetre()-PointContact.GetXMetre())*(PositionPixelPlein2.GetXMetre()-PointContact.GetXMetre())+(PositionPixelPlein2.GetYMetre()-PointContact.GetYMetre())*(PositionPixelPlein2.GetYMetre()-PointContact.GetYMetre()));
                      Vecteur2.SetXMetre((PositionPixelPlein2.GetXMetre()-PointContact.GetXMetre())/NormeVecteurTangent);
                      Vecteur2.SetYMetre((PositionPixelPlein2.GetYMetre()-PointContact.GetYMetre())/NormeVecteurTangent);
                      if (Vecteur1.GetXMetre()*Vecteur2.GetXMetre()+Vecteur1.GetYMetre()*Vecteur2.GetYMetre()<=0) then
                         begin
                            Vecteur2.SetXMetre(-Vecteur2.GetXMetre());
                            Vecteur2.SetYMetre(-Vecteur2.GetYMetre());
                         end;
                      NormeVecteurTangent := sqrt((Vecteur1.GetXMetre()+Vecteur2.GetXMetre())*(Vecteur1.GetXMetre()+Vecteur2.GetXMetre())+(Vecteur1.GetYMetre()+Vecteur2.GetYMetre())*(Vecteur1.GetYMetre()+Vecteur2.GetYMetre()));
                      VecteurTangent.SetXMetre((Vecteur1.GetXMetre()+Vecteur2.GetXMetre())/NormeVecteurTangent);
                      VecteurTangent.SetYMetre((Vecteur1.GetYMetre()+Vecteur2.GetYMetre())/NormeVecteurTangent);
                  end;
                end;
              result := VecteurTangent;


end;

Procedure TForm1.chercherPixelAutourDuPointDeContactHoraire(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
begin
   if (DecorBMP.Canvas.Pixels[PointContact.GetXPixel()+x,PointContact.GetYPixel()+y] <> clWhite)
   then begin
        aPosition.SetXPixel(PointContact.GetXPixel()+x);
        aPosition.SetYPixel(PointContact.GetYPixel()+y);
        aPointTrouve := true;
        end
   else
       Case x of
           -1 : Case y of
               -1 : if (x0=0) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(0,-1, x0, y0, aPosition, aPointTrouve);
               0 : if (x0=-1) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(-1,-1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=-1) and (y0=0) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(-1,0, x0, y0, aPosition, aPointTrouve);
               end;
           0 : Case y of
               -1 : if (x0=1) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(1,-1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=-1) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(-1,1, x0, y0, aPosition, aPointTrouve);
               end;
           1 : Case y of
               -1 : if (x0=1) and (y0=0) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(1,0, x0, y0, aPosition, aPointTrouve);
               0 : if (x0=1) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(1,1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=0) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactHoraire(0,1, x0, y0, aPosition, aPointTrouve);
               end;
        end;
end;

Procedure TForm1.chercherPixelAutourDuPointDeContactTrigo(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
begin
   if (DecorBMP.Canvas.Pixels[PointContact.GetXPixel()+x,PointContact.GetYPixel()+y] <> clWhite)
   then begin
        aPosition.SetXPixel(PointContact.GetXPixel()+x);
        aPosition.SetYPixel(PointContact.GetYPixel()+y);
        aPointTrouve := true;
        end
   else
       Case x of
           -1 : Case y of
               -1 : if (x0=-1) and (y0=0) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(-1,0, x0, y0, aPosition, aPointTrouve);
               0 : if (x0=-1) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(-1,1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=0) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(0,1, x0, y0, aPosition, aPointTrouve);
               end;
           0 : Case y of
               -1 : if (x0=-1) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(-1,-1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=1) and (y0=1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(1,1, x0, y0, aPosition, aPointTrouve);
               end;
           1 : Case y of
               -1 : if (x0=0) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(0,-1, x0, y0, aPosition, aPointTrouve);
               0 : if (x0=1) and (y0=-1) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(1,-1, x0, y0, aPosition, aPointTrouve);
               1 : if (x0=1) and (y0=0) then aPointtrouve := false else chercherPixelAutourDuPointDeContactTrigo(1,0, x0, y0, aPosition, aPointTrouve);
               end;
        end;
end;


initialization
  {$I ufaceavant.lrs}

end.

