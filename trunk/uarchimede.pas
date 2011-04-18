unit UArchimede;
//***********************************************//
//       Unite gerant la poussée d'Archimede     //
//                                               //
//    			TODO : CalculForce               //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CArchimede = Class(CTorseur)
	protected
		fRho: real;		// volumic weight of fluid
	
	public
		Procedure calculForce(aForme: CForme ; aVitesse: CVitesse); override;
		Procedure setRho(aRho: real);
		Function getRho(): real;
	end;

implementation

Procedure CArchimede.CalculForce(aForme: CForme ; aVitesse: CVitesse);
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
