unit ui.form.windows;

interface

uses
  Windows,
  uiwin.dc,
  uiwin.wnd;

type
  PUIFormWindow     = ^TUIFormWindow;
  TUIFormWindow     = record
    BaseWnd         : TWndUI;
    MemDC           : TWinDC;
    // this client rect is not wnd client rect
    // but it is internal client rect
    ClientRect      : TRect;
  end;
  
implementation

end.
