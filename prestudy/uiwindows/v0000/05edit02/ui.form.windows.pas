unit ui.form.windows;

interface

uses   
  uiwin.dc,
  uiwin.wnd;
  
type
  TUIFormWindow = record
    BaseWnd         : TWndUI;
    MemDC           : TWinDC;
  end;
  
implementation

end.
