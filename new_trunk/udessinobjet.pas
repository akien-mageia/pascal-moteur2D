unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme, FPImage, intfGraphics, LCLType;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButRecommencer: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    Img: TImage;
    PanelButtons: TPanel;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    procedure RemplissageParLigne(aXSeed,aYSeed,aOldColor,aNewColor: integer);
    procedure GenererRotationsBMP(aSolide: CForme; aPas: integer);
  end;

var
  Form2: TForm2;
  DessinEnCours, RemplissageEnCours : boolean;
  Solide: CForme;
  X0, Y0: integer;

const PADDING = 30;
// Sert a definir la zone de dessin pour que l'objet tienne dans le BMP de 200x200.
// En effet, pour une rotation du carre 200x200 de 45 deg, la nouvelle hauteur est 200*sqrt(2).
// Il faut donc une zone de dessin de 200/sqrt(2), c'est a dire 140x140.

implementation

{ TForm2 }

procedure TForm2.ButAnnulerClick(Sender: TObject);
begin
    Form2.Close();
end;

procedure TForm2.ButRecommencerClick(Sender: TObject);
begin
    Img.Canvas.Clear();
    //// Remplissage de la zone non dessinable
    //Img.Canvas.Pen.Color := Form2.Canvas.Pixels[0,0];
    //Img.Canvas.Brush.Color := Form2.Canvas.Pixels[0,0];
    //Img.Canvas.Pen.Width := 1;
    //Img.Canvas.Rectangle(0,0,Img.Width,Img.Height);
    //Img.Canvas.Pen.Color := clWhite;
    //Img.Canvas.Brush.Color := clWhite;
    //Img.Canvas.Rectangle(PADDING,PADDING,Img.Width-PADDING,Img.Height-PADDING);
end;

procedure TForm2.ButValiderClick(Sender: TObject);
var SolideBMP : TBitmap;
begin
    // Copie du Bitmap en passant par un fichier BMP.
    Img.Picture.Bitmap.SaveToFile('image/solide-0deg.bmp');
    SolideBMP := TBitmap.Create;
    SolideBMP.PixelFormat := pf24bit;
    SolideBMP.LoadFromFile('image/solide-0deg.bmp');

    // Creation du Solide (CForme) et attribution du BMP
    Solide := CForme.Create(SolideBMP.Width, SolideBMP.Height);
    Solide.setBMP(SolideBMP);
    Solide.calculCentreInertie();

    // Translation du centre d'inertie
    Img.Picture.Bitmap.Canvas.Draw(round(Solide.getBMP.Width/2)-Solide.getCentreInertie.getXPixel,
                                   round(Solide.getBMP.Height/2)-Solide.getCentreInertie.getYPixel,
                                   Solide.getBMP);
    Img.Picture.Bitmap.SaveToFile('image/solide-0deg.bmp');
    SolideBMP.LoadFromFile('image/solide-0deg.bmp');
    Solide.setBMP(SolideBMP);
    Solide.getCentreInertie.setXPixel(round(Solide.getBMP.Width/2));
    Solide.getCentreInertie.setYPixel(round(Solide.getBMP.Height/2));

    // Creation des BMP pour differents angles de rotation
    GenererRotationsBMP(Solide, 18);  // Generer 17 images tournees a partir du BMP
    // 18 est le pas, et l'angle de rotation sera a chaque fois un multiple de 360/pas.

    Form2.Close();
end;

procedure TForm2.GenererRotationsBMP(aSolide: CForme; aPas: integer);
var X0,Y0,X1,Y1,X2,Y2: integer;
    tableauBMP: array of TBitmap;
    angle: real;
    i: integer;
begin
    X0 := aSolide.getCentreInertie.getXPixel();   // decalage d'origine
    Y0 := aSolide.getCentreInertie.getYPixel();

    setLength(tableauBMP, aPas);
    for i:=0 to aPas-1 do begin
        tableauBMP[i] := TBitmap.Create();
        tableauBMP[i].Height := aSolide.getBMP.Height;
        tableauBMP[i].Width := aSolide.getBMP.Width;
        tableauBMP[i].Canvas.Clear();
        tableauBMP[i].Canvas.Clear();   // Pourquoi deux fois, je ne sais pas, mais sinon ca ne marche pas
        end;

    for X1:=0 to aSolide.getBMP.Width-1 do
        for Y1:=0 to aSolide.getBMP.Height-1 do begin
            if aSolide.getBMP.Canvas.Pixels[X1,Y1] = clBlack
            then
                for i:=1 to aPas-1 do begin
                    angle := i*(2*Pi/aPas);  // en radian
                    X2 := round(X0 + cos(angle)*(X1-X0) + sin(angle)*(Y1-Y0));
                    Y2 := round(Y0 - sin(angle)*(X1-X0) + cos(angle)*(Y1-Y0));
                    tableauBMP[i].Canvas.Pixels[X2,Y2] := clBlack;
                    end;
            if aSolide.getBMP.Canvas.Pixels[X1,Y1] = clGray
            then
                for i:=1 to aPas-1 do begin
                    angle := i*(2*Pi/aPas);
                    X2 := round(X0 + cos(angle)*(X1-X0) + sin(angle)*(Y1-Y0));
                    Y2 := round(Y0 - sin(angle)*(X1-X0) + cos(angle)*(Y1-Y0));
                    tableauBMP[i].Canvas.Pixels[X2,Y2] := clGray;
                    end;
            end;

    for i:=1 to aPas-1 do begin
        angle := i*(360/aPas);
        tableauBMP[i].saveToFile('image/solide-'+intToStr(round(angle))+'deg.bmp');
    end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
    // Initialisation des variables booleenes
    RemplissageEnCours := false;
    DessinEnCours := false;
    // Initialisation du canevas
    Img.Canvas.Clear();
    Img.Canvas.Clear();
end;

procedure TForm2.ImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var oldColor: integer;
begin
    if ((X<Img.Width-PADDING-1) and (Y<Img.Height-PADDING-1) and (X>PADDING) and (Y>PADDING))
    then begin
        if RemplissageEnCours = false
        then begin
            DessinEnCours := true;
            Img.Canvas.Pen.Color:=clBlack;
            Img.Canvas.Pen.Width:=2;
            X0 := X;
            Y0 := Y;
            Img.Canvas.MoveTo(X,Y);
            Img.Canvas.Pixels[X,Y] := clBlack;
            end
        else begin
            oldColor := Img.Canvas.Pixels[X,Y];
            RemplissageParLigne(X,Y,oldColor,clGray);
            RemplissageEnCours := false;
        end;
    end;
end;

procedure TForm2.RemplissageParLigne(aXSeed,aYSeed,aOldColor,aNewColor: integer);
// Cette procedure permet de transformer un ensemble connexe de couleur aOldColor
// en un nouvel ensemble connexe de couleur aNewColor
// Adaptee d'une procedure en C sur le Scanline Flood Fill:
// http://www.academictutorials.com/graphics/graphics-flood-fill.asp
var Y: integer;
begin
    // On verifie que l'on appelle pas la procedure pour rien
    if (aOldColor = aNewColor) then Exit;
    // On verifie que le pixel graine est de la couleur qui doit changer
    if (Img.Canvas.Pixels[aXSeed,aYSeed] <> aOldColor) then Exit;

    // Dessin du segment vertical au dessus du pixel graine (inclus)
    Y := aYSeed;
    while ((Y<Img.Height-PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aOldColor)) do
        begin
        Img.Canvas.Pixels[aXSeed,Y] := aNewColor;
        Y := Y+1;
        end;

    // Dessin du segment vertical en dessous du pixel graine (non inclus)
    Y := aYSeed-1;
    while ((Y>=PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aOldColor)) do
        begin
        Img.Canvas.Pixels[aXSeed,Y] := aNewColor;
        Y := Y-1;
        end;

    // Recherche de potentiels segments a gauche et recursivite
    Y := aYSeed;
    while ((Y<Img.Height-PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed>PADDING) and (Img.Canvas.Pixels[aXSeed-1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed-1, Y, aOldColor, aNewColor);
        Y := Y+1;
        end;
    Y := aYSeed-1;
    while ((Y>=PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed>PADDING) and (Img.Canvas.Pixels[aXSeed-1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed-1, Y, aOldColor, aNewColor);
        Y := Y-1;
        end;

    // Recherche de potentiels segments a droite et recursivite
    Y := aYSeed;
    while ((Y<Img.Height-PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed<Img.Width-PADDING-1) and (Img.Canvas.Pixels[aXSeed+1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed+1, Y, aOldColor, aNewColor);
        Y := Y+1;
        end;
    Y := aYSeed-1;
    while ((Y>=PADDING) and (Img.Canvas.Pixels[aXSeed,Y] = aNewColor)) do
        begin
        if ((aXSeed<Img.Width-PADDING-1) and (Img.Canvas.Pixels[aXSeed+1,Y] = aOldColor))
            then RemplissageParLigne(aXSeed+1, Y, aOldColor, aNewColor);
        Y := Y-1;
        end;
end;

procedure TForm2.ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    if ((DessinEnCours= true) and (X<Img.Width-PADDING-1) and (Y<Img.Height-PADDING-1) and (X>PADDING) and (Y>PADDING))
    then begin
        Img.Canvas.Pen.Color:=clBlack;
        Img.Canvas.Pen.Width:=2;
        Img.Canvas.LineTo(x,y);
    end;

end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if (DessinEnCours = true)
    then begin
        Img.Canvas.Pen.Color := clBlack;
        Img.Canvas.Pen.Width := 2;
        Img.Canvas.LineTo(X0,Y0);
        DessinEnCours := false;
        RemplissageEnCours := true;
    end;
end;

initialization
  {$I udessinobjet.lrs}

end.

