unit UVitesse;

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
		Function getX();
		Function getY();
		Function getOmega();
		Procedure setX(aX);
		Procedure setY(aY);
		Procedure setOmega(aOmega);		
	end;

implementation

Function CVitesse.getX();
Begin
	getX = fX;
End;

Function CVitesse.getY();
Begin
	getY = fY;
End;

Function CVitesse.getOmega();
Begin
	getOmega = fOmega;
End;

Procedure CVitesse.setX(aX);
Begin
	fX := aX;
End;

Procedure CVitesse.setY(aY);
Begin
	fY := aY;
End;

Procedure CVitesse.setOmega(aOmega);
Begin
	fOmega := aOmega;
End;

end.
