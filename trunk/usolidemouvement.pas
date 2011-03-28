unit USolideMouvement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UResultante, UPositionSolide, UVitesse, UForme;

Type CSolideMouvement = Class

     Protected
              fResultante : CResultante;
              fPositionSolide : CPositionSolide ;
              fVitesse : CVitesse ;
              fForme : CForme ;
     end;

implementation

end.

