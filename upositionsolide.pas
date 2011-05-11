unit UPositionSolide;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UPosition;

type CPositionSolide = Class(CPosition)
		protected
			fAngle:real;
		public
			procedure SetAngle( aAngle : Real);
			function  GetAngle	: real;
	end;

implementation

procedure CPositionSolide.SetAngle( aAngle : real);
	Begin
		fAngle := aAngle;
	end;

Function CPositionSolide.GetAngle : Real;
	Begin
		GetAngle := fAngle;
	end;

end.
