unit UDessinObjet;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, UForme;

type

  { TForm3 }

  TForm3 = class(TForm)
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

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     DessinEnCours := true;
     self.canvas.MoveTo(X,Y);
     Forme.fMat[X][Y] := true;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     if (DessinEnCours= true) then
     begin
          self.canvas.LineTo(x,y);
          Forme.fMat[X][Y]:=true;
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

