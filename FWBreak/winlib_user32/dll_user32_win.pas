{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit dll_user32_win;

interface

uses
  atmcmbaseconst, winconst, wintype, wintypeA;

const
  SW_HIDE           = 0;
  SW_NORMAL         = 1;
  SW_SHOWMINIMIZED  = 2;
  SW_MAXIMIZE       = 3;
  SW_SHOWNOACTIVATE = 4;
  SW_SHOW           = 5;
  SW_MINIMIZE       = 6;
  SW_SHOWMINNOACTIVE= 7;
  SW_SHOWNA         = 8;
  SW_RESTORE        = 9;
  SW_SHOWDEFAULT    = 10;
  SW_MAX            = 10;

  { Old ShowWindow() Commands }
  {$EXTERNALSYM HIDE_WINDOW}
  HIDE_WINDOW       = 0;
  SHOW_OPENWINDOW   = 1;
  SHOW_ICONWINDOW   = 2;
  SHOW_FULLSCREEN   = 3;
  SHOW_OPENNOACTIVATE = 4;

  { Identifiers for the WM_SHOWWINDOW message }
  SW_PARENTCLOSING  = 1;
  SW_OTHERZOOM      = 2;
  SW_PARENTOPENING  = 3;
  SW_OTHERUNZOOM    = 4;
                   
  SWP_NOSIZE = 1;
  SWP_NOMOVE = 2;
  SWP_NOZORDER = 4;
  SWP_NOREDRAW = 8;
  SWP_NOACTIVATE = $10;
  SWP_FRAMECHANGED = $20;    { The frame changed: send WM_NCCALCSIZE }
  SWP_SHOWWINDOW = $40;
  SWP_HIDEWINDOW = $80;
  SWP_NOCOPYBITS = $100;
  SWP_NOOWNERZORDER = $200;  { Don't do owner Z ordering }
  SWP_NOSENDCHANGING = $400;  { Don't send WM_WINDOWPOSCHANGING }
  SWP_DRAWFRAME = SWP_FRAMECHANGED;
  SWP_NOREPOSITION = SWP_NOOWNERZORDER;
  SWP_DEFERERASE = $2000;
  SWP_ASYNCWINDOWPOS = $4000;
                          
  { Window Styles }
  WS_OVERLAPPED = 0;
  WS_POPUP = DWORD($80000000);

  // ����һ���Ӵ��ڡ�������WS_POPUP���һ��ʹ��
  WS_CHILD = $40000000;
  WS_MINIMIZE = $20000000;
  WS_VISIBLE = $10000000;
  WS_DISABLED = $8000000;

  // ������ص��Ӵ��ڣ�����ζ�ţ���һ���ض����Ӵ��ڽ��յ��ػ���Ϣʱ��
  // WS_CLIPSIBLINGS������Ӵ���Ҫ�ػ���������ȥ���������Ӵ����ص��Ĳ��֡�
  // �����û��ָ��WS_CLIPSIBLINGS��񣬲����Ӵ������ص���������һ���Ӵ��ڵĿͻ�����ͼʱ��
  // �����ܻử�����ڵ��Ӵ��ڵĿͻ����С���ֻ��WS_CHILD���һ��ʹ��

  // http://blog.csdn.net/klarclm/article/details/7493126
  // WS_CLIPSIBLINGSʵ���ϻ���Ҫ�Ϳؼ��ĵ���˳��z order�����ʹ��,���ܿ������Ե�Ч��
  WS_CLIPSIBLINGS = $4000000;
  // �ü��ֵܴ���
  // �Ӵ��ڼ��໥�ü���Ҳ����˵�����������໥�ص�ʱ��
  // ������WS_CLIPSIBLINGS��ʽ���Ӵ����ػ�ʱ���ܻ���
  // ���ص��Ĳ��֡���֮û������WS_CLIPSIBLINGS��ʽ��
  // �Ӵ����ػ�ʱ�ǲ������ص����ص���ͳͳ�ػ�
  // �����ڸ������л�ͼʱ����ȥ�Ӵ�����ռ�������ڴ��������ڵ�ʱ��ʹ��

  //** ���������Ժ���Ҫ �������������� ��˸
  WS_CLIPCHILDREN = $2000000;
  // �ü��Ӵ���
  // WS_CLIPCHILDREN��ʽ��Ҫ�����ڸ����ڣ�Ҳ����˵���ڸ����ڻ��Ƶ�ʱ��
  // �������ϻ���һ���Ӵ��ڣ���ô�����������ʽ�Ļ����Ӵ������򸸴��ھͲ��������


  WS_MAXIMIZE = $1000000;
  WS_CAPTION = $C00000;      { WS_BORDER or WS_DLGFRAME  }
  WS_BORDER = $800000;
  WS_DLGFRAME = $400000;
  WS_VSCROLL = $200000;
  WS_HSCROLL = $100000;
  WS_SYSMENU = $80000;
  WS_THICKFRAME = $40000;

  // WS_TABSTOP&WS_GROUP
  WS_GROUP = $20000;
  WS_TABSTOP = $10000;

  WS_MINIMIZEBOX = $20000;
  WS_MAXIMIZEBOX = $10000;

  WS_TILED = WS_OVERLAPPED;
  WS_ICONIC = WS_MINIMIZE;
  WS_SIZEBOX = WS_THICKFRAME;

  { Common Window Styles }
  WS_OVERLAPPEDWINDOW = (WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_THICKFRAME or WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
  WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
  WS_POPUPWINDOW = (WS_POPUP or WS_BORDER or WS_SYSMENU);
  WS_CHILDWINDOW = (WS_CHILD);

  { Extended Window Styles }
  // ����һ����˫�߿�Ĵ��ڣ��ô��ڿ�����
  // dwStyle ��ָ�� WS_CAPTION ���������һ��������
  WS_EX_DLGMODALFRAME = 1;

  // ָ���������񴴽����Ӵ����ڱ�����������ʱ���򸸴��ڷ��� WM_PARENTNOTIFY ��Ϣ
  WS_EX_NOPARENTNOTIFY = 4;

  // ָ���Ը÷�񴴽��Ĵ���Ӧʼ�շ��������з���㴰�ڵ����棬
  // ��ʹ����δ�������ʹ�� SetWindowPos ���������ú���ȥ������
  WS_EX_TOPMOST = 8;
  // �÷��Ĵ��ڿ��Խ���һ����ק�ļ�
  WS_EX_ACCEPTFILES = $10;

  // ָ���������񴴽��Ĵ����ڴ����µ�ͬ���������ػ�ʱ��
  // �ô��ڲſ����ػ����������µ�ͬ�������ѱ��ػ������Ըô�����͸����
  WS_EX_TRANSPARENT = $20;
  
  // ����һ�� MDI �Ӵ���
  WS_EX_MDICHILD = $40;

  // ����һ�����ߴ��ڣ���������һ�������Ĺ����������ߴ��ڵı�������һ�㴰�ڵı������̣�
  // ���Ҵ��ڱ�������С������ʾ�����ߴ��ڲ�������������ʾ�����û����� ALT+TAB ��ʱ����
  // ���ڲ��ڶԻ�������ʾ��������ߴ�����һ��ϵͳ�˵�������ͼ��Ҳ������ʾ�ڱ������
  // ���ǣ�����ͨ���������Ҽ���ʹ�� ALT+SPACE ������ʾ�˵���
  WS_EX_TOOLWINDOW = $80;

  // ָ�����ھ���͹��ı߿�
  WS_EX_WINDOWEDGE = $100;

  // ָ��������һ������Ӱ�ı߽�
  WS_EX_CLIENTEDGE = $200;

  // �ڴ��ڵı���������һ���ʺű�־
  // WS_EX_CONTEXTHELP������WS_MAXIMIZEBOX��WS_MINIMIZEBOXͬʱʹ��
  WS_EX_CONTEXTHELP = $400;

  WS_EX_RIGHT = $1000;
  WS_EX_LEFT = 0;
  WS_EX_RTLREADING = $2000;
  WS_EX_LTRREADING = 0;
  // ����������� Hebrew��Arabic������֧�� reading order alignment �����ԣ�
  // ���������������ڣ��ڿͻ������󲿷֡������������ԣ��÷�񱻺���
  WS_EX_LEFTSCROLLBAR = $4000;
  WS_EX_RIGHTSCROLLBAR = 0;

  // �����û�ʹ�� Tab �����ڴ��ڵ��Ӵ��ڼ�����
  WS_EX_CONTROLPARENT = $10000;
  WS_EX_STATICEDGE = $20000;
  WS_EX_APPWINDOW = $40000; // �����ڿɼ�ʱ����һ�����㴰�ڷ��õ���������
  WS_EX_OVERLAPPEDWINDOW = (WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE);
  WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE or WS_EX_TOOLWINDOW or WS_EX_TOPMOST);

  // Windows 2000/XP������һ���㴰�ڣ�layered window��������ʽ����Ӧ�����Ӵ��ڣ�
  // ���Ҳ�������ӵ��CS_OWNDC �� CS_CLASSDC ���Ĵ���
  WS_EX_LAYERED = $00080000;

  // Windows 2000/XP�� ʹ�ø÷�񴴽��Ĵ��ڲ��Ὣ���ڲ��ִ��ݵ��Ӵ���
  WS_EX_NOINHERITLAYOUT = $00100000; // Disable inheritence of mirroring by children
  // Windows 2000/XP�� ����ˮƽ����ԭ���ڴ����ұ߽磬ˮƽ��������������
  WS_EX_LAYOUTRTL = $00400000; // Right to left mirroring

  // Windows XP��ʹ��˫���������������Ӵ���
  // �����ں��� CS_OWNDC �� CS_CLASSDC ��ʽʱ����ָ������ʽ
  WS_EX_COMPOSITED = $02000000;

  // Windows 2000/XP������ʹ�ø���ʽ������ʼ�������Ĵ��ڣ�
  // ���û�������ʱ���Ὣ����Ϊǰ̨���ڣ��������û������е�ǰ̨������С����ر�ʱ��
  // Ҳ���Ὣ�ô�����Ϊǰ̨���ڡ�Ҫ����ô��ڣ���ʹ�� SetActiveWindow �� SetForegroundWindow ������
  // Ĭ������´��ڲ������������ϳ��֣�Ҫʹ����������������ʾ����ָ�� WS_EX_APPWINDOW ���
  WS_EX_NOACTIVATE = $08000000;

type
  PWindowPlacement = ^TWindowPlacement;
  TWindowPlacement = packed record
    length: UINT;
    flags: UINT;
    showCmd: UINT;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;

  PWindowInfo = ^TWindowInfo;
  TWindowInfo = packed record
    cbSize: DWORD;
    rcWindow: TRect;
    rcClient: TRect;
    dwStyle: DWORD;
    dwExStyle: DWORD;
    dwOtherStuff: DWORD;
    cxWindowBorders: UINT;
    cyWindowBorders: UINT;
    atomWindowType: TAtom;
    wCreatorVersion: WORD;
  end;

  TWNDPROC = function (AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
  
const
  GWL_WNDPROC = -4;
  GWL_HINSTANCE = -6;
  GWL_HWNDPARENT = -8;
  GWL_STYLE = -16;
  GWL_EXSTYLE = -20;
  GWL_USERDATA = -21;
  GWL_ID = -12;

  function GetWindowInfo(AWnd: HWND; var pwi: TWindowInfo): BOOL; stdcall; external user32 name 'GetWindowInfo';

  function SetWindowLongA(AWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint; stdcall; external user32 name 'SetWindowLongA';
  function GetWindowLongA(AWnd: HWND; nIndex: Integer): Longint; stdcall; external user32 name 'GetWindowLongA';

  function IsHungAppWindow(Awnd : HWND): boolean; stdcall; external user32 name 'IsHungAppWindow';

  procedure NotifyWinEvent(event: DWORD; hwnd: HWND; idObject, idChild: Cardinal); stdcall; external user32 name 'NotifyWinEvent';
  function DefWindowProcA(AWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external user32 name 'DefWindowProcA';
  function CallWindowProcA(lpPrevWndFunc: TFNWndProc; AWnd: HWND; Msg: UINT; wParam: WPARAM;
    lParam: LPARAM): LRESULT; stdcall; external user32 name 'CallWindowProcA';
  
  { //uCmd ��ѡֵ:       
  GW_HWNDFIRST = 0;
  GW_HWNDLAST = 1;
  GW_HWNDNEXT = 2;  //ͬ���� Z ��֮��
  GW_HWNDPREV = 3; //ͬ���� Z ��֮��
  GW_OWNER = 4;
  GW_CHILD = 5;
  }
  function GetWindow(AWnd: HWND; uCmd: UINT): HWND; stdcall; external user32 name 'GetWindow';
  // ��ȡָ�����ڵ��Ӵ��������Ĵ��ھ��
  function GetTopWindow(AWnd: HWND): HWND; stdcall; external user32 name 'GetTopWindow';
  function FindWindowA(lpClassName, lpWindowName: PAnsiChar): HWND; stdcall; external user32 name 'FindWindowA';
  function FindWindowExA(AParent, AChild: HWND; AClassName, AWindowName: PAnsiChar): HWND; stdcall; external user32 name 'FindWindowExA';
//  function GetWindowThreadProcessId(AWnd: HWND; var dwProcessId: DWORD): DWORD; stdcall; overload; external user32 name 'GetWindowThreadProcessId';
  function GetWindowThreadProcessId(AWnd: HWND; lpdwProcessId: Pointer): DWORD; stdcall; overload; external user32 name 'GetWindowThreadProcessId';
  
  function ShowWindow(AWnd: HWND; nCmdShow: Integer): BOOL; stdcall; external user32 name 'ShowWindow';
  function UpdateWindow(AWnd: HWND): BOOL; stdcall; external user32 name 'UpdateWindow';
  function ExitWindowsEx(uFlags: UINT; dwReserved: DWORD): BOOL; stdcall; external user32 name 'ExitWindowsEx';
                                
  function CreateWindowExA(dwExStyle: DWORD; lpClassName: PAnsiChar;
    lpWindowName: PAnsiChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
    AWndParent: HWND; AMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external user32 name 'CreateWindowExA';
  function CreateWindowExW(dwExStyle: DWORD; lpClassName: PWideChar;
    lpWindowName: PWideChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
    AWndParent: HWND; AMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external user32 name 'CreateWindowExW';

  function GetDesktopWindow: HWND; stdcall; external user32 name 'GetDesktopWindow';

  function SetParent(AWndChild, AWndNewParent: HWND): HWND; stdcall; external user32 name 'SetParent';
  function SwitchToThisWindow(AWnd: hwnd; fAltTab: boolean): boolean; stdcall; external user32;
  function IsWindow(AWnd: HWND): BOOL; stdcall; external user32 name 'IsWindow';
  function DestroyWindow(AWnd: HWND): BOOL; stdcall; external user32 name 'DestroyWindow';
  function SetPropA(AWnd: HWND; lpStr: PAnsiChar; hData: THandle): BOOL; stdcall; external user32 name 'SetPropA';
  function SetTimer(AWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall; external user32 name 'SetTimer';
  function KillTimer(AWnd: HWND; uIDEvent: UINT): BOOL; stdcall; external user32 name 'KillTimer';

  function InvalidateRect(AWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall; external user32 name 'InvalidateRect';

  {
    Invalidate()��ǿ��ϵͳ�����ػ������ǲ�һ�������Ͻ����ػ�����ΪInvalidate()ֻ��֪ͨϵͳ��
        ��ʱ�Ĵ����Ѿ���Ϊ��Ч��ǿ��ϵͳ����WM_PAINT���������Ϣֻ��Post���ǽ�����Ϣ������Ϣ���С�
        ��ִ�е�WM_PAINT��Ϣʱ�Ż�Գ��ڽ����ػ档
    UpdateWindowֻ���巢��WM_PAINT��Ϣ���ڷ���֮ǰ�ж�GetUpdateRect(hWnd,NULL,TRUE)�����޿ɻ��ƵĿͻ�����
        ���û�У��򲻷���WM_PAINT��
    RedrawWindow()���Ǿ���Invalidate()��UpdateWindow()��˫���ԡ��������ڵ�״̬Ϊ��Ч�����������´��ڣ���������WM_PAINT��Ϣ����

    InvalidateRect(hctrl,null,true) ;
    UpdateWindow(hctrl); �������������������ʲô��˼�أ�
    InvalidateRect�ǻᴥ��WM_PAINT�¼������ǲ��������ʹ�����һ�㶼��ȵ�ǰ�����Ĺ��̽����Ŵ����� �����Ҫ����������
    ��ô���UpdateWindow()ʹ�þͿ����ˡ���ִ��InvalidateRect����ִ��UpdateWindow().
    
    flag ��
      RDW_INVALIDATE or RDW_VALIDATE or RDW_FRAME
      RDW_ERASENOW
      RDW_UPDATENOW 
      RDW_ERASE �ػ�ǰ��������ػ�����ı�����Ҳ����ָ��RDW_INVALIDATE
      RDW_NOERASE  ��ֹɾ���ػ�����ı���
      RDW_NOFRAME  ��ֹ�ǿͻ������ػ�
  }
  function RedrawWindow(AWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall; external user32 name 'RedrawWindow';
  function MessageBoxA(AWnd: HWND; lpText, lpCaption: PAnsiChar; uType: UINT): Integer; stdcall; external user32 name 'MessageBoxA';

(*
    ��ֹ����PrintScreen
    FormCreate
    RegisterHotKey(Handle, IDHOT_SNAPDESKTOP, 0, VK_SNAPSHOT);
    FormClose
    UnregisterHotKey(Handle, IDHOT_SNAPDESKTOP);
    FormActivate
    RegisterHotKey (Handle, IDHOT_SNAPWINDOW, MOD_ALT, VK_SNAPSHOT);
    FormDeactivate
    UnregisterHotKey(Handle, IDHOT_SNAPWINDOW);
*)
const
  IDHOT_SNAPWINDOW = -1;    { SHIFT-PRINTSCRN  }
  IDHOT_SNAPDESKTOP = -2;   { PRINTSCRN        }

  function RegisterHotKey(AWnd: HWND; id: Integer; fsModifiers, vk: UINT): BOOL; stdcall; external user32 name 'RegisterHotKey';
  function UnregisterHotKey(AWnd: HWND; id: Integer): BOOL; stdcall; external user32 name 'UnregisterHotKey';
                                 
  function GetCapture: HWND; stdcall; external user32 name 'GetCapture';
  
  { setCapture������������¼���
       onmousedown��
       onmouseup��
       onmousemove��
       onclick��
       ondblclick��
       onmouseover��
       onmouseout,
       
    SetCapture������ʧȥ��겶��Ĵ��ڽ���һ��WM_CAPTURECHANGED��Ϣ
    �ú��������ڵ�ǰ�̵߳�ָ��������������겶��һ�����ڲ�������꣬
    ����������붼��Ըô��ڣ����۹���Ƿ��ڴ��ڵı߽��ڡ�ͬһʱ��ֻ��
    ��һ�����ڲ�����ꡣ������������һ���̴߳����Ĵ����ϣ�ֻ�е���
    �������ʱϵͳ�Ž��������ָ��ָ���Ĵ���

    �˺������ܱ�����������һ���̵��������

    TSplitter ��Ҫ�����������

    Mouseup ReleaseCapture
  }
  function SetCapture(AWnd: HWND): HWND; stdcall; external user32 name 'SetCapture';
  function ReleaseCapture: BOOL; stdcall; external user32 name 'ReleaseCapture';

  function GetClassInfoA(AInstance: HINST; lpClassName: PAnsiChar; var lpWndClass: TWndClassA): BOOL; stdcall; external user32 name 'GetClassInfoA';
  function GetClassInfoExA(AInstance: HINST; Classname: PAnsiChar; var WndClass: TWndClassExA): BOOL; stdcall; external user32 name 'GetClassInfoExA';
  function GetClassNameA(AWnd: HWND; lpClassName: PAnsiChar; nMaxCount: Integer): Integer; stdcall; external user32 name 'GetClassNameA';
  
const
  { Class styles }
  CS_VREDRAW = DWORD(1);
  CS_HREDRAW = DWORD(2);
  CS_KEYCVTWINDOW = 4;
  CS_DBLCLKS = 8;
  CS_OWNDC = $20;
  CS_CLASSDC = $40;
  CS_PARENTDC = $80;
  CS_NOKEYCVT = $100;

  // �򴰿��ϵĹرհ�ť��ϵͳ�˵��ϵĹر�����ʧЧ
  CS_NOCLOSE = $200;

  // �˵����Ի���������ӵ��CS_SAVEBITS��־��������ʹ�������־ʱ��
  // ϵͳ��λͼ��ʽ����һ�ݱ������ڸǣ������������Ļͼ��
  CS_SAVEBITS = $800;
  CS_BYTEALIGNCLIENT = $1000;
  CS_BYTEALIGNWINDOW = $2000;


  // http://blog.csdn.net/nskevin/article/details/2939857
   
  // windowϵͳ�ṩ���������͵Ĵ�����
  // ϵͳȫ���ࣨSystem global classes��
  // Ӧ�ó���ȫ���ࣨApplication global classes��
  //     CS_GLOBALCLASS
  //     Ӧ�ó���ȫ����ֻ���ڽ����ڲ��ġ�ȫ�֡����ѡ�����ʲô��˼�أ�һ��DLL��.EXE����ע��һ���࣬
  //     ��������������ͬ�Ľ��̿ռ�������.EXE��DLLʹ�á����һ��DLLע����һ����Ӧ�ó���ȫ����Ĵ����࣬
  //     ��ô��ֻ�и�DLL����ʹ�ø��࣬ͬ���ģ�.EXE��ע��ķ�Ӧ�ó���ȫ����Ҳ����������򣬼�����ֻ�ڸ�.EXE����Ч
  //     ��Ϊ������Ե���չ��win32��һ���������һ�����������ڿؼ���DLL��ʵ�֣�Ȼ������DLL����ͳ�ʼ����ÿ��
  //     Win32���̿ռ���������ϸ���ǣ���DLL������д��ע����ָ����ֵ�
  //  HKEY_LOCAL_MACHINE/Software/Microsoft/Windows NT/CurrentVersion/Windows/APPINIT_DLLS
  //  ����������һ��win32Ӧ�ó�����ص�ʱ��ϵͳҲͬʱ����dll���ص����̿ռ��������е�����ݳޣ�
  //  ��Ϊ�ܶ�win32����һ����ʹ�øÿؼ�����DLL�ڳ�ʼ����ʱ��ע��Ӧ�ó���ȫ���࣬�����Ĵ�����Ϳ���
  //  ��ÿ�����̿ռ��.EXE��DLL��ʹ���ˡ������������win32ϵͳ��������ԣ�������ÿ�����̿ռ����Զ���
  //  ��Ҳ��ǿ�Ƶģ������ض���DLL����ʵ�ϣ���Ҳ�Ǵ��ƽ��̱߽磬����Ĵ������뵽�����������һ�ְ취��
  // Ӧ�ó���ֲ��ࣨApplication local classes��

  // windows ����ע���˼���ϵͳȫ���๩ȫ����Ӧ�ó���ʹ�ã���Щ����������µĳ��ñ�׼���ڿؼ�
  // Listbox , ComboBox , ScrollBar , Edit , Button , Static
  // ���е�win32Ӧ�ó��򶼿���ʹ��ϵͳȫ���࣬���������ӻ�ɾ��һ���������� 

  // Ӧ�ó���ֲ�������Ӧ�ó���ע��Ĳ������Լ�ר�õĴ����࣬
  // ����Ӧ�ó������ע��������Ŀ�ľֲ��࣬���������Ӧ�ó���ֻע��һ����
  // ���������֧��Ӧ�ó��������ڵĴ��ڹ��̡�
  // ע��Ӧ�ó���ֲ�����ע��һ��Ӧ�ó���ȫ�����࣬
  // ֻ��WNDCLASSEX�ṹ��style��Աû�����ó�CS_GLOBALCLASS���
  // windowsϵͳ����һ���ֲ�������ע������Ӧ�ó���ر�ʱ��
  // Ӧ�ó���Ҳ���ú���UnregisterClass��ɾ��һ���ֲ��ಢ�ͷ���֮��ص��ڴ�ռ䡣  
  CS_GLOBALCLASS = $4000;

  CS_IME = $10000;
  CS_DROPSHADOW = $20000;

  function RegisterClassA(const lpWndClass: TWndClassA): ATOM; stdcall; external user32 name 'RegisterClassA';
  function RegisterClassExA(const WndClass: TWndClassExA): ATOM; stdcall; external user32 name 'RegisterClassExA';
  function UnregisterClassA(lpClassName: PAnsiChar; hInstance: HINST): BOOL; stdcall; external user32 name 'UnregisterClassA';

  function OpenIcon(AWnd: HWND): BOOL; stdcall; external user32 name 'OpenIcon';
  function CloseWindow(AWnd: HWND): BOOL; stdcall; external user32 name 'CloseWindow';
  function MoveWindow(AWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall; external user32 name 'MoveWindow';

  {
    // hWndInsertAfter: HWND_BOTTOM, HWND_NOTOPMOST, HWND_TOP, HWND_TOPMOST
    // ���ô��� ZOrder
    // SWP_NOACTIVATE
    hWndInsertAfter ��z���е�λ�ڱ���λ�Ĵ���ǰ�Ĵ��ھ��
    hWndInsertAfter ���� hWnd ֮ǰ 
    // SetWindowPos(FHandle, Pos, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
  }
  function SetWindowPos(AWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall; external user32 name 'SetWindowPos';
  function GetWindowPlacement(AWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'GetWindowPlacement';
  function SetWindowPlacement(AWnd: HWND; WindowPlacement: PWindowPlacement): BOOL; stdcall; external user32 name 'SetWindowPlacement';
  function GetWindowModuleFileName(Awnd: HWND; pszFileName: PAnsiChar; cchFileNameMax: UINT): UINT; stdcall; external user32 name 'GetWindowModuleFileNameA';
  function BringWindowToTop(AWnd: HWND): BOOL; stdcall; external user32 name 'BringWindowToTop';
  function IsZoomed(AWnd: HWND): BOOL; stdcall; external user32 name 'IsZoomed';
  function GetClientRect(AWnd: HWND; var lpRect: TRect): BOOL; stdcall; external user32 name 'GetClientRect';
  function GetWindowRect(AWnd: HWND; var lpRect: TRect): BOOL; stdcall; external user32 name 'GetWindowRect';

  function GetUpdateRgn(AWnd: HWND; hRgn: HRGN; bErase: BOOL): Integer; stdcall; external user32 name 'GetUpdateRgn';
  function SetWindowRgn(AWnd: HWND; hRgn: HRGN; bRedraw: BOOL): Integer; stdcall; external user32 name 'SetWindowRgn';
  function GetWindowRgn(AWnd: HWND; hRgn: HRGN): Integer; stdcall; external user32 name 'GetWindowRgn';

  function GetUpdateRect(AWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall; external user32 name 'GetUpdateRect';
  function ExcludeUpdateRgn(ADC: HDC; hWnd: HWND): Integer; stdcall; external user32 name 'ExcludeUpdateRgn';
  
  function WindowFromPoint(APoint: TPoint): HWND; stdcall; external user32 name 'WindowFromPoint';
  function ChildWindowFromPoint(AWndParent: HWND; Point: TPoint): HWND; stdcall; external user32 name 'ChildWindowFromPoint';

  (*
    http://blog.sina.com.cn/s/blog_48f93b530100jonm.html
    ���δ��ڵ�����С
      ������ڰ����ܶ��Ӵ��ڣ������ǵ������ڴ�Сʱ������Ҫͬʱ�����Ӵ��ڵ�λ�úʹ�С��
      ��ʱ��ʹ�� MoveWindow() �� SetWindowPos() �Ⱥ������е�����������Щ������ȴ���
      ˢ����ŷ��أ���˵��д����Ӵ���ʱ��������̿϶���������˸��
      ��ʱ���ǿ���Ӧ�� BeginDeferWindowPos(), DeferWindowPos() �� EndDeferWindowPos()
      ����������������ȵ��� BeginDeferWindowPos()���趨��Ҫ�����Ĵ��ڸ�����Ȼ����
      DeferWindowPos() �ƶ����ڣ����������ƶ����ڣ��������� EndDeferWindowPos()
      һ����������д��ڵĵ���
  *)

type
  HDWP = THandle;
    
  function BeginDeferWindowPos(nNumWindows: Integer): HDWP; stdcall; external user32 name 'BeginDeferWindowPos';
  function DeferWindowPos(AWinPosInfo: HDWP; AWnd: HWND; AWndInsertAfter: HWND;
    x, y, cx, cy: Integer; uFlags: UINT): HDWP; stdcall; external user32 name 'DeferWindowPos';
  function EndDeferWindowPos(AWinPosInfo: HDWP): BOOL; stdcall; external user32 name 'EndDeferWindowPos';

const
  CWP_ALL = 0;
  CWP_SKIPINVISIBLE = 1;
  CWP_SKIPDISABLED = 2;
  CWP_SKIPTRANSPARENT = 4;

  function ChildWindowFromPointEx(AWnd: HWND; Point: TPoint; Flags: UINT): HWND; stdcall; external user32 name 'ChildWindowFromPointEx';
  function IsWindowVisible(AWnd: HWND): BOOL; stdcall; external user32 name 'IsWindowVisible';
  function SetFocus(AWnd: HWND): HWND; stdcall; external user32 name 'SetFocus';
  function GetActiveWindow: HWND; stdcall; external user32 name 'GetActiveWindow';
  function GetFocus: HWND; stdcall; external user32 name 'GetFocus';
  function GetForegroundWindow: HWND; stdcall; external user32 name 'GetForegroundWindow';
  function SetForegroundWindow(AWnd: HWND): BOOL; stdcall; external user32 name 'SetForegroundWindow';

type
  PTrackMouseEvent = ^TTrackMouseEvent;
  TTrackMouseEvent = record
    cbSize: DWORD;
    dwFlags: DWORD;
    hwndTrack: HWND;
    dwHoverTime: DWORD;
  end;

const
  { Key State Masks for Mouse Messages }
  MK_LBUTTON = 1;
  MK_RBUTTON = 2;
  MK_SHIFT = 4;
  MK_CONTROL = 8;
  MK_MBUTTON = $10;

  TME_HOVER           = $00000001;
  TME_LEAVE           = $00000002;
  TME_QUERY           = $40000000;
  TME_CANCEL          = DWORD($80000000);
  HOVER_DEFAULT       = DWORD($FFFFFFFF);

function TrackMouseEvent(var EventTrack: TTrackMouseEvent): BOOL; stdcall; external user32 name 'TrackMouseEvent';
  
implementation

end.
