unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme, FPImage, intfGraphics, LCLType;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButRecommencer: TButton;
    ButVoirObjet: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
    procedure ButVoirObjetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

//procedure RemplirAdjacent(aX,aY: integer);
procedure RemplissageParLigne(aXSeed,aYSeed,aOldColor,aNewColor: integer);
//procedure CalculDimDessin();

var
  Form2: TForm2;
  DessinEnCours, RemplissageEnCours : boolean;
  TentativeSolide : CForme;
  Solide: CForme;
  X0, Y0: integer;
//  DessinHauteur,DessinLargeur: integer;
  FormeBMP: TBitmap;
  FormeLII: TLazIntfImage;

implementation

{ TForm2 }

procedure TForm2.ButAnnulerClick(Sender: TObject);
begin
    Form2.Close();
end;

procedure TForm2.ButRecommencerClick(Sender: TObject);
var i,j: integer;
begin
    Canvas.Clear();
//    for i:=0 to TentativeSolide.getWidth()-1 do
//        begin
//            for j:=0 to TentativeSolide.getHeight()-1 do
//                TentativeSolide.SetBoolean(i, j, false);
//            j := 0;
//        end;
end;

procedure TForm2.ButValiderClick(Sender: TObject);
var i,j : integer;

// BlancDroite, BlancGauche, BlancHaut, BlancBas, BlancDroiteProvisoire,
//BlancGaucheProvisoire, BlancHautProvisoire, BlancBasProvisoire  : integer;
begin
      FormeBMP := TBitmap.Create;
      FormeBMP.LoadFromFile('forme.bmp');

  {    for i:= 0 to 225-1 do
      begin
           BlancHaut:=220;
           BlancBas:=220;
           j:=0;
           While (Canvas.Pixels[i+10,j+10] <> clBlack) and (j<220) do
           j:=j+1;
           if j<BlancHaut then BlancHaut:=j;
           j:=0;
           While (Canvas.Pixels[i+10,220-j] <> clBlack) and (j<220) do
           j:=j+1;
           if j<BlancBas then BlancBas:=j;
      end;
      FormeBMP.Height := 220; }

      FormeLII := FormeBMP.CreateIntfImage;
      for i:=0 to FormeLII.Width-1 do
        begin
            for j:=0 to FormeLII.Height-1 do
                if (Canvas.Pixels[i+10,j+10] = clBlack) or (Canvas.Pixels[i+10,j+10] = clGray)
                then FormeLII.Colors[i,j] := colBlack;
                j:=0;
        end;
      FormeBMP.LoadFromIntfImage(FormeLII);
      Form2.Close();
end;

procedure TForm2.ButVoirObjetClick(Sender: TObject);
var i,j : integer;
begin
//    TentativeSolide.RemplirForme();
//    Canvas.Clear();
//    for i:=0 to TentativeSolide.getWidth()-1 do
 //       begin
//            for j:=0 to TentativeSolide.getHeight()-1 do
//                if TentativeSolide.getBoolean(i, j) = true
//                then Canvas.Pixels[i,j] := clBlack;
//            j := 0;
//        end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
//    TentativeSolide := CForme.create(Form2.width-140, Form2.height-20);  // Les differences servent a avoir la meme taille que le cadre de dessin
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var oldColor: integer;
begin
    if RemplissageEnCours = false
    then begin
        DessinEnCours := true;
        Canvas.Pen.Color:=clBlack;
        Canvas.Pen.Width:=2;
        if ((X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10))
            then begin
                X0 := X;
                Y0 := Y;
                Canvas.MoveTo(X,Y);
                Canvas.Pixels[X,Y] := clBlack;
//                TentativeSolide.SetBoolean(X,Y,true);
//                TentativeSolide.SetBoolean(X,Y-1,true);
//                TentativeSolide.SetBoolean(X-1,Y,true);
//                TentativeSolide.SetBoolean(X-1,Y-1,true);
            end;
        end
    else begin
        if ((X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10))// and (Canvas.Pixels[X,Y] = clBtnFace))
        then begin
            oldColor := Form2.Canvas.Pixels[X,Y];
            RemplissageParLigne(X,Y,oldColor,clGray);
            RemplissageEnCours := false;
        end;
    end;
end;

//procedure CalculDimDessin();
//var i,j,X1,X2,Y1,Y2: integer;
//    trouve: boolean;
//begin
//    i:=0;
//    trouve:=false;
//    // Parcours en lignes verticales a partir de la gauche pour trouver le premier point du dessin
//    while ((i<Form2.Width-131) and (trouve = false)) do begin
//        for j:=0 to Form2.Height-11 do
//            if Form2.Canvas.Pixels[i,j] = clBlack
//            then begin
//                trouve := true;
//                X1:=i;
//                end;
//        i := i+1;
//        end;
//
//    i:=Form2.Width-130;
//    trouve:=false;
//    // Parcours en lignes verticales a partir de la droite pour trouver le dernier point du dessin
//    while ((i>0) and (trouve = false)) do begin
//        for j:=0 to Form2.Height-11 do
//            if Form2.Canvas.Pixels[i,j] = clBlack
//            then begin
//                trouve := true;
//                X2:=i;
//                end;
//        i := i-1;
//        end;
//
//    j:=0;
//    trouve:=false;
//    // Parcours en lignes horizontales partir du haut pour trouver le premier point du dessin
//    while ((j<Form2.Height-11) and (trouve = false)) do begin
//        for i:=0 to Form2.Width-131 do
//            if Form2.Canvas.Pixels[i,j] = clBlack
//            then begin
//                trouve := true;
//                Y1:=j;
//                end;
//        j := i+1;
//        end;
//
//    j:=Form2.Height-10;
//    trouve:=false;
//    // Parcours en lignes horizontales partir du bas pour trouver le dernier point du dessin
//    while ((j>0) and (trouve = false)) do begin
//        for i:=0 to Form2.Width-131 do
//            if Form2.Canvas.Pixels[i,j] = clBlack
//            then begin
//                trouve := true;
//                Y2:=j;
//                end;
//        j := i-1;
//        end;
//
//    DessinHauteur := Y2-Y1+1;
//    DessinLargeur := X2-X1+1;
//end;
//
//procedure RemplirAdjacent(aX,aY: integer);
//begin
//    if Form2.Canvas.Pixels[aX,aY] <> clBlack
//    then begin
//        Form2.Canvas.Pixels[aX,aY] := clBlack;
//        if (Form2.Canvas.Pixels[aX-1,aY] <> clBlack) and (aX>11)
//        then RemplirAdjacent(aX-1,aY);
//        if (Form2.Canvas.Pixels[aX,aY-1] <> clBlack) and (aY>11)
//        then RemplirAdjacent(aX,aY-1);
//        if (Form2.Canvas.Pixels[aX+1,aY] <> clBlack) and (aX<Form2.Width-131)
//        then RemplirAdjacent(aX+1,aY);
//        if (Form2.Canvas.Pixels[aX,aY+1] <> clBlack) and (aY<Form2.Height-11)
//        then RemplirAdjacent(aX,aY+1);
//    end;
//end;

procedure RemplissageParLigne(aXSeed,aYSeed,aOldColor,aNewColor: integer);
// Cette procedure permet de transformer un ensemble connexe de couleur aOldColor
// en un nouvel ensemble connexe de couleur aNewColor
var Y: integer;
begin
    // On verifie que l'on appelle pas la procedure pour rien
    if (aOldColor = aNewColor) then Exit;
    // On verifie que le pixel graine est de la couleur qui doit changer
    if (Form2.Canvas.Pixels[aXSeed,aYSeed] <> aOldColor) then Exit;

    // Dessin du segment vertical au dessus du pixel graine (inclus)
    Y := aYSeed;
    while ((Y<Form2.Height) and (Form2.Canvas.Pixels[aXSeed,Y] = aOldColor)) do
        begin
        Form2.Canvas.Pixels[aXSeed,Y] := aNewColor;
        Y := Y+1;
        end;

    // Dessin du segment vertical en dessous du pixel graine (non inclus)
    Y := aYSeed-1;
    while ((Y>=0) and (Form2.Canvas.Pixels[aXSeed,Y] = aOldColor)) do
        begin
        Form2.Canvas.Pixels[aXSeed,Y] := aNewColor;
        Y := Y-1;
        end;

    // Recherche de potentiels segments a gauche et recursivite
    Y := aYSeed;
    while ((Y<Form2.Height) and (Form2.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed>0) and (Form2.Canvas.Pixels[aXSeed-1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed-1, Y, aOldColor, aNewColor);
        Y := Y+1;
        end;
    Y := aYSeed-1;
    while ((Y>=0) and (Form2.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed>0) and (Form2.Canvas.Pixels[aXSeed-1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed-1, Y, aOldColor, aNewColor);
        Y := Y-1;
        end;

    // Recherche de potentiels segments a droite et recursivite
    Y := aYSeed;
    while ((Y<Form2.Height) and (Form2.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed<Form2.Width-1) and (Form2.Canvas.Pixels[aXSeed+1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed+1, Y, aOldColor, aNewColor);
        Y := Y+1;
        end;
    Y := aYSeed-1;
    while ((Y>=0) and (Form2.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed<Form2.Width-1) and (Form2.Canvas.Pixels[aXSeed+1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed+1, Y, aOldColor, aNewColor);
        Y := Y-1;
        end;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if ((DessinEnCours= true) and (X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10)) then
    begin
        Canvas.Pen.Color:=clBlack;
        Canvas.Pen.Width:=2;
        Canvas.LineTo(x,y);
//          TentativeSolide.SetBoolean(X,Y,true);
//          TentativeSolide.SetBoolean(X,Y-1,true);
//          TentativeSolide.SetBoolean(X-1,Y,true);
//          TentativeSolide.SetBoolean(X-1,Y-1,true);
    end;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 2;
    Canvas.LineTo(X0,Y0);
    DessinEnCours := false;
    RemplissageEnCours := true;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
//    TentativeSolide := CForme.create(Form2.width, Form2.height);
    RemplissageEnCours := false;
    DessinEnCours := false;
end;

initialization
  {$I udessinobjet.lrs}

end.

