unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme, UPopup;

type

  { TForm3 }

  TForm3 = class(TForm)
    butRecommencer: TButton;
    butAnnuler: TButton;
    butValider: TButton;
    butVoirObjet: TButton;
   procedure butAnnulerClick(Sender: TObject);
   procedure butRecommencerClick(Sender: TObject);
   procedure butValiderClick(Sender: TObject);
   procedure butVoirObjetClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
   procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
   procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
   procedure FormShow(Sender: TObject);
   procedure RemplirAdjacent(aX,aY: integer);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3;
  DessinEnCours, RemplissageEnCours : boolean;
  TentativeSolide : CForme;
  Solide: CForme;
  X0, Y0: integer;

implementation

{ TForm3 }

procedure TForm3.butVoirObjetClick(Sender: TObject);
var i,j : integer;
begin
    TentativeSolide.RemplirForme();
    Canvas.Clear();
    for i:=0 to TentativeSolide.getWidth()-1 do
        begin
            for j:=0 to TentativeSolide.getHeight()-1 do
                if TentativeSolide.getBoolean(i, j) = true
                then Canvas.Pixels[i,j] := clBlack;
            j := 0;
        end;

end;

procedure TForm3.FormCreate(Sender: TObject);
begin
    TentativeSolide := CForme.create(Form3.width-140, Form3.height-20);  // Les differences servent a avoir la meme taille que le cadre de dessin
end;

procedure TForm3.butRecommencerClick(Sender: TObject);
var i,j: integer;
begin
    Canvas.Clear();
    for i:=0 to TentativeSolide.getWidth()-1 do
        begin
            for j:=0 to TentativeSolide.getHeight()-1 do
                TentativeSolide.SetBoolean(i, j, false);
            j := 0;
        end;
end;

procedure TForm3.butValiderClick(Sender: TObject);
begin
    TentativeSolide.RemplirForme();
    Solide := TentativeSolide;
    Form3.Close();
end;

procedure TForm3.butAnnulerClick(Sender: TObject);
begin
    Form3.Close();
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if RemplissageEnCours = false
     then begin
        DessinEnCours := true;
        Canvas.Pen.Color:=clBlack;
        Canvas.Pen.Width:=2;
        if ((X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10))
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
        if ((X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10) and (Canvas.Pixels[X,Y] = clWhite))
        then begin
 //           Form5.Close;
            RemplirAdjacent(X,Y);
        end;
     end;

end;

procedure TForm3.RemplirAdjacent(aX,aY: integer);
begin
    Canvas.Pixels[aX,aY] := clBlack;
    if Canvas.Pixels[aX-1,aY] = clWhite
    then RemplirAdjacent(aX-1,aY);
    if Canvas.Pixels[aX,aY-1] = clWhite
    then RemplirAdjacent(aX,aY-1);
    if Canvas.Pixels[aX+1,aY] = clWhite
    then RemplirAdjacent(aX+1,aY);
    if Canvas.Pixels[aX,aY+1] = clWhite
    then RemplirAdjacent(aX,aY+1);
end;


procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
     if ((DessinEnCours= true) and (X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10)) then
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

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 2;
    Canvas.LineTo(X0,Y0);
    DessinEnCours := false;
    RemplissageEnCours := true;
 //   Form5.Show;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
    TentativeSolide := CForme.create(Form3.width, Form3.height);
    RemplissageEnCours := false;
    DessinEnCours := false;
end;

initialization
  {$I udessinobjet.lrs}

end.

