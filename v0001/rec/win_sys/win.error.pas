unit win.error;

interface

uses
  Windows;
  
type               
  PWinError   = ^TWinError;
  TWinError   = record
    LastError : DWORD;
  end;

var
  GlobalLastError: TWinError = (
    LastError: 0;
  );
    
implementation

end.
