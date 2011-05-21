unit UForme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UPosition;

Type TBitmapArray = array of TBitmap;

Type CForme = Class
     Protected
              fNbBMP : integer;
              fTableBMP : TBitmapArray;  // cf ci-dessus
              fCentreInertie : CPosition;
              fMasse : real;

     Public
           Constructor Create(aNbBMP, aWidth, aHeight : integer);
           Destructor Destroy; override;
           Procedure calculCentreInertie();
           Function getCentreInertie() : CPosition;
           Function getNbBMP() : integer;
           Procedure setBMP(aIndex: integer; aBMP: TBitmap);
           Function getBMP : TBitmapArray;
           Procedure setMasse(aMasse: Real);
           Function getMasse() : real;


     end;

implementation

Constructor CForme.Create(aNbBMP, aWidth, aHeight : integer);
// Cree la classe et son Bitmap avec hauteur et largeur.
Var i: integer;
Begin
    fNbBMP := aNbBMP;
    setLength(fTableBMP, fNbBMP);
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

Procedure CForme.CalculCentreInertie();
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

end.
