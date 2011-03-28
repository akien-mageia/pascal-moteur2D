unit UForme;

{$mode objfpc}{$H+}

interface

Type CForme = Class
     Protected
              fMat : array of array of boolean;
              fCentreInertie : Cposition;

     Public
           Procedure CalculCentreInertie;

     end;

uses
  Classes, SysUtils, UPosition;



implementation

Procedure CForme.CalculCentreInertie();
Begin

End;

initialization
  {$I unit1.lrs}

end.

