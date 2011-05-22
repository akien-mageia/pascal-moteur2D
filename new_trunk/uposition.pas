unit UPosition;

//*******************************************************//
//       Unite gerant la position des points du decor    //
//                                                       //
//    			TODO : Conversions               //
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

//Conversion Functions
Function Cposition.pixelToMetre(aPos : Integer) : Real;
	Begin
		pixelToMetre := aPos*0.00050;   // On prend 1 px = 0.50 mm x 0.50 mm
                // Rq: vraie valeur pour un 17": 1 px = 54 mm x 54 mm
	End;

Function Cposition.metreToPixel(aPos : Real) : Integer;
	Begin
		metreToPixel := round(aPos*2000);   // 1 m = 2000 px
	End;

end.
