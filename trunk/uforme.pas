unit UForme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UPosition;

Type CForme = Class
     Protected
              fMat : array of array of boolean;
              fCentreInertie : CPosition;

     Public
           Constructor Create(aWidth, aHeight : integer);
           Procedure CalculCentreInertie();

     end;

implementation

Procedure CForme.CalculCentreInertie();
Begin

End;

Constructor CForme.Create(aWidth, aHeight : integer);
// Cree la classe et entre la largeur et la hauteur du tableau
Var i:integer;
Begin
     fCentreInertie := CPosition.Create;
     SetLength (fMat, aWidth);
     For i:= 0 to aWidth-1 do
     SetLength(fMat[i], aHeight);
End;

end.

