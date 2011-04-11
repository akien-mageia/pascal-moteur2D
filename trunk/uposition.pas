unit UPosition;

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
    	Constructor Create(aXPix,aYPix,aXmtr,aYmtr);virtual;
    	Destructor  Destroy;override;
    	//Accessors
    	Function GetXPixel():Real;
    	Function GetYPixel():Real;
    	Function GetXMetre():Real;
    	Function GetYMetre():Real;
    	
    	
    	//Others Functions
        Procedure pixelToMetre();
        Procedure metreToPixel();
    end;

implementation

Constructor CPosition.Create(aXPix,aYPix:Real);
	Begin;
	End;

Procedure CPosition.pixelToMetre();
	Begin

	End;

Procedure CPosition.metreToPixel();
	Begin

	End;

end.

