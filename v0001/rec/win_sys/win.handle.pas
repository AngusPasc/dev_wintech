unit win.handle;

interface

uses
  Windows;
  
type               
  PWinHandle  = ^TWinHandle;
  TWinHandle  = record
    Value     : THandle;
    // ???? ���κ�һ�� handle ������� ����� windows.GetLastError 
    Error     : DWORD;
  end;
  
implementation

end.
