unit USolideMouvement;

{$mode objfpc}{$H+}

interface

Type CSolideMouvement = Class

     Protected
              fResultante : CResultante ;
              fPositionSolide : CPositionSolide ;
              fVitesse : CVitesse ;
              fForme : CForme ;
     end;

uses
  Classes, SysUtils, UResultante, UPositionSolide, UVitesse, UForme;

implementation

end.

