unit ui.form.windows;

interface

uses
  Windows,
  uiwin.dc,
  uiwin.wnd,
  uictrl.form;

type
  PUIFormWindow     = ^TUIFormWindow;
  TUIFormWindow     = packed record
    BaseWnd         : TWndUI;
    MemDC           : TWinDC;
    // this client rect is not wnd client rect
    // but it is internal client rect
    ClientRect      : TRect;
    Form            : PUIControlForm;
  end;
  
implementation

end.
