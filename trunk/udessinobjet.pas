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
    butQuitter: TButton;
    butValider: TButton;
    butVoirObjet: TButton;
   procedure butRecommencerClick(Sender: TObject);
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
  Forme : CForme;

implementation

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
     Forme := CForme.create(Form3.width, Form3.height);
end;

procedure TForm3.butVoirObjetClick(Sender: TObject);
begin


end;

procedure TForm3.butRecommencerClick(Sender: TObject);
var i,j: integer;
begin
    Canvas.Clear();
    for i:=0 to Forme.getWidth()-1 do
        begin
            for j:=0 to Forme.getHeight()-1 do
                Forme.SetBoolean(i, j, false);
            j := 0;
        end;
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     DessinEnCours := true;
     Canvas.Pen.Color:=clBlack;
     Canvas.Pen.Width:=1;
     if ((X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10))
        then begin
             self.canvas.MoveTo(X,Y);
             Forme.SetBoolean(X,Y,true);
        end;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     if ((DessinEnCours= true) and (X<Form3.Width-130) and (Y<Form3.Height-10) and (X>10) and (Y>10)) then
     begin
          Canvas.Pen.Color:=clBlack;
          Canvas.Pen.Width:=1;
          self.canvas.LineTo(x,y);
          Forme.SetBoolean(X,Y,true);
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

