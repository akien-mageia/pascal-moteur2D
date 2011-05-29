unit UPositionSolide;
//******************************************************//
//  Unite permettant d'obtenir la positiondu solide     //
//        	     	                                //
//    		TODO : Nothing                          //
//******************************************************//
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UPosition;

type CPositionSolide = Class(CPosition)
		protected
			fAngle:real;
		public
            Constructor Create(aXPix, aYPix: Integer; aAngle: Real);
			procedure SetAngle( aAngle : Real);
			function  GetAngle	: real;
end;

implementation

Constructor CPositionSolide.Create(aXPix, aYPix: Integer; aAngle: Real);
   begin
        SetXPixel(aXPix);
	SetYPixel(aYPix);
        fAngle := aAngle;
   end;

procedure CPositionSolide.SetAngle( aAngle : real);
	Begin
		fAngle := aAngle;
	end;

Function CPositionSolide.GetAngle : Real;
	Begin
		GetAngle := fAngle;
	end;

end.
