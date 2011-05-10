unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, UDessinObjet, UDessinDecor, UParamPhys;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure ButDessinObjetClick(Sender: TObject);
    procedure ButDessinDecorClick(Sender: TObject);
    procedure ButParamClick(Sender: TObject);
    procedure ButQuitterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{ TForm1 }

procedure TForm1.ButDessinDecorClick(Sender: TObject);
begin
     Form2.Show;
end;

procedure TForm1.ButParamClick(Sender: TObject);
begin
     Form4.Show;
end;

procedure TForm1.ButQuitterClick(Sender: TObject);
begin
  Close();
end;

procedure TForm1.ButDessinObjetClick(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

  //We load some decorative image and a predefinite object

end.


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs; 

type
  TForm1 = class(TForm)
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

initialization
  {$I unit1.lrs}

end.

