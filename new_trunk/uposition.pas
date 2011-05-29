unit UPosition;

//*******************************************************//
//       Unite gerant la position des points du decor    //
//                                                       //
//    	TODO : Modification conversions (1px = 1m        //
//*******************************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type CPosition = Class
    protected
        fXpixel:integer;
        fYpixel:integer;
        fXmetre:real;
        fYmetre:real;

    public
    	Constructor Create(aXPix,aYPix : Integer);
    	Destructor  Destroy;override;

    	//Accessors
    	Function GetXPixel() : Integer;
    	Function GetYPixel() : Integer;
    	Function GetXMetre() : Real;
    	Function GetYMetre() : Real;

    	Procedure SetXPixel(aXPix : Integer);
    	Procedure SetYPixel(aYPix : Integer);
    	Procedure SetXMetre(aXMetre : Real);
    	Procedure SetYMetre(aYMetre : Real);
    	//Others Functions
        Function pixelToMetre(aPos : Integer) : Real;
        Function metreToPixel(aPos : Real) : Integer;
end;

Const TAILLEPIXEL = 0.020; // 1 px = 20 mm, donc 1 m = 50 px (echelle 1:40)
      // Rq: vraie valeur pour un 17": 1 px = 0.54 mm x 0.54 mm

implementation

Constructor CPosition.Create(aXPix,aYPix:Integer);
	//Creation with pixels coordinates
	Begin;
		SetXPixel(aXPix);
		SetYPixel(aYPix);
		//Conversion between pixels&meters is handled by SetXpixel etc
	End;

Destructor CPosition.Destroy;
	Begin
		Inherited;
	End;

//Implementation of accessors
Procedure CPosition.SetXPixel(aXPix : Integer);
	Begin
		fXpixel := aXPix;
		fXmetre := pixelToMetre(aXPix);
	End;

Procedure CPosition.SetYPixel(aYPix : Integer);
	Begin
		fYpixel := aYPix;
		fYmetre := pixelToMetre(aYPix);
	End;

Procedure CPosition.SetXMetre(aXmetre : Real);
	Begin
		fXmetre := aXmetre;
		fXPixel	:= metreToPixel(aXMetre);
	End;

Procedure CPosition.SetYMetre(aYMetre : Real);
	Begin
		fYmetre := aYMetre;
		fYPixel	:= metreToPixel(aYMetre);
	End;

Function Cposition.GetXPixel() : Integer;
	Begin
		GetXPixel := fXPixel;
	End;

Function Cposition.GetYPixel() : Integer;
	Begin
		GetYPixel := fYPixel;
	End;

Function Cposition.GetXMetre() : Real;
	Begin
		GetXMetre := fXMetre;
	End;

Function Cposition.GetYMetre() : Real;
	Begin
		GetYMetre := fYmetre;
	End;

//Conversion Functions Actuellement 1px = 1m
Function Cposition.pixelToMetre(aPos : Integer) : Real;
	Begin
		pixelToMetre := aPos*TAILLEPIXEL;
	End;

Function Cposition.metreToPixel(aPos : Real) : Integer;
	Begin
		metreToPixel := round(aPos/TAILLEPIXEL);
	End;

end.

