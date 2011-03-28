unit UTorseur;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UForme;

Type CTorseur = Class

    protected
        fX : real;
        fY : real;
        fMz : real;

    public
        Procedure calculForce(aForme: CForme); virtual; abstract;

    end;

implementation

end.

