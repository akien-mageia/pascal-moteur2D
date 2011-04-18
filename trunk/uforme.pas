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

end.

