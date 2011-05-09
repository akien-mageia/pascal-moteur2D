//***********************************************//
//       Unite gerant les frottements	         //
//                                               //
//    			TODO : CalculForce, calcul coef  //
//***********************************************//

unit UFrottement;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CFrottement = Class(CTorseur)
	protected
		fCoef: real;	// coefficient de frottement
	
	public
        Constructor Create(aX,aY,aMz,aCoef : Real);
        Destructor Destroy ; override;

		Procedure setCoef(aCoef: real);
		Function  getCoef(): real;
		
		Procedure calculForce(aForme: CForme; aVitesse: CVitesse); override;
		Procedure calculCoef (aForme: CForme);

	end;

implementation

Constructor Cfrottement.Create(aX,aY,aMz,aCoef:Real);
	Begin
		inherited create (aX,aY,aMz);
		SetCoef(aCoef);
	End;

Destructor CFrottement.Destroy;
	Begin
		inherited;
	end;

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
		SetFx( aVitesse.GetX() * fCoef );
		SetFy( aVitesse.GetY() * fCoef );
		
	End;

Procedure CFrottement.calculCoef(aForme: CForme);
	Begin
		fCoef := 0.56;
	End;



end.
