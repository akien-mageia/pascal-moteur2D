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
           Procedure CalculCentreInertie();

     end;

implementation

Procedure CForme.CalculCentreInertie();
Begin

End;

end.

