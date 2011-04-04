unit UTorseur;
//***********************************************//
//       Unite gerant les torseurs de bases      //
//                                               //
//    TODO : implementation                      //
//***********************************************//


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
          Constructor Create(aX,aY,aMz);
          Destructor  Destroy; override;

          Procedure   calculForce(aForme: CForme); virtual; abstract;

    end;

implementation

end.

