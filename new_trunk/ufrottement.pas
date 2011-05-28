unit UFrottement;
//***********************************************//
//       Unite gerant les frottements	         //
//                                               //
//    		TODO : CalculForce, calcul coef  //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse, UPosition;

type CFrottement = Class(CTorseur)
	protected
		fCoef: real;	// coefficient de frottement

	public
                Procedure setCoef(aCoef: real);
		Function  getCoef(): real;

		Procedure calculForce(aForme: CForme; aVitesse: CVitesse); override;

	end;

implementation

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
Procedure CFrottement.calculForce(aForme: CForme; aVitesse: CVitesse);
	//Modifie le torseur du frottement en fonction de la vitesse
        Begin
		fX := -aVitesse.GetX()*fCoef;
		fY := -aVitesse.GetY()*fCoef;
                fMz := 0;
        End;

end.
