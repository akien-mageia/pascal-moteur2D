unit UPosition;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type CPosition = Class
    protected
        fXpixel:integer;
        fYpixel:integer;
        fXmetre:real;
        fYmetre:real;

    public
        Procedure pixelToMetre();
        Procedure metreToPixel();
    end;

implementation

Procedure CPosition.pixelToMetre();
Begin

End;

Procedure CPosition.metreToPixel();
Begin

End;

end.

