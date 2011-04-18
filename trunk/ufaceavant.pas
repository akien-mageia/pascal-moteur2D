unit UFaceAvant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, UDessinObjet;

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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;

implementation

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Form3.Show;
end;

initialization
  {$I ufaceavant.lrs}

end.

