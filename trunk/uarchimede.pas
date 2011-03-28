unit UArchimede;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme;

type CArchimede = Class(CTorseur)
	protected
		fRho: real;		// masse volumique du fluide
	
	public
		Procedure calculForce(aForme: CForme); override;
		Procedure setRho(aRho: real);
		Function getRho(): real;
	end;

implementation

Procedure CArchimede.calculForce(aForme: CForme);
Begin

End;

Procedure CArchimede.setRho(aRho: real);
Begin
    fRho := aRho;
End;

Function CArchimede.getRho(): real;
Begin
    getRho := fRho;
End;

end.
