//***********************************************//
//       Unite gerant le mouvement du solide     //
//                                               //
//    TODO : implementation CalculPosition       //
//***********************************************//
unit USolideMouvement;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UResultante, UPositionSolide, UVitesse, UForme;

Type CSolideMouvement = Class

     Protected
     		fResultante : CResultante;
            fPositionSolide : CPositionSolide ;
            fVitesse : CVitesse ;
            fForme : CForme ;
     Public
     		Constructor Create(aResultante : CResultante;
     		                                   aPosition   : CPositionSolide;
     						   aVitesse    : Cvitesse;
     						   aForme      : CForme);

     		Destructor Destroy;override;

     		//Accessors
     		Function GetResultante() 	 : CResultante;
     		Function GetPositionSolide() : CPositionSolide;
     		Function GetVitesse()		 : CVitesse;
     		Function GetForme()			 : CForme;

     		Procedure SetResultante(aResultante : CResultante);
     		Procedure SetPosition(  aPosition 	: CPositionSolide);
     		Procedure SetVitesse(	aVitesse	: CVitesse);
     		Procedure SetForme(		aForme		: CForme);

     		//Others Functions
     		Function CalculPosition() : CPositionSolide;
     end;

implementation

Constructor CSolideMouvement.Create(aResultante : CResultante;
									aPosition	: CpositionSolide;
									aVitesse	: CVitesse;
									aForme		: CForme );
	Begin
		SetResultante(aResultante);
		SetPosition(aPosition);
		SetVitesse(aVitesse);
		SetForme(aForme);
	End;

Destructor CSolideMouvement.Destroy;
	Begin
		fResultante.Destroy;
		fPositionSolide.Destroy;
		fVitesse.Destroy;
		fForme.Destroy;
	End;

Function CSolideMouvement.GetResultante() : CResultante;
	Begin
		GetResultante := fResultante;
	End;

Function CSolideMouvement.GetPositionSolide() : CPositionSolide;
	Begin
		GetPositionSolide := fPositionSolide;
	End;

Function CSolideMouvement.GetVitesse() : CVitesse;
	Begin
		GetVitesse := fVitesse;
	End;

Function CSolideMouvement.GetForme():CForme;
	Begin
		GetForme := fForme;
	End;

Procedure CSolideMouvement.SetResultante(aResultante : CResultante);
	Begin
		fResultante := aResultante;
	End;

Procedure CSolideMouvement.SetPosition(aPosition : CPositionSolide);
	Begin
		fPositionSolide := aPosition;
	End;

Procedure CSolideMouvement.SetVitesse(aVitesse : CVitesse);
	Begin
		fVitesse := aVitesse;
	End;

Procedure CSolideMouvement.SetForme(aForme : CForme);
	Begin
		fForme := aForme;
	End;



Function CSolideMouvement.CalculPosition() : CPositionSolide;
//All the hard stuff is in there
	var resultat : CPositionSolide;

	Begin





	End;


End.


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

implementation

end.
