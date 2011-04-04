unit UFrottement;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CFrottement = Class(CTorseur)
	protected
		fCoef: real;	// coefficient de frottement
	
	public
                Constructor Create(aCoef : Real); override;
                Destructor Destroy ; override;
		Procedure calculForce(aForme: CForme; aVitesse: CVitesse); override;
		Procedure calculCoef(aForme: CForme);
		Procedure setCoef(aCoef: real);
		Function getCoef(): real;
	end;

implementation

Constructor Cfrottement.Create(aCoef:Real);
Begin
     SetCoef(aCoef);
End;
 
Destructor Destroy; Override;

Begin
     inherited;
end;

Procedure CFrottement.calculForce(aForme: CForme; aVitesse: CVitesse);
Begin

End;

Procedure CFrottement.calculCoef(aForme: CForme);
Begin

End;

Procedure CFrottement.setCoef(aCoef: real);
//Permet d'assigner le coeff
Begin
    fCoef := aCoef;
End;

Function CFrottement.getCoef(): real;
//Retourne le coefficient de frottement du solide considere

Begin
    getCoef := fCoef;
End;

end.
