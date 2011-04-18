unit UVent;
//***********************************************//
//       Unit that deal with the wind		     //
//                                               //
//    TODO : implementation of CalculForce       //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme, UVitesse;

type CVent = Class(CTorseur)
	public
		Procedure calculForce(aForme: CForme ; aVitesse: CVitesse); override;

	end;

implementation

Procedure CVent.calculForce(aForme: CForme ; aVitesse: CVitesse);
	Begin

		
	End;

end.
