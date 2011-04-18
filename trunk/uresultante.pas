unit UResultante;
//***********************************************//
//       Unite gerant les résultantes		     //
//                                               //
//    			TODO : All			             //
//***********************************************//

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UTorseur;

Type CResultante = Class (CTorseur)

     Protected
     
			fTableau : array[1..4] of CTorseur;
            fNbForces : integer;
     
     Public
     		Constructor Create();
     		Destructor	Destroy; override;
     		
     		//Accessors
     		Function	GetResultante()  : CTorseur;
     		Function	GetNbForces()	 : Integer;
     		
     		Procedure	SetForce(aForce : CTorseur);
     		Procedure	SetTableau(aNb : Integer;
     								aTableau : array of CTorseur);
     		Procedure	SetResultante(aX,aY,aMz : Real);
     		Procedure	SetNbForces(aNb : Integer);
     		
     		//Others Functions
     		Procedure CalculForce(); 
     
     end;

implementation

Constructor CResultante.Create();
	var i : Integer;
	Begin
		fNbForces := 0;
		for i := 1 to 4 do //Initialisation du tableau à NIL;
			fTableau[i] := NIL;
	End;
	
Destructor CResultante.Destroy;
	var i : Integer;
	Begin
		for i :=1 to fNbForces do //Destruction des objets dynamiques
			fTableau[i].Destroy;
		Inherited; //Destruction du reste
	End;

Function CResultante.GetResultante : CTorseur;
	var Resultat : CTorseur;
	Begin
		Resultat := CTorseur.Create(fX,fY,fMz);
		GetResultante := Resultat;
		Resultat.Destroy;
	end;

Function CResultante.GetNbForces() : Integer;
	Begin
		GetNbForces := fNbForces;
	End;

Procedure CResultante.SetNbForces(aNb : Integer);
	Begin
		fNbForces := aNb;
	End;

Procedure CResultante.SetResultante(aX,aY,aMz : Real);
	Begin
		SetFx(aX);
		SetFy(aY);
		SetMz(aMz);
	End;

Procedure CResultante.SetForce(aForce : CTorseur);
	//Attention si fNbForces >4...
	//AMHA, it gonna do shit
	Begin
		fNbForces := fNbForces + 1;
		fTableau [fNbForces]  := aForce;
		CalculForce;
	End;
Procedure CResultante.SetTableau(aNb : Integer;
								 aTableau : Array of CTorseur);
	Var i : Integer;
	Begin
		fNbForces := aNb;
		for i :=1 to Length(aTableau) do
			fTableau[i] := aTableau[i];
	End;		

Procedure CResultante.CalculForce();
	var i : Integer;
	Begin
		fX := 0; fY := 0; fMz := 0; //Init des valeurs
		for i := 1 to fNbForces do  //Et on ajoute =)
			begin
				fX  := fX + fTableau[i].GetFx;
				fY  := Fy + fTableau[i].GetFy;
				fMz := fMz + fTableau[i].GetMz;
			end;
		
	End;

end.

