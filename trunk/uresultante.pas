unit UResultante;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur;

Type CResultante = Class (CTorseur)

     Protected
              fTableau : array[1..4] of CTorseur;
              fNbForces : integer;
     end;

implementation

end.

