unit win.handle;

interface

uses
  Windows;
  
type               
  PWinHandle  = ^TWinHandle;
  TWinHandle  = record
    Value     : THandle;
    // ???? 对任何一个 handle 对象操作 出错的 windows.GetLastError 
    Error     : DWORD;
  end;
  
implementation

end.
