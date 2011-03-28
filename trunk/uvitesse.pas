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
		Function getX(): real;
		Function getY(): real;
		Function getOmega(): real;
		Procedure setX(aX: real);
		Procedure setY(aY: real);
		Procedure setOmega(aOmega: real);
	end;

implementation

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
