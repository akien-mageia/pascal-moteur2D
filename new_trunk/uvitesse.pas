unit UVitesse;
//***********************************************//
//   Unite définissant un torseur des vitesses	 //
//                                               //
//    	        TODO : Nothing	                 //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type CVitesse = Class
	protected
		fX: real;
		fY: real;
		fOmega: real;

	public

		Constructor Create(aX,aY,aOmega:Real);
		Destructor Destroy; Override;

		Function getX(): real;
		Function getY(): real;
		Function getOmega(): real;
		Procedure setX(aX: real);
		Procedure setY(aY: real);
		Procedure setOmega(aOmega: real);
	end;

implementation

Constructor CVitesse.Create(aX,aY,aOmega : Real);
//Create the Cvitesse Object using provided arguments
	Begin
		setX(aX);
		setY(aY);
		setOmega(aOmega);
	End;

Destructor CVitesse.Destroy;
//No dynamic objects, no need to specific destructor
	Begin
		Inherited;
	End;


//All the accessors
Function CVitesse.getX(): real;
	Begin
		getX := fX;
	End;

Function CVitesse.getY(): real;
	Begin
		getY := fY;
	End;

Function CVitesse.getOmega(): real;
	Begin
		getOmega := fOmega;
	End;

//All the Sets procedures
Procedure CVitesse.setX(aX: real);
	Begin
		fX := aX;
	End;

Procedure CVitesse.setY(aY: real);
	Begin
		fY := aY;
	End;

Procedure CVitesse.setOmega(aOmega: real);
	Begin
		fOmega := aOmega;
	End;

end.
