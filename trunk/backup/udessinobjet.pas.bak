unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme;

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
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3;
  DessinEnCours : boolean;
  TentativeSolide : CForme;
  Solide: CForme;

implementation

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
    TentativeSolide := CForme.create(Form3.width, Form3.height);
end;

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
    TentativeSolide.Free();
    Form3.Close();
end;

procedure TForm3.butAnnulerClick(Sender: TObject);
begin
    Form3.Close();
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     DessinEnCours := true;
     Canvas.Pen.Color:=clBlack;
     Canvas.Pen.Width:=2;
     if ((X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10))
        then begin
             Canvas.MoveTo(X,Y);
             Canvas.Pixels[X,Y] := clBlack;
             TentativeSolide.SetBoolean(X,Y,true);
             TentativeSolide.SetBoolean(X,Y-1,true);
             TentativeSolide.SetBoolean(X-1,Y,true);
             TentativeSolide.SetBoolean(X-1,Y-1,true);
        end;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     if ((DessinEnCours= true) and (X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10)) then
     begin
          Canvas.Pen.Color:=clBlack;
          Canvas.Pen.Width:=2;
          Canvas.LineTo(x,y);
          TentativeSolide.SetBoolean(X,Y,true);
          TentativeSolide.SetBoolean(X,Y-1,true);
          TentativeSolide.SetBoolean(X-1,Y,true);
          TentativeSolide.SetBoolean(X-1,Y-1,true);
     end;
end;

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     DessinEnCours := false;
end;

initialization
  {$I udessinobjet.lrs}

end.

