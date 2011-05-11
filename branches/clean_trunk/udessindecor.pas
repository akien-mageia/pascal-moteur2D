unit UDessinDecor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ColorBox;

type

  { TForm3 }

  TForm3 = class(TForm)
    ButRecommencer: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    ColorBox1: TColorBox;
    LabelPlastic: TLabel;
    LabelSand: TLabel;
    LabelGrass: TLabel;
    LabelSteel: TLabel;
    LabelStone: TLabel;
    LabelWood: TLabel;
    PanelColors: TPanel;
    PanelButtons: TPanel;
    ShapeSteel: TShape;
    ShapeSand: TShape;
    ShapeGrass: TShape;
    ShapePlastic: TShape;
    ShapeStone: TShape;
    ShapeWood: TShape;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
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
  DessinEnCours, DejaActive: boolean;

const
  XPADDING = 25;         // marge autour du cadre de dessin suivant X
  YPADDING = 25;         // marge autour du cadre de dessin suivant Y

implementation

{ TForm3 }

procedure TForm3.ButRecommencerClick(Sender: TObject);
begin
    Canvas.Clear();
    // Dessin d'un cadre fin autour de la zone de dessin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Rectangle(XPADDING, YPADDING, Form3.Width-PanelButtons.Width-2*XPADDING, Form3.Height-YPADDING);
    // Valeurs par défaut pour le dessin (matériau pierre)
    Canvas.Pen.Color := clGray;
    Canvas.Pen.Width := 2;
end;

procedure TForm3.ButAnnulerClick(Sender: TObject);
begin
    Form3.Close();
end;

procedure TForm3.ButValiderClick(Sender: TObject);
begin

end;

procedure TForm3.FormActivate(Sender: TObject);
begin

end;

procedure TForm3.FormCreate(Sender: TObject);
begin
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if ((X<Form3.Width-2*XPADDING-PanelButtons.Width) and (Y<Form3.Height) and (X>XPADDING) and (Y>YPADDING))
    // pour X: marge avant le Panel, taille du Panel, marge après le Panel
    then begin
        DessinEnCours := true;
        Canvas.MoveTo(X,Y);
        Canvas.Pixels[X,Y] := Canvas.Pen.Color;
        end;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    // A-t-on deja ouvert ce Form? Ruse pour contrer la creation tardive du Canvas
    if DejaActive = false
    then begin
        DejaActive := true;
        // Dessin d'un cadre fin autour de la zone de dessin
        Canvas.Pen.Color := clBlack;
        Canvas.Pen.Width := 1;
        Canvas.Rectangle(XPADDING, YPADDING, Form3.Width-PanelButtons.Width-2*XPADDING, Form3.Height-YPADDING);
        // Valeurs par defaut pour le dessin (materiau pierre)
        Canvas.Pen.Color := clGray;
        Canvas.Pen.Width := 2;
        end;

    if ((DessinEnCours = true) and (X<Form3.Width-2*XPADDING-PanelButtons.Width) and (Y<Form3.Height-YPADDING) and (X>XPADDING) and (Y>YPADDING))
    // pour X: marge avant le Panel, taille du Panel, marge après le Panel
    then Canvas.LineTo(x,y);
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    DessinEnCours := false;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
    DessinEnCours := false;
    DejaActive := false;
end;

procedure TForm3.ShapeGrassMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clGreen;
end;

procedure TForm3.ShapePlasticMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clFuchsia;
end;

procedure TForm3.ShapeSandMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clYellow;
end;

procedure TForm3.ShapeSteelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clTeal;
end;

procedure TForm3.ShapeStoneMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clGray;
end;

procedure TForm3.ShapeWoodMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clMaroon;
end;

initialization
  {$I udessindecor.lrs}

end.

