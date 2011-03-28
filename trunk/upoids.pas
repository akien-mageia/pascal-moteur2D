unit UPoids;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme;

type CPoids = Class(CTorseur)
	protected
		fG: real;		// constante gravitationnelle, valeur par défaut fg = 9.81
	
	public
		Procedure calculForce(aForme: CForme, aMasse: real);
		Procedure setG(aG: real);
		Function getG();
	end;

implementation

Procedure CPoids.calculForce(aForme: CForme, aMasse: real);
Begin
    fX = 0;     		// résultante verticale
    fY = -aMasse*fG;	// signe négatif (l'origine du repère est en bas à gauche)
    fMz = 0;   			// au centre de gravité
End;

Procedure CPoids.setG(aG: real);
Begin
    fG = aG;
End;

Function CPoids.getG();
Begin
    getG = fG;
End;

end.
