unit UForme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UPosition;

Type TBitmapArray = array of TBitmap;
     TCoordsArray = array of array [0..3] of integer;

Type CForme = Class
     Protected
              fNbBMP : integer;
              fTableBMP : TBitmapArray;  // cf ci-dessus
              fTableSommets : TCoordsArray;
                // tableau parallele à fTableBMP pour stocker les coordonnées des points extremes de chaque BMP
                // ex : fTableSommets[5][3] sera la coordonnee en X du sommet en bas à droite du carre delimitant la surface dessinee du BMP 5 (tourne de 5*angle deg)
                // Les index finaux 0 à 3 designent :
                //    0: X du point en haut à gauche
                //    1: Y du point en haut à gauche
                //    2: X du point en bas à droite
                //    3: Y du point en bas à droite
                // Interet : la surface a tester est ainsi reduite, optimisation de la detection des collisions
              fCentreInertie : CPosition;
              fMasse : real;
              fVolume : real;
              fJ : real; // moment d'inertie par rapport au centre d'inertie et à l'axe Oz
              fMassePixel : real;

     Public
           Constructor Create(aNbBMP, aWidth, aHeight : integer);
           Destructor Destroy; override;
           Procedure calculInertie();
           Function getCentreInertie() : CPosition;
           Function getNbBMP() : integer;
           Procedure setBMP(aIndex: integer; aBMP: TBitmap);
           Function getBMP : TBitmapArray;
           Procedure setSommets(index, aX0, aY0, aX1, aY1: integer);
           Function getSommets() : TCoordsArray;
           Procedure setMasse(aMasse: Real);
           Function getMasse() : real;
           Function getVolume() : real;
           Function getJ() : real;
           Procedure setJ(aJ : real);
           Procedure calculJ();
           Function getMassePixel() : real;
           Procedure setMassePixel(aMassePixel : real);

     end;

implementation

Constructor CForme.Create(aNbBMP, aWidth, aHeight : integer);
// Cree la classe et son Bitmap avec hauteur et largeur.
Var i: integer;
Begin
    fNbBMP := aNbBMP;
    setLength(fTableBMP, fNbBMP);
    setLength(fTableSommets, fNbBMP);
    for i:=0 to fNbBMP-1 do begin
        fTableBMP[i] := TBitmap.Create;
        fTableBMP[i].Width := aWidth;
        fTableBMP[i].Height := aHeight;
        fTableBMP[i].Canvas.Clear();
    end;
    fCentreInertie := CPosition.Create(0, 0);
End;

Destructor CForme.Destroy;
var i: integer;
Begin
    for i:=0 to fNbBMP-1 do
        fTableBMP[i].Free;
    fCentreInertie.Free;
    Inherited;
end;

Procedure CForme.CalculInertie();
Var i,j,nbPixels,sumX,sumY: integer;
Begin
    nbPixels := 0;
    sumX := 0;
    sumY := 0;
    // Calcul typique de barycentre, X = somme des Xi / nbPixels
    for i:=0 to fTableBMP[0].Width-1 do
        for j:=0 to fTableBMP[0].Height-1 do
            if ((fTableBMP[0].Canvas.Pixels[i,j] = clBlack) or (fTableBMP[0].Canvas.Pixels[i,j] = clGray))
            then begin
                sumX := sumX + i;
                sumY := sumY + j;
                nbPixels := nbPixels + 1;
            end;
    if nbPixels <> 0
    then begin
        fCentreInertie.setXPixel(round(sumX/nbPixels));
        fCentreInertie.setYPixel(round(sumY/nbPixels));
        fMasse := nbPixels*fMassePixel;
        fVolume := nbPixels*TAILLEPIXEL*TAILLEPIXEL*TAILLEPIXEL; // epaisseur TAILLEPIXEL
    end;
End;

Function CForme.getCentreInertie() : CPosition;
Begin
    result := fCentreInertie;
end;

Function CForme.getMasse() : real;
Begin
     result := fMasse;
end;

Procedure CForme.setMasse(aMasse: real);
Begin
     fMasse := aMasse;
end;

Function CForme.getVolume() : real;
Begin
    result := fVolume;
end;

Function CForme.getNbBMP() : integer;
Begin
    result := fNbBMP;
end;

Function CForme.getBMP : TBitmapArray;
begin
    result := fTableBMP;
end;

Procedure CForme.setBMP(aIndex: integer; aBMP: TBitmap);
begin
    fTableBMP[aIndex] := aBMP;
end;

Procedure CForme.setSommets(index, aX0, aY0, aX1, aY1: integer);
begin
    fTableSommets[index][0] := aX0;
    fTableSommets[index][1] := aY0;
    fTableSommets[index][2] := aX1;
    fTableSommets[index][3] := aY1;
end;

Function CForme.getSommets() : TCoordsArray;
begin
    result := fTableSommets;
end;

Function CForme.getJ() : real;
begin
     result := fJ;
end;

Procedure CForme.setJ(aJ : real);
begin
     fJ := aJ;
end;

Procedure CForme.calculJ();
var i,j : integer;
    JProvisoire : real;
begin
    JProvisoire := 0;
    for i:=0 to fTableBMP[0].Width-1 do
        for j:=0 to fTableBMP[0].Height-1 do
            if ((fTableBMP[0].Canvas.Pixels[i,j] = clBlack) or (fTableBMP[0].Canvas.Pixels[i,j] = clGray))
            then JProvisoire := JProvisoire + fMassePixel*((i-fCentreInertie.GetXPixel)*TAILLEPIXEL*(i-fCentreInertie.GetXPixel)*TAILLEPIXEL+(j-fCentreInertie.GetYPixel)*TAILLEPIXEL*(j-fCentreInertie.GetYPixel)*TAILLEPIXEL);
    fJ := JProvisoire;
end;

Function CForme.getMassePixel() : real;
begin
     result := fMassePixel;
end;

Procedure CForme.setMassePixel(aMassePixel : real);
begin
     fMassePixel := aMassePixel;
end;

end.
