unit UPoids;

//***********************************************//
//       Unite gerant la gravite                 //
//                                               //
//    		TODO : Nothing			             //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CPoids = Class(CTorseur)
	protected
		fG: real;		// constante gravitationnelle, valeur par defaut fG = 9.81

	public
		Constructor Create(aX,aY,aMz:Real);
		Destructor Destroy;
		Procedure calculForce(aForme: CForme; aVitesse: CVitesse); override;
		Procedure setG(aG: real);
		Function getG(): real;
	end;

implementation

Constructor CPoids.Create(aX,aY,aMz:Real);
	Begin
		Inherited;
	End;




Destructor CPoids.Destroy;
	Begin
		Inherited;
	End;


Procedure CPoids.calculForce(aForme: CForme; aVitesse: CVitesse);
Begin
    fX := 0;     		// resultante verticale
    fY := aForme.GetMasse()*fG;	// signe positif (l'origine du repere est en haut a gauche)
    fMz := 0;   			// au centre de gravite
End;

Procedure CPoids.setG(aG: real);
Begin
    fG := aG;
End;

Function CPoids.getG(): real;
Begin
    getG := fG;
End;

end.

