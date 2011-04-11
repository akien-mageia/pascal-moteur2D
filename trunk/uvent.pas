unit UVent;
//***********************************************//
//       Unit that deal with the wind		     //
//                                               //
//    TODO : implementation of CalculForce       //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur, UForme;

type CVent = Class(CTorseur)
	public

		Procedure calculForce(aForme: CForme); override;
	end;

implementation


	
Procedure CVent.calculForce(aForme: CForme); 


	Begin
		
	
		
	End;

end.
