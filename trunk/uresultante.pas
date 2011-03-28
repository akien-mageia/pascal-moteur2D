unit UResultante;

{$mode objfpc}{$H+}

interface

Type CResultante = Class (CTorseur)

     Protected
              fTableau : array[1..4] of CTorseur;
              fNbForces : integer;
     end;

uses
  Classes, SysUtils, UTorseur;

implementation

end.

