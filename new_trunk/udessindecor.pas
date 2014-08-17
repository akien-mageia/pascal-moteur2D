unit UDessinDecor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ColorBox, FPImage, intfGraphics, LCLType;

type

  { TForm3 }

  TForm3 = class(TForm)
    ButRecommencer: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    ColorBox1: TColorBox;
    Img: TImage;
    LabelPlastic: TLabel;
    LabelSand: TLabel;
    LabelGrass: TLabel;
    LabelSteel: TLabel;
    LabelStone: TLabel;
    LabelWood: TLabel;
    PanelColors: TPanel;
    PanelButtons: TPanel;
    RGChoixTaille: TRadioGroup;
    ShapeSteel: TShape;
    ShapeSand: TShape;
    ShapeGrass: TShape;
    ShapePlastic: TShape;
    ShapeStone: TShape;
    ShapeWood: TShape;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure RGChoixTailleClick(Sender: TObject);
    procedure ShapeGrassMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapePlasticMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeSandMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeSteelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeStoneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeWoodMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3;
  DessinEnCours: boolean;
  DecorBMP: TBitmap;
{  matGrass, matPlastic, matSand, matSteel, matStone, matWood: CMateriau;
  DecorPositions: array of record
                            fX: integer;
                            fY: integer;
                            fMateriau: CMateriau;
                          end;   }

implementation

{ TForm3 }

procedure TForm3.ButRecommencerClick(Sender: TObject);
begin
    Img.Canvas.Clear();
    // Valeurs par défaut pour le dessin (matériau pierre)
    Img.Canvas.Pen.Color := clGray;
end;

procedure TForm3.ButAnnulerClick(Sender: TObject);
begin
    Form3.Close();
end;

procedure TForm3.ButValiderClick(Sender: TObject);
var i,j,k : integer;
begin
    // Copie du Bitmap en passant par un fichier BMP.
    Img.Picture.Bitmap.SaveToFile('image/decor.bmp');
    DecorBMP := TBitmap.Create;
    DecorBMP.PixelFormat := pf24bit;
    DecorBMP.LoadFromFile('image/decor.bmp');

 {   // Recherche des tuples (X,Y,Materiau) de pixels non blancs
    setLength(DecorPositions, 485*450);     // Surface maximale dessinable
    k := 0;
    for i:=0 to DecorBMP.Canvas.Width-1 do
        for j:=0 to DecorBMP.Canvas.Height-1 do begin
            if DecorBMP.Canvas.Pixels[i,j] <> clWhite
            then begin
                DecorPositions[k].fX := i;
                DecorPositions[k].fY := j;
                case DecorBMP.Canvas.Pixels[i,j] of
                    clGreen: DecorPositions[k].fMateriau := matGrass;
                    clFuchsia: DecorPositions[k].fMateriau := matPlastic;
                    clYellow: DecorPositions[k].fMateriau := matSand;
                    clTeal: DecorPositions[k].fMateriau := matSteel;
                    clGray: DecorPositions[k].fMateriau := matStone;
                    clMaroon: DecorPositions[k].fMateriau := matWood;
                end;
                k := k+1;
            end;
        end;       }

    Form3.Close();
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
{    // Création des différents CMateriau avec des coefficients de restitution arbitraire
    matGrass := CMateriau.Create(clGreen, 0.25);
    matPlastic := CMateriau.Create(clFuchsia, 0.60);
    matSand := CMateriau.Create(clYellow, 0.10);
    matSteel := CMateriau.Create(clTeal, 0.90);
    matStone := CMateriau.Create(clGray, 1.00);
    matWood := CMateriau.Create(clMaroon, 0.70);  }
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    DessinEnCours := false;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
    // Initialisation
    DessinEnCours := false;

    // Valeurs par défaut pour le dessin (matériau pierre)
    Img.Canvas.Pen.Color := clGray;
    Img.Canvas.Pen.Width := 2;
    Img.Canvas.Clear();
    Img.Canvas.Clear();  // Ce n'est pas une erreur, une seule instruction n'est pas suffisante

end;

procedure TForm3.ImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if ((X<Img.Width) and (Y<Img.Height) and (X>0) and (Y>0))
    then begin
        DessinEnCours := true;
        Img.Canvas.MoveTo(X,Y);
        Img.Canvas.Pixels[X,Y] := Canvas.Pen.Color;
        end;
end;

procedure TForm3.ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    if ((DessinEnCours = true) and (X<Img.Width) and (Y<Img.Height) and (X>0) and (Y>0))
    then Img.Canvas.LineTo(x,y);
end;

procedure TForm3.RGChoixTailleClick(Sender: TObject);
begin
     case RGChoixTaille.ItemIndex of
     0 : Img.Canvas.Pen.Width := 2;
     1 : Img.Canvas.Pen.Width := 4;
     2 : Img.Canvas.Pen.Width := 8;
     3 : Img.Canvas.Pen.Width := 16;
     4 : Img.Canvas.Pen.Width := 32;
     end;
end;

procedure TForm3.ShapeGrassMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clGreen;
end;

procedure TForm3.ShapePlasticMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clFuchsia;
end;

procedure TForm3.ShapeSandMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clYellow;
end;

procedure TForm3.ShapeSteelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clTeal;
end;

procedure TForm3.ShapeStoneMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clGray;
end;

procedure TForm3.ShapeWoodMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Img.Canvas.Pen.Color := clMaroon;
end;

initialization
  {$I udessindecor.lrs}

end.

