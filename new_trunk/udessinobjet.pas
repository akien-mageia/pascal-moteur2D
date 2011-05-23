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
    procedure GenererRotationsBMP(aSolide: CForme);
    procedure GenererTableauSommets(aIndex: integer; aSolide: CForme);
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
    i: integer;
begin
    // Copie du Bitmap en passant par un fichier BMP.
    Img.Picture.Bitmap.SaveToFile('image/solide-0deg.bmp');
    SolideBMP := TBitmap.Create;
    SolideBMP.PixelFormat := pf24bit;
    SolideBMP.LoadFromFile('image/solide-0deg.bmp');

    // Creation du Solide (CForme) et attribution du BMP
    Solide := CForme.Create(18, SolideBMP.Width, SolideBMP.Height);
    // 18 est le pas, et l'angle de rotation sera a chaque fois un multiple de 360/pas.
    Solide.setBMP(0, SolideBMP);
    Solide.calculCentreInertie();

    // Translation du centre d'inertie
    Img.Picture.Bitmap.Canvas.Draw(round(Solide.getBMP[0].Width/2)-Solide.getCentreInertie.getXPixel,
                                   round(Solide.getBMP[0].Height/2)-Solide.getCentreInertie.getYPixel,
                                   Solide.getBMP[0]);
    Img.Picture.Bitmap.SaveToFile('image/solide-0deg.bmp');
    Solide.getBMP[0].LoadFromFile('image/solide-0deg.bmp');
    Solide.getCentreInertie.setXPixel(round(Solide.getBMP[0].Width/2));
    Solide.getCentreInertie.setYPixel(round(Solide.getBMP[0].Height/2));
    GenererTableauSommets(0, Solide);    // Generer la premiere entree du fTableSommets (image non tournee)

    // Creation des BMP pour differents angles de rotation
    GenererRotationsBMP(Solide);  // Generer les images tournees a partir du BMP

    Solide.getBMP[0].Transparent := True;
    Solide.getBMP[0].TransparentColor := Solide.getBMP[0].Canvas.Pixels[0,0];
    for i:=1 to Solide.getNbBMP-1 do begin
        Solide.getBMP[i].LoadFromFile('image/solide-'+intToStr(i*round(360/Solide.getNbBMP))+'deg.bmp');
        Solide.getBMP[i].Transparent := True;
        Solide.getBMP[i].TransparentColor := Solide.getBMP[0].Canvas.Pixels[0,0];
        GenererTableauSommets(i, Solide);   // Generer le fTableSommets a partir des images tournees
    end;

    Form2.Close();
end;

procedure TForm2.GenererRotationsBMP(aSolide: CForme);
var X0,Y0,X1,Y1,X2,Y2: integer;
    tableauBMP: array of TBitmap;
    angle: real;
    i: integer;
begin
    X0 := aSolide.getCentreInertie.getXPixel();   // decalage d'origine
    Y0 := aSolide.getCentreInertie.getYPixel();

    setLength(tableauBMP, aSolide.getNbBMP);
    for i:=0 to aSolide.getNbBMP-1 do begin
        tableauBMP[i] := TBitmap.Create();
        tableauBMP[i].Height := aSolide.getBMP[0].Height;
        tableauBMP[i].Width := aSolide.getBMP[0].Width;
        tableauBMP[i].Canvas.Clear();
        tableauBMP[i].Canvas.Clear();   // Pourquoi deux fois, je ne sais pas, mais sinon ca ne marche pas
        end;

    for X1:=0 to aSolide.getBMP[0].Width-1 do
        for Y1:=0 to aSolide.getBMP[0].Height-1 do begin
            if aSolide.getBMP[0].Canvas.Pixels[X1,Y1] = clBlack
            then
                for i:=1 to aSolide.getNbBMP-1 do begin
                    angle := i*(2*Pi/aSolide.getNbBMP);  // en radian
                    X2 := round(X0 + cos(angle)*(X1-X0) + sin(angle)*(Y1-Y0));
                    Y2 := round(Y0 - sin(angle)*(X1-X0) + cos(angle)*(Y1-Y0));
                    tableauBMP[i].Canvas.Pixels[X2,Y2] := clBlack;
                    end;
            if aSolide.getBMP[0].Canvas.Pixels[X1,Y1] = clGray
            then
                for i:=1 to aSolide.getNbBMP-1 do begin
                    angle := i*(2*Pi/aSolide.getNbBMP);
                    X2 := round(X0 + cos(angle)*(X1-X0) + sin(angle)*(Y1-Y0));
                    Y2 := round(Y0 - sin(angle)*(X1-X0) + cos(angle)*(Y1-Y0));
                    tableauBMP[i].Canvas.Pixels[X2,Y2] := clGray;
                    end;
            end;

    for i:=1 to aSolide.getNbBMP-1 do begin
        angle := i*(360/aSolide.getNbBMP);
        tableauBMP[i].saveToFile('image/solide-'+intToStr(round(angle))+'deg.bmp');
    end;
end;

procedure TForm2.GenererTableauSommets(aIndex: integer; aSolide: CForme);
var i, j, X0, Y0, X1, Y1: integer;
    X0trouve, Y0trouve, X1trouve, Y1trouve: boolean;
begin
    X0trouve := false;
    Y0trouve := false;
    X1trouve := false;
    Y1trouve := false;

    i := 0;
    j := 0;

    while (i<aSolide.getBMP[aIndex].Width-1) and (X0trouve = false) do begin
        while (j<aSolide.getBMP[aIndex].Height-1) and (X0trouve = false) do
            if aSolide.getBMP[aIndex].Canvas.Pixels[i,j] <> clWhite
            then begin
                X0trouve := true;
                X0 := i;
                end
            else j := j+1;
        j := 0;
        i := i+1;
        end;

    i := aSolide.getBMP[aIndex].Width-1;
    while (i>0) and (X1trouve = false) do begin
        while (j<aSolide.getBMP[aIndex].Height-1) and (X1trouve = false) do
            if aSolide.getBMP[aIndex].Canvas.Pixels[i,j] <> clWhite
            then begin
                X1trouve := true;
                X1 := i;
                end
            else j := j+1;
        j := 0;
        i := i-1;
        end;

    i := 0;
    while (j<aSolide.getBMP[aIndex].Height-1) and (Y0trouve = false) do begin
        while (i<aSolide.getBMP[aIndex].Width-1) and (Y0trouve = false) do
            if aSolide.getBMP[aIndex].Canvas.Pixels[i,j] <> clWhite
            then begin
                Y0trouve := true;
                Y0 := j;
                end
            else i := i+1;
        i := 0;
        j := j+1;
        end;

    j := aSolide.getBMP[aIndex].Height-1;
    while (j>0) and (Y1trouve = false) do begin
        while (i<aSolide.getBMP[aIndex].Width-1) and (Y1trouve = false) do
            if aSolide.getBMP[aIndex].Canvas.Pixels[i,j] <> clWhite
            then begin
                Y1trouve := true;
                Y1 := j;
                end
            else i := i+1;
        i := 0;
        j := j-1;
        end;

    aSolide.setSommets(aIndex, X0, Y0, X1, Y1);
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

