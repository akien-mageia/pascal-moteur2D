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
       // Sert a stocker les positions des pixels du decor en contact avec le solide en mouvement
       fTable: array [0..160*160] of CPosition;
       fNbPoints: integer;
  end;

  TForm1 = class(TForm)
    ButDessinObjet: TButton;
    ButDessinDecor: TButton;
    ButLancerSim: TButton;
    ButQuitter: TButton;
    ButtonSetOmega: TButton;
    EditSetOmega: TEdit;
    Image1: TImage;
    LabelVx: TLabel;
    LabelVy: TLabel;
    LabelOmega: TLabel;
    LabelX: TLabel;
    LabelY: TLabel;
    LabelAngle: TLabel;
    LabelSetOmega: TLabel;
    Timer1: TTimer;
    procedure ButDessinDecorClick(Sender: TObject);
    procedure ButDessinObjetClick(Sender: TObject);
    procedure ButLancerSimClick(Sender: TObject);
    procedure ButParamPhysClick(Sender: TObject);
    procedure ButQuitterClick(Sender: TObject);
    procedure ButtonSetOmegaClick(Sender: TObject);
    procedure EditSetOmegaChange(Sender: TObject);
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
    function rechercherPointContact(aAnglePrecedent: real) : CPosition;
    procedure remplissageTableauIntersection(aIndex, aEcartX, aEcartY: integer);
    function detectionZoneDuDecor() : integer;
    function calculTangente(aZoneDuDecor : integer) : CPosition;
    Procedure chercherPixelAutourDuPointDeContactHoraire(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
    Procedure chercherPixelAutourDuPointDeContactTrigo(x,y, x0, y0 : integer; var aPosition : CPosition; aPointTrouve : boolean);
    procedure calculCollision();
  end;

var
  Form1: TForm1;
  SimulationEnCours, FormePlacee, InitialisationVitesseEnCours, PointTrouve: boolean;
  SolideMouvement: CSolideMouvement;
  PointsIntersection: TRecordIntersection;
  PointContact: CPosition;
  VectTangent: CPosition;


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
    PositionSolide: CPositionSolide;
begin
  if (SimulationEnCours = false) then
  begin
    if (Solide <> Nil) and (DecorBMP <> Nil) then begin
        // Initialisation des variables globales et creation des torseurs et de la vitesse
        Vitesse := CVitesse.Create(0,0,0);

        Poids := CPoids.Create(0,0,0);
        Poids.SetG(9.81);         // Constante gravitationnelle en unites SI
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
        // Solide est une variable globale de USolideMouvement
        SolideMouvement.getPositionSolide().setAngle(0);

        PointsIntersection.fNbPoints := 0;
        PointContact := CPosition.Create(0, 0);
        VectTangent := CPosition.Create(0, 0);

        SimulationEnCours := true;

        Image1.Canvas.Draw(0,0,DecorBMP);    // Affichage du decor
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

procedure TForm1.ButtonSetOmegaClick(Sender: TObject);
begin
  if (SimulationEnCours) then
  SolideMouvement.GetVitesse().setOmega(StrToFloat(Form1.EditSetOmega.Text));
end;

procedure TForm1.EditSetOmegaChange(Sender: TObject);
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
            SolideMouvement.getPositionSolide.setAngle(0);
        //    SolideMouvement.getVitesse.setOmega(0);
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
var AnglePrecedent: real;
begin
  if (SimulationEnCours) and (FormePlacee) and (InitialisationVitesseEnCours = False) then
  begin
      AnglePrecedent := SolideMouvement.getPositionSolide().getAngle();
      SolideMouvement.getResultante().CalculForce(SolideMouvement.getForme(), SolideMouvement.getVitesse());
      SolideMouvement.CalculPosition();

      LabelVx.Caption := 'Vitesse horizontale : '+floatToStrF(SolideMouvement.getVitesse.getX, ffFixed, 2, 2)+' m/s';
      LabelVy.Caption := 'Vitesse verticale : '+floatToStrF(SolideMouvement.getVitesse.getY, ffFixed, 2, 2)+' m/s';
      LabelOmega.Caption := 'Vitesse angulaire : '+floatToStrF(SolideMouvement.getVitesse.getOmega, ffFixed, 2, 2)+' °/s';
      LabelX.Caption := 'Position horizontale : '+floatToStrF(SolideMouvement.getPositionSolide.getXMetre, ffFixed, 2, 2)+' m';
      LabelY.Caption := 'Position verticale : '+floatToStrF(SolideMouvement.getPositionSolide.getYMetre, ffFixed, 2, 2)+' m';
      LabelAngle.Caption := 'Angle : '+floatToStrF(SolideMouvement.getPositionSolide.getAngle, ffFixed, 2, 2)+' °';

      if (intersectionSolideDecor())
      then begin
          pointContact := rechercherPointContact(AnglePrecedent);
          VectTangent := calculTangente(detectionZoneDuDecor());

          calculCollision();
      end;

      Image1.canvas.Draw(0,0,DecorBMP);
      Image1.canvas.Draw(SolideMouvement.GetPositionSolide().GetXPixel()-SolideMouvement.GetForme().GetCentreInertie().GetXPixel(),
                       SolideMouvement.GetPositionSolide().GetYPixel()-SolideMouvement.GetForme().GetCentreInertie().GetYPixel(),
                       SolideMouvement.getForme().getBMP[round(SolideMouvement.getPositionSolide().getAngle()/20)]);
      Image1.canvas.Pen.Color := clBlue;
      Image1.canvas.Pen.Width := 4;
      Image1.canvas.Line(pointContact.GetXPixel(), pointContact.GetYPixel(), pointContact.GetXPixel() + VectTangent.getXPixel, pointContact.GetYPixel() + VectTangent.getYPixel);
      Image1.canvas.Pen.Color := clBlack;

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

function TForm1.rechercherPointContact(aAnglePrecedent: real) : CPosition;
var test: boolean;
    AngleFinal: real;
    i: integer;
begin
    test := true;
    AngleFinal := SolideMouvement.getPositionSolide().getAngle();
    i := 0;
    while (test) do begin    // Tant que la position de l'objet est superposee a un element du decor
        // On "recule" l'objet a partir de la position de collision dans la direction opposee de la vitesse, pixel par pixel.
        SolideMouvement.getPositionSolide.SetXMetre(SolideMouvement.getPositionSolide.GetXMetre() - TAILLEPIXEL*SolideMouvement.getVitesse.GetX()/sqrt(SolideMouvement.getVitesse.GetX()*SolideMouvement.getVitesse.GetX()+SolideMouvement.getVitesse.GetY()*SolideMouvement.getVitesse.GetY()));
        SolideMouvement.getPositionSolide.SetYMetre(SolideMouvement.getPositionSolide.GetYMetre() - TAILLEPIXEL*SolideMouvement.getVitesse.GetY()/sqrt(SolideMouvement.getVitesse.GetX()*SolideMouvement.getVitesse.GetX()+SolideMouvement.getVitesse.GetY()*SolideMouvement.getVitesse.GetY()));

        //
        if i<5 then begin
             SolideMouvement.getPositionSolide.SetAngle(SolideMouvement.getPositionSolide.GetAngle() - 0.2*(AngleFinal-aAnglePrecedent));
             while (SolideMouvement.getPositionSolide.GetAngle()>=350) do SolideMouvement.getPositionSolide.SetAngle(SolideMouvement.getPositionSolide.GetAngle()-360);
             while (SolideMouvement.getPositionSolide.GetAngle()<-10) do SolideMouvement.getPositionSolide.SetAngle(SolideMouvement.getPositionSolide.GetAngle()+360);
             i := i + 1;
        end;
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

procedure TForm1.calculCollision();
var VectCG: CPosition;                                         // C point de contact, G centre de gravite, base absolue
    xG, yG, Vx0, Vy0, Vx1, Vy1, omega0, omega1, discr: real;   // en unites SI dans la base "tangente"
    newVx, newVy: real;                                        // en unites SI dans la base absolue (resultats)
    m, J, coef: real;                                          // masse et moment d'inertie, coefficient elastique
begin
    // Definition des constantes
    m := SolideMouvement.getForme().getMasse();
    J := SolideMouvement.getForme().getJ();
    VectCG := CPosition.Create(-PointContact.getXPixel + SolideMouvement.getPositionSolide.getXPixel,
                               -PointContact.getYPixel + SolideMouvement.getPositionSolide.getYPixel);

    // Definition de l'etat initial et changement de base
    xG := VectCG.getXMetre*VectTangent.getXMetre + VectCG.getYMetre*VectTangent.getYMetre;
          // Produit scalaire pour avoir la projection de CG sur VectTangent
    yG := -VectCG.getXMetre*VectTangent.getYMetre + VectCG.getYMetre*VectTangent.getXMetre;
          // Produit scalaire de CG par le vecteur normal (-y, x) defini a partir du vecteur tangent (x, y)

    Vx0 := SolideMouvement.getVitesse.getX*VectTangent.getXMetre + SolideMouvement.getVitesse.getY*VectTangent.getYMetre;
          // Produit scalaire pour avoir la projection de V sur VectTangent
    Vy0 := -SolideMouvement.getVitesse.getX*VectTangent.getYMetre + SolideMouvement.getVitesse.getY*VectTangent.getXMetre;
          // Produit scalaire pour avoir la projection de V sur le vecteur normal

    omega0 := SolideMouvement.getVitesse.getOmega*3.14/180;

    // Calcul de l'etat final
    discr := omega0*omega0*J*J - 2*J*m*Vx0*yG*omega0 + 2*J*m*Vy0*xG*omega0
             + 2*m*m*Vx0*Vy0*yG*xG + 4*m*m*yG*yG*omega0*Vy0*xG + m*m*Vx0*Vx0*yG*yG
             + m*m*Vy0*Vy0*xG*xG - 4*m*m*Vx0*yG*xG*xG*omega0 - 4*m*m*yG*yG*omega0*omega0*xG*xG;
    if discr<0 then discr := 0;   // pas du tout physique ! :)

    omega1 := (1/(m*yG*yG+m*xG*xG+J))*(-m*xG*xG*omega0 + m*Vx0*yG + m*yG*yG*omega0 + m*Vy0*xG
              + sqrt(discr));
    Vx1 := Vx0 + yG*(omega0 - omega1);
    Vy1 := -Vy0 + xG*(omega0 + omega1);

    // Calcul du coefficient elastique
    case Image1.Canvas.Pixels[PointContact.getXPixel, PointContact.getYPixel] of
        clGreen: coef := 0.80;
        clFuchsia: coef := 0.85;
        clYellow: coef := 0.80;
        clTeal: coef := 0.90;
        clGray: coef := 0.95;
        clMaroon: coef := 0.90;
    else coef := 0.95;
    end;

    // Changement de base et application du coefficient
           // On procede toujours par produit scalaire.
           // Remarque pour la comprehension des calculs : si le vecteur tangent (X1) a pour coordonnees (x, y) dans la base 0,
           // les vecteurs du repere absolu dans la base 1 sont X0 = (x, -y) et Y0 = (y, x).

    newVx := coef*(Vx1*VectTangent.getXMetre - Vy1*VectTangent.getYMetre);
    newVy := coef*(Vx1*VectTangent.getYMetre + Vy1*VectTangent.getXMetre);
    omega1 := coef*(omega1*180/3.14);

    // Resultats
    SolideMouvement.getVitesse.setX(newVx);
    SolideMouvement.getVitesse.setY(newVy);
    SolideMouvement.getVitesse.setOmega(omega1);
end;

initialization
  {$I ufaceavant.lrs}

end.

