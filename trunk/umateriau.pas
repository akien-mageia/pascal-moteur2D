unit UMateriau;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type CMateriau = Class
	protected
		fIndex: integer;
		fCoefChoc: real;
	end;
	
	public
		Constructor Create(aIndex : Integer,
							aCoef : Real);
		
		Destructor	Destroy; override;
		
		//Accessors
		function GetIndex : Integer;
		function GetCoef  : Real;
		procedure SetIndex( aIndex : Integer);
		procedure SetCoef (	aCoef  : Real); 
	
	end;
implementation

Constructor CMateriau.Create(aIndex : Integer,
							 aCoef	: Real);
	Begin
		SetIndex( aIndex );
		SetCoef	(  aCoef );
	End;

Destructor CMateriau.Destroy;
	Begin
		Inherited;
	End;

Function CMateriau.GetIndex() : Integer;
	Begin
		GetIndex := fIndex;
	End;

Function CMateriau.GetCoef()  : Real;
	Begin
		GetCoef := fCoef;
	End;
	
Procedure CMateriau.SetCoef( aCoef : Real);
	Begin
		fCoef := aCoef;
	End;

Procedure CMateriau.SetIndex( aIndex : Integer);
	Begin
		fIndex := aIndex;
	End;

end.
