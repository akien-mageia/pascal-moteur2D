unit uPopup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm5 }

  TForm5 = class(TForm)
   Label1: TLabel;
   procedure Label1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form5: TForm5;

implementation

{ TForm5 }

procedure TForm5.Label1Click(Sender: TObject);
begin

end;

initialization
  {$I upopup.lrs}

end.

