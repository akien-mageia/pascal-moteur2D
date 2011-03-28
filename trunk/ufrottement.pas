unit UFrottement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CFrottement = Class(CTorseur)
	protected
		fCoef: real;	// coefficient de frottement
	
	public
		Procedure calculForce(aForme: CForme, aVitesse: CVitesse);
		Procedure calculCoef(aForme: CForme);
		Procedure setCoef(aCoef: real);
		Function getCoef();
	end;

implementation

Procedure CFrottement.calculForce(aForme: CForme, aVitesse: CVitesse);
Begin

End;

Procedure CFrottement.calculCoef(aForme: CForme);
Begin

End;

Procedure CFrottement.setCoef(aCoef: real);
Begin
    fCoef = aCoef;
End;

Function CFrottement.getCoef();
Begin
    getCoef = fCoef;
End;

end.
