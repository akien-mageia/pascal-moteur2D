unit USolideMouvement;
//***********************************************//
//       Unite gerant le mouvement du solide     //
//                                               //
//    TODO : implementation                      //
//***********************************************//

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
     						   aForme  	   : CForme; );
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

end.

