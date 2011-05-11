unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButRecommencer: TButton;
    ButVoirObjet: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
    procedure ButVoirObjetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure RemplirAdjacent(aX,aY: integer);

var
  Form2: TForm2;
  DessinEnCours, RemplissageEnCours : boolean;
  TentativeSolide : CForme;
  Solide: CForme;
  X0, Y0: integer;

implementation

{ TForm2 }

procedure TForm2.ButAnnulerClick(Sender: TObject);
begin
    Form2.Close();
end;

procedure TForm2.ButRecommencerClick(Sender: TObject);
var i,j: integer;
begin
    Canvas.Clear();
//    for i:=0 to TentativeSolide.getWidth()-1 do
//        begin
//            for j:=0 to TentativeSolide.getHeight()-1 do
//                TentativeSolide.SetBoolean(i, j, false);
//            j := 0;
//        end;
end;

procedure TForm2.ButValiderClick(Sender: TObject);
begin
//    TentativeSolide.RemplirForme();
//    Solide := TentativeSolide;
    Form2.Close();
end;

procedure TForm2.ButVoirObjetClick(Sender: TObject);
var i,j : integer;
begin
//    TentativeSolide.RemplirForme();
//    Canvas.Clear();
//    for i:=0 to TentativeSolide.getWidth()-1 do
 //       begin
//            for j:=0 to TentativeSolide.getHeight()-1 do
//                if TentativeSolide.getBoolean(i, j) = true
//                then Canvas.Pixels[i,j] := clBlack;
//            j := 0;
//        end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
//    TentativeSolide := CForme.create(Form2.width-140, Form2.height-20);  // Les differences servent a avoir la meme taille que le cadre de dessin
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if RemplissageEnCours = false
    then begin
        DessinEnCours := true;
        Canvas.Pen.Color:=clBlack;
        Canvas.Pen.Width:=2;
        if ((X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10))
            then begin
                X0 := X;
                Y0 := Y;
                Canvas.MoveTo(X,Y);
                Canvas.Pixels[X,Y] := clBlack;
//                TentativeSolide.SetBoolean(X,Y,true);
//                TentativeSolide.SetBoolean(X,Y-1,true);
//                TentativeSolide.SetBoolean(X-1,Y,true);
//                TentativeSolide.SetBoolean(X-1,Y-1,true);
            end;
        end
    else begin
        if ((X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10))// and (Canvas.Pixels[X,Y] = clBtnFace))
        then begin
            RemplirAdjacent(X,Y);
            RemplissageEnCours := false;
        end;
    end;
end;

procedure RemplirAdjacent(aX,aY: integer);
begin
    if Form2.Canvas.Pixels[aX,aY] <> clBlack
    then begin
        Form2.Canvas.Pixels[aX,aY] := clBlack;
        if (Form2.Canvas.Pixels[aX-1,aY] <> clBlack) and (aX>11)
        then RemplirAdjacent(aX-1,aY);
        if (Form2.Canvas.Pixels[aX,aY-1] <> clBlack) and (aY>11)
        then RemplirAdjacent(aX,aY-1);
        if (Form2.Canvas.Pixels[aX+1,aY] <> clBlack) and (aX<Form2.Width-131)
        then RemplirAdjacent(aX+1,aY);
        if (Form2.Canvas.Pixels[aX,aY+1] <> clBlack) and (aY<Form2.Height-11)
        then RemplirAdjacent(aX,aY+1);
    end;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if ((DessinEnCours= true) and (X<Form2.Width-130) and (Y<Form2.Height-10) and (X>10) and (Y>10)) then
    begin
        Canvas.Pen.Color:=clBlack;
        Canvas.Pen.Width:=2;
        Canvas.LineTo(x,y);
//          TentativeSolide.SetBoolean(X,Y,true);
//          TentativeSolide.SetBoolean(X,Y-1,true);
//          TentativeSolide.SetBoolean(X-1,Y,true);
//          TentativeSolide.SetBoolean(X-1,Y-1,true);
    end;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 2;
    Canvas.LineTo(X0,Y0);
    DessinEnCours := false;
    RemplissageEnCours := true;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
//    TentativeSolide := CForme.create(Form2.width, Form2.height);
    RemplissageEnCours := false;
    DessinEnCours := false;
end;

initialization
  {$I udessinobjet.lrs}

end.

