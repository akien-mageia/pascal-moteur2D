unit UPoids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CPoids = Class(CTorseur)
	protected
		fG: real;		// constante gravitationnelle, valeur par defaut fG = 9.81
	
	public
		Procedure calculForce(aForme: CForme; aVitesse: CVitesse); override;
		Procedure setG(aG: real);
		Function getG(): real;
	end;

implementation

Procedure CPoids.calculForce(aForme: CForme; aVitesse: CVitesse);
Begin
    fX := 0;     		// resultante verticale
    fY := -aForme.GetMasse()*fG;	// signe negatif (l'origine du repere est en bas a gauche)
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
