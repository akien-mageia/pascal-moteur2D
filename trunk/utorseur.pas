unit UTorseur;
//***********************************************//
//       Unite gerant les torseurs de bases      //
//                                               //
//    			TODO : Nothing	                 //
//***********************************************//


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UForme, UVitesse;

Type CTorseur = Class

    protected
        fX : real;
        fY : real;
        fMz : real;

    public
		Constructor Create(aX,aY,aMz:Real);
        Destructor  Destroy; override;
		//Common Accessors for all childs
		Function 	GetFx() : Real;
		Function 	GetFy() : Real;
		Function 	GetMz() : Real;
		
		Procedure 	SetFx(aX  : Real);
		Procedure	SetFy(aY  : Real);
		Procedure	SetMz(aMz : Real);
		//Other Functions
		Procedure   calculForce(aForme : CForme ; aVitesse: CVitesse); virtual; abstract;

    end;

implementation

Constructor CTorseur.Create(aX, aY, aMz : real);
//Set up the three mains arguments
//For specific uses, we can override this
	Begin
		SetFx(aX);
		SetFy(aY);
		SetMz(aMz);
	End;


Destructor CTorseur.Destroy;
	Begin
		Inherited;
	End;

Function CTorseur.GetFx() : Real;
	Begin
		GetFx := fX;
	End;

Function CTorseur.GetFy() : Real;
	Begin
		GetFy := fY;
	End;

Function CTorseur.GetMz() : Real;
	Begin
		GetMz := fMz;
	End;

Procedure CTorseur.SetFx(aX : Real);
	Begin
		fX := aX;
	End;

Procedure CTorseur.SetFy(aY : Real);
	Begin
		fY := aY;
	End;

Procedure CTorseur.SetMz(aMz : Real);
	Begin
		fMz := aMz;
	end;	

end.
