unit UDessinDecor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    ButRecommencer: TButton;
    ButValider: TButton;
    ButAnnuler: TButton;
    procedure ButAnnulerClick(Sender: TObject);
    procedure ButRecommencerClick(Sender: TObject);
    procedure ButValiderClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3; 

implementation

{ TForm3 }

procedure TForm3.ButRecommencerClick(Sender: TObject);
begin

end;

procedure TForm3.ButAnnulerClick(Sender: TObject);
begin
    Form3.Close();
end;

procedure TForm3.ButValiderClick(Sender: TObject);
begin

end;

initialization
  {$I udessindecor.lrs}

end.

