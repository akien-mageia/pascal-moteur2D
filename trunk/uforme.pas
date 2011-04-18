unit UForme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UPosition;

Type CForme = Class
     Protected
              fMat : array of array of boolean;
              fCentreInertie : CPosition;
              fMasse : real;
              fHeight : integer;
              fWidth : integer;

     Public
           Constructor Create(aWidth, aHeight : integer);
           Procedure CalculCentreInertie();
           Procedure SetBoolean(ax, ay : integer; aVal : boolean);
           Function GetMasse() : real;
           Function getHeight() : integer;
           Function getWidth() : integer;
           Procedure RemplirForme();

     end;

implementation

Procedure CForme.CalculCentreInertie();
Begin

End;

Constructor CForme.Create(aWidth, aHeight : integer);
// Cree la classe et entre la largeur et la hauteur du tableau
Var i:integer;
Begin
     fWidth := aWidth;
     fHeight := aHeight;
     fCentreInertie := CPosition.Create(0, 0);
     SetLength (fMat, aWidth);
     For i:= 0 to aWidth-1 do
     SetLength(fMat[i], aHeight);
End;

Procedure CForme.SetBoolean(ax, ay : integer; aVal : boolean);
Begin
     fMat[ax][ay] := aVal;
end;

Function CForme.GetMasse() : real;
Begin
     result := fMasse;
end;

Function CForme.getHeight() : integer;
Begin
     result := fHeight;
end;

Function CForme.getWidth() : integer;
Begin
     result := fWidth;
end;

Procedure CForme.RemplirForme();
Var i, j, k, l : integer;
Begin
     for i:= 0 to fWidth-1
     begin
     k:=0;
     while (CForme.fMat[i][k]=false) and (k<fHeight)
     do k:=k+1;
     l:=fHeight-1;
     while (Forme.fMat[i][l]=false) and (l>=0)
     do l:=l-1;
     if (k<=l) then
     for j:=k to l
     do CForme.fMat[i][j]:=true;
     end;

     for i:= 0 to fHeight-1
     begin
     k:=0;
     while (CForme.fMat[k][i]=false) and (k<fWidth)
     do k:=k+1;
     l:=fWidth-1;
     while (Forme.fMat[l][i]=false) and (l>=0)
     do l:=l-1;
     if (k<=l) then
     for j:=k to l
     do CForme.fMat[j][i]:=true;
     end;

end;

end.

