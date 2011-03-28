unit UVent;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme;

type CVent = Class(CTorseur)
	public
		Procedure calculForce(aForme: CForme);
	end;

implementation

Procedure CVent.calculForce(aForme: CForme);
Begin
	
End;

end.
