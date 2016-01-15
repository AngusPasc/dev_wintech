{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit winconst_msg;

interface
                           
{ Window Messages }
const
  WM_NULL             = $0000;
  WM_CREATE           = $0001;
  WM_DESTROY          = $0002;
  WM_MOVE             = $0003;
  WM_SIZE             = $0005;

  // һ�����ڱ������ʧȥ����״̬
  // If an application processes this message, it should return zero
  // http://msdn.microsoft.com/en-us/library/ms646274(VS.85).aspx
  WM_ACTIVATE         = $0006;
  { WM_ACTIVATE state values }
    WA_INACTIVE = 0;
    WA_ACTIVE = 1;
    WA_CLICKACTIVE = 2;


  WM_SETFOCUS         = $0007;

  // An application should return zero if it processes this message.
  // http://msdn.microsoft.com/en-us/library/ms646282(v=VS.85).aspx
  WM_KILLFOCUS        = $0008;
  
  WM_ENABLE           = $000A;
  // ���ô����Ƿ����ػ� ??
  WM_SETREDRAW        = $000B;
  WM_SETTEXT          = $000C;
  WM_GETTEXT          = $000D;
  WM_GETTEXTLENGTH    = $000E;
  WM_PAINT            = $000F;
//WM_DESTROY �ǹرճ����
//WM_CLOSE �ǹرմ��ڵ�
//WM_QUIT �ǹر���Ϣ����  
  WM_CLOSE            = $0010;
  // WM_QUERYENDSESSION return 0;
  //�˴�����0���ܹػ�������1���ܹػ�
  // ExitWindowsEx(EWX_POWEROFF|EWX_FORCE,0); ǿ�ƹػ�
  // ����ExitWindowsEx��ϵͳ���ᷢ��WM_QUERYENDSESSION��Ϣ
  WM_QUERYENDSESSION  = $0011;

  //���������������л򵱳������postquitmessage����
  WM_QUIT             = $0012;

  //���û����ڻָ���ǰ�Ĵ�Сλ��ʱ���Ѵ���Ϣ���͸�ĳ��ͼ��
  WM_QUERYOPEN        = $0013;

  //�����ڱ������뱻����ʱ�����ڴ��ڸı��Сʱ��
  // WM_ERASEBKGND��Ϣ�ĺ���һ����WM_PAINT
  WM_ERASEBKGND       = $0014;

  //��ϵͳ��ɫ�ı�ʱ�����ʹ���Ϣ�����ж�������
  WM_SYSCOLORCHANGE   = $0015;
  WM_ENDSESSION       = $0016;
  WM_SYSTEMERROR      = $0017;
  WM_SHOWWINDOW       = $0018;
  WM_CTLCOLOR         = $0019;
  WM_WININICHANGE     = $001A;
  WM_SETTINGCHANGE = WM_WININICHANGE;
  WM_DEVMODECHANGE    = $001B;

  //������Ϣ��Ӧ�ó����ĸ������Ǽ���ģ��ĸ��ǷǼ����
  // http://msdn.microsoft.com/en-us/library/ms632614(VS.85).aspx
  // If an application processes this message, it should return zero
  WM_ACTIVATEAPP      = $001C;
  WM_FONTCHANGE       = $001D;

  //��ϵͳ��ʱ��仯ʱ���ʹ���Ϣ�����ж�������
  WM_TIMECHANGE       = $001E;

  //���ʹ���Ϣ��ȡ��ĳ�����ڽ��е���̬��������
  // http://www.cnblogs.com/del/archive/2008/10/29/1322205.html
  WM_CANCELMODE       = $001F;

  //��������������ĳ���������ƶ�
  //���������û�б�����ʱ���ͷ���Ϣ��ĳ������
  (*����ƶ�OnMouseMOve�ͻ��Զ����� WM_SETCURSOR�Ӷ�����OnSetCursor���������Ƹı����ָ��ĳ���ʱ��
    һ�㲻Ҫ��OnMouseMOve�¼��е���SetCursor����������ָ����˸���������ָ����״����ķ����ǣ�
    ��OnMouseMove��ʹ��һ��������ס������crect�е������״��Ȼ����OnSetCursor����SetCursor�������*)
  WM_SETCURSOR        = $0020;

  //�������ĳ���Ǽ���Ĵ����ж��û����������
  //��ĳ�������ʹ���Ϣ����ǰ����
  WM_MOUSEACTIVATE    = $0021;    
    MA_ACTIVATE = 1; // ����壬����ɾ�������Ϣ
    MA_ACTIVATEANDEAT = 2; // ������壬Ҳ��ɾ�������Ϣ
    MA_NOACTIVATE = 3; // ����壬ɾ�������Ϣ
    MA_NOACTIVATEANDEAT = 4; // ������壬��ɾ�������Ϣ
  WM_CHILDACTIVATE    = $0022;

  //����Ϣ�ɻ��ڼ������ѵ�������ͣ�
  //ͨ��WH_JOURNALPALYBACK��hook���������û�������Ϣ
  WM_QUEUESYNC        = $0023;

  //����Ϣ���͸����ڵ�����Ҫ�ı��С��λ��
  WM_GETMINMAXINFO    = $0024;

  //���͸���С�����ڵ���ͼ�꽫Ҫ���ػ�
  WM_PAINTICON        = $0026;

  //����Ϣ���͸�ĳ����С�����ڣ��������ڻ�ͼ��ǰ���ı������뱻�ػ�
  WM_ICONERASEBKGND   = $0027;

  //���ʹ���Ϣ��һ���Ի������ȥ���Ľ���λ��
  WM_NEXTDLGCTL       = $0028;
  
  //ÿ����ӡ�����ж����ӻ����һ����ҵʱ��������Ϣ
  WM_SPOOLERSTATUS    = $002A;

  //��button��combobox��listbox��menu�Ŀ�����۸ı�ʱ����
  //����Ϣ����Щ�ռ���������
  WM_DRAWITEM         = $002B;
  WM_MEASUREITEM      = $002C;
  WM_DELETEITEM       = $002D;
  WM_VKEYTOITEM       = $002E;
  WM_CHARTOITEM       = $002F;
  WM_SETFONT          = $0030;
  WM_GETFONT          = $0031;

  //Ӧ�ó����ʹ���Ϣ��һ��������һ���ȼ������
  WM_SETHOTKEY        = $0032;
  //Ӧ�ó����ʹ���Ϣ���ж��ȼ���ĳ�������Ƿ��й���
  WM_GETHOTKEY        = $0033;

  //����Ϣ���͸���С�����ڣ����˴��ڽ�Ҫ���ϷŶ�����
  //����û�ж���ͼ�꣬Ӧ�ó����ܷ���һ��ͼ�����ľ����
  //���û��Ϸ�ͼ��ʱϵͳ��ʾ���ͼ�����
  WM_QUERYDRAGICON    = $0037;
  WM_COMPAREITEM      = $0039;
  WM_GETOBJECT        = $003D;

  //��ʾ�ڴ��Ѿ�������
  WM_COMPACTING       = $0041;

  WM_COMMNOTIFY       = $0044;    { obsolete in Win32}

  //���ʹ���Ϣ���Ǹ����ڵĴ�С��λ�ý�Ҫ���ı�ʱ
  //������setwindowpos�������������ڹ�����
  WM_WindowPosChanging = $0046;

  //���ʹ���Ϣ���Ǹ����ڵĴ�С��λ���Ѿ����ı�ʱ
  //������setwindowpos�������������ڹ�����
  WM_WindowPosChanged = $0047;
  WM_POWER            = $0048;

(*
  // windows 8, windows 7 �� �϶�ʧЧ
  http://www.xiangwangfeng.com/tag/uipi/
  http://www.xiangwangfeng.com/2010/10/20/uac%E7%9A%84%E5%89%8D%E4%B8%96%E4%BB%8A%E7%94%9F/
  
  ChangeWindowMessageFilter(WM_DROPFILES, MSGFLT_ADD);
  // WM_COPYGLOBALDATA $0049
  ChangeWindowMessageFilter($0049, MSGFLT_ADD);

  Vista/Win7ϵͳ�У�����UAC��UIPI�Ĵ��ڣ���Ȩ�޵Ľ������޷����Ȩ�޵Ľ��̷���
  �κθ���WM_USER����Ϣ��������WM_USER����Ϣһ����Ҳ����Ϊ��ȫԭ�򱻽�ֹ

 ����������ķ������������֣�
    a.�������һ����Ҫ��Ȩ����һЩ���������Կ��ǽ�UI��صĲ����趨Ϊ��ͨ�û�Ȩ�ޣ�
      ��һЩ��Ҫ����Ȩ�޵�����ȫ��������һ������ԱȨ�޵Ľ����н��У���������ͨ��
      ����Ϣ֮���������ʽ����ͨ�ţ�����ܵ��������ڴ�ȵȡ�(���ַ���ʵ��̫���ۣ�
      �����кܶ����͵���Ϣ���������¼���Ҫ���������Ƽ�)
    b.����ChangeWindowMessageFilter���API������Ϣ���ˡ�
  MSDN�ϲ����Ƽ�ʹ�������������Ϊ�������ɱ�˷�Χ̫��Ӱ����ǵ�ǰ�������̣�
  ���Ƽ�ʹ��ChangeWindowMessageFilterEx����ĳ���صش��ڽ�����Ϣ���ˣ���������
  ��filter�Գ����Ӱ�죬��֤�˰�ȫ�ֲ������޷�ʵ��ĳЩ�ض����ܡ�
*)
  WM_COPYGLOBALDATA   = $0049;
  
  WM_COPYDATA         = $004A;

  //��ĳ���û�ȡ��������־����״̬���ύ����Ϣ������
  WM_CANCELJOURNAL    = $004B;

  //��ĳ���ؼ���ĳ���¼��Ѿ�����������ؼ���Ҫ�õ�һ
  //Щ��Ϣʱ�����ʹ���Ϣ�����ĸ�����
  WM_NOTIFY           = $004E;

  //���û�ѡ��ĳ���������ԣ����������Ե��ȼ��ı�
  WM_INPUTLANGCHANGEREQUEST = $0050;

  //��ƽ̨�ֳ��Ѿ����ı���ʹ���Ϣ����Ӱ����������
  WM_INPUTLANGCHANGE  = $0051;

  //�������Ѿ���ʼ��windows��������ʱ���ʹ���Ϣ��Ӧ�ó���
  WM_TCARD            = $0052;

  //����Ϣ��ʾ�û�������F1�����ĳ���˵��Ǽ���ģ�
  //�ͷ��ʹ���Ϣ���˴��ڹ����Ĳ˵��������
  //���͸��н���Ĵ��ڣ������ǰ��û�н��㣬
  //�ͰѴ���Ϣ���͸���ǰ����Ĵ���
  WM_HELP             = $0053;

  //���û��Ѿ�������˳����ʹ���Ϣ�����еĴ���
  //���û�������˳�ʱϵͳ�����û��ľ���
  //������Ϣ�����û���������ʱϵͳ���Ϸ��ʹ���Ϣ
  WM_USERCHANGED      = $0054;


  NFR_ANSI    = 1;
  NFR_UNICODE = 2;
  NF_QUERY    = 3;
  NF_REQUERY  = 4;
  // ListView ���� Column Header ʵ���϶��� Windows ͨ�ÿؼ�(Comctl32.dll)
  //���ÿؼ����Զ���ؼ������ǵĸ�����ͨ������Ϣ
  //���жϿؼ���ʹ��ANSI����UNICODE�ṹ
  WM_NOTIFYFORMAT     = $0055;

  //���û�ĳ�������е����һ���Ҽ��ͷ��ʹ���Ϣ���������
  WM_CONTEXTMENU      = $007B;

  //������SETWINDOWLONG������Ҫ�ı�һ������
  //���ڵķ��ʱ���ʹ���Ϣ���Ǹ�����
  WM_STYLECHANGING    = $007C;
  WM_STYLECHANGED     = $007D;

  //����ʾ���ķֱ��ʸı���ʹ���Ϣ�����еĴ���
  WM_DISPLAYCHANGE        = $007E;
  WM_GETICON              = $007F;
  WM_SETICON              = $0080;


  { WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes }
  HTERROR                 = -2;
  HTTRANSPARENT           = -1;
  HTNOWHERE               = 0;
  HTCLIENT                = 1;
  HTCAPTION               = 2;
  HTSYSMENU               = 3;
  HTGROWBOX               = 4;
  HTSIZE                  = HTGROWBOX;
  HTMENU                  = 5;
  HTHSCROLL               = 6;
  HTVSCROLL               = 7;
  HTMINBUTTON             = 8;
  HTMAXBUTTON             = 9;
  HTLEFT                  = 10;
  HTRIGHT                 = 11;
  HTTOP                   = 12;
  HTTOPLEFT               = 13;
  HTTOPRIGHT              = 14;
  HTBOTTOM                = 15;
  HTBOTTOMLEFT            = $10;
  HTBOTTOMRIGHT           = 17;
  HTBORDER                = 18;
  HTREDUCE                = HTMINBUTTON;
  HTZOOM                  = HTMAXBUTTON;
  HTSIZEFIRST             = HTLEFT;
  HTSIZELAST              = HTBOTTOMRIGHT;
  HTOBJECT                = 19;
  HTCLOSE                 = 20;
  HTHELP                  = 21;

  //��ĳ�����ڵ�һ�α�����ʱ������Ϣ��WM_CREATE��Ϣ����ǰ����
  WM_NCCREATE             = $0081;
  WM_NCDESTROY            = $0082;

  // http://blog.csdn.net/qq867346668/article/details/6278234
  // http://www.cnblogs.com/SkylineSoft/archive/2010/04/30/1724735.html
  WM_NCCALCSIZE           = $0083;
  // WVR_REDRAW
  // WM_NCCALCSIZE��Ϣ����Ҫ���㴰�ڿͻ����Ĵ�С��λ��ʱ���͡�
  // ͨ�����������Ϣ��Ӧ�ó�������ڴ��ڴ�С��λ�øı�ʱ���ƿͻ���������
  
  WM_NCHitTest            = $0084;
  WM_NCPAINT              = $0085;

  // http://msdn.microsoft.com/en-us/library/ms632633(VS.85).aspx
  // When the wParam parameter is FALSE, an application should return TRUE to
  // indicate that the system should proceed with the default processing,
  // or it should return FALSE to prevent the change. When wParam is TRUE, the return value is ignored.
  WM_NCACTIVATE           = $0086;

  { Windows �� WM_GETDLGCODE ��Ϣ���͵��Ŀؼ��ڶԻ����л��� IsDialogMessage
    ����������������λ�ô����С� ͨ����Ӧ�ó����� WM_GETDLGCODE ��Ϣ�Է�
    ֹ Windows ִ��Ĭ�ϴ��������Ϣ����Ӧ��WM_KEYDOWN�� WM_SYSCHAR �� WM_CHAR
    ��Ϣ�Ǽ�����Ϣ��ʾ�� }
  WM_GETDLGCODE           = $0087;
  WM_NCMOUSEMOVE          = $00A0;
  WM_NCLBUTTONDOWN        = $00A1;
  WM_NCLBUTTONUP          = $00A2;
  WM_NCLBUTTONDBLCLK      = $00A3;
  WM_NCRBUTTONDOWN        = $00A4;
  WM_NCRBUTTONUP          = $00A5;
  WM_NCRBUTTONDBLCLK      = $00A6;
  WM_NCMBUTTONDOWN        = $00A7;
  WM_NCMBUTTONUP          = $00A8;
  WM_NCMBUTTONDBLCLK      = $00A9;

  WM_NCXBUTTONDOWN        = $00AB;
  WM_NCXBUTTONUP          = $00AC;
  WM_NCXBUTTONDBLCLK      = $00AD;
  WM_INPUT                = $00FF;

  WM_KEYFIRST             = $0100;
  WM_KEYDOWN              = $0100;
  WM_KEYUP                = $0101;
  WM_CHAR                 = $0102;
  WM_DEADCHAR             = $0103;
  WM_SYSKEYDOWN           = $0104;
  WM_SYSKEYUP             = $0105;
  WM_SYSCHAR              = $0106;
  WM_SYSDEADCHAR          = $0107;
  WM_UNICHAR              = $0109;
  WM_KEYLAST              = $0109;

  WM_INITDIALOG           = $0110;
  WM_COMMAND              = $0111;
  WM_SYSCOMMAND           = $0112;
  WM_TIMER                = $0113;
  WM_HSCROLL              = $0114;
  WM_VSCROLL              = $0115;
  WM_INITMENU             = $0116;
  WM_INITMENUPOPUP        = $0117;
  WM_MENUSELECT           = $011F;
  WM_MENUCHAR             = $0120;
  WM_ENTERIDLE            = $0121;

  WM_MENURBUTTONUP        = $0122;
  WM_MENUDRAG             = $0123;
  WM_MENUGETOBJECT        = $0124;
  WM_UNINITMENUPOPUP      = $0125;
  WM_MENUCOMMAND          = $0126;

  WM_CHANGEUISTATE        = $0127;
  WM_UPDATEUISTATE        = $0128;
  WM_QUERYUISTATE         = $0129;

  WM_CTLCOLORMSGBOX       = $0132;
  WM_CTLCOLOREDIT         = $0133;
  WM_CTLCOLORLISTBOX      = $0134;
  WM_CTLCOLORBTN          = $0135;
  WM_CTLCOLORDLG          = $0136;
  WM_CTLCOLORSCROLLBAR    = $0137;
  WM_CTLCOLORSTATIC       = $0138;

  WM_MOUSEFIRST           = $0200;
  WM_MOUSEMOVE            = $0200;
  WM_LBUTTONDOWN          = $0201;
  WM_LBUTTONUP            = $0202;
  WM_LBUTTONDBLCLK        = $0203;
  WM_RBUTTONDOWN          = $0204;
  WM_RBUTTONUP            = $0205;
  WM_RBUTTONDBLCLK        = $0206;
  WM_MBUTTONDOWN          = $0207;
  WM_MBUTTONUP            = $0208;
  WM_MBUTTONDBLCLK        = $0209;
  WM_MOUSEWHEEL           = $020A;
  WM_MOUSELAST            = $020A;

  WM_PARENTNOTIFY         = $0210;
  WM_ENTERMENULOOP        = $0211;
  WM_EXITMENULOOP         = $0212;
  WM_NEXTMENU             = $0213;

  WM_SIZING               = 532;
  WM_CAPTURECHANGED       = 533;
  WM_MOVING               = 534;
  WM_POWERBROADCAST       = 536;
  WM_DEVICECHANGE         = 537;

  WM_IME_STARTCOMPOSITION = $010D;
  WM_IME_ENDCOMPOSITION   = $010E;

  WM_IME_COMPOSITION      = $010F;
  // http://topic.csdn.net/t/20040715/14/3177575.html
  // ���û��ı��˱���״̬ʱ�����ʹ���ϢWM_IME_COMPOSITION

  WM_IME_KEYLAST          = $010F;

  // WM_IME_SETCONTEXT lparam
  ISC_SHOWUICANDIDATEWINDOW      = $00000001;
  ISC_SHOWUICOMPOSITIONWINDOW    = $80000000;
  ISC_SHOWUIGUIDELINE            = $40000000;
  ISC_SHOWUIALLCANDIDATEWINDOW   = $0000000F;
  ISC_SHOWUIALL           = $C000000F;
  WM_IME_SETCONTEXT       = $0281;
  
  WM_IME_NOTIFY           = $0282;

{ wParam for WM_IME_CONTROL to the soft keyboard }
{ dwAction for ImmNotifyIME }
  NI_OPENCANDIDATE               = $0010;
  NI_CLOSECANDIDATE              = $0011;
  NI_SELECTCANDIDATESTR          = $0012;
  NI_CHANGECANDIDATELIST         = $0013;
  NI_FINALIZECONVERSIONRESULT    = $0014;
  NI_COMPOSITIONSTR              = $0015;
  NI_SETCANDIDATE_PAGESTART      = $0016;
  NI_SETCANDIDATE_PAGESIZE       = $0017;

  WM_IME_CONTROL          = $0283;
  WM_IME_COMPOSITIONFULL  = $0284;
  WM_IME_SELECT           = $0285;
  WM_IME_CHAR             = $0286;
  WM_IME_REQUEST          = $0288;

  WM_IME_KEYDOWN          = $0290;
  WM_IME_KEYUP            = $0291;

  WM_MDICREATE            = $0220;
  WM_MDIDESTROY           = $0221;
  WM_MDIACTIVATE          = $0222;
  WM_MDIRESTORE           = $0223;
  WM_MDINEXT              = $0224;
  WM_MDIMAXIMIZE          = $0225;
  WM_MDITILE              = $0226;
  WM_MDICASCADE           = $0227;
  WM_MDIICONARRANGE       = $0228;
  WM_MDIGETACTIVE         = $0229;
  WM_MDISETMENU           = $0230;

  WM_ENTERSIZEMOVE        = $0231;
  WM_EXITSIZEMOVE         = $0232;

  // �Ϸ��ļ� ���µ�ʱ��
  // Hdrop := message.WParam
  // Count := DragQueryfile(hdrop, maxdword, Pfilename, max_path - 1);
  WM_DROPFILES            = $0233;
  
  WM_MDIREFRESHMENU       = $0234;

  WM_MOUSEHOVER           = $02A1;
  WM_MOUSELEAVE           = $02A3;

  WM_NCMOUSEHOVER         = $02A0;
  WM_NCMOUSELEAVE         = $02A2;
  WM_WTSSESSION_CHANGE    = $02B1;

  WM_TABLET_FIRST         = $02C0;
  WM_TABLET_LAST          = $02DF;

  WM_CUT                  = $0300;
  WM_COPY                 = $0301;
  WM_PASTE                = $0302;
  WM_CLEAR                = $0303;
  WM_UNDO                 = $0304;
  WM_RENDERFORMAT         = $0305;
  WM_RENDERALLFORMATS     = $0306;
  WM_DESTROYCLIPBOARD     = $0307;
  WM_DRAWCLIPBOARD        = $0308;
  WM_PAINTCLIPBOARD       = $0309;
  WM_VSCROLLCLIPBOARD     = $030A;
  WM_SIZECLIPBOARD        = $030B;
  WM_ASKCBFORMATNAME      = $030C;
  WM_CHANGECBCHAIN        = $030D;
  WM_HSCROLLCLIPBOARD     = $030E;
  WM_QUERYNEWPALETTE      = $030F;
  WM_PALETTEISCHANGING    = $0310;
  WM_PALETTECHANGED       = $0311;
  WM_HOTKEY               = $0312;

  WM_PRINT                = 791;
  WM_PRINTCLIENT          = 792;
  WM_APPCOMMAND           = $0319;
  WM_THEMECHANGED         = $031A;

  WM_HANDHELDFIRST        = 856;
  WM_HANDHELDLAST         = 863;

  WM_PENWINFIRST          = $0380;
  WM_PENWINLAST           = $038F;

  WM_COALESCE_FIRST       = $0390;
  WM_COALESCE_LAST        = $039F;

  WM_DDE_FIRST            = $03E0;
  WM_DDE_INITIATE         = WM_DDE_FIRST + 0;
  WM_DDE_TERMINATE        = WM_DDE_FIRST + 1;
  WM_DDE_ADVISE           = WM_DDE_FIRST + 2;
  WM_DDE_UNADVISE         = WM_DDE_FIRST + 3;
  WM_DDE_ACK              = WM_DDE_FIRST + 4;
  WM_DDE_DATA             = WM_DDE_FIRST + 5;
  WM_DDE_REQUEST          = WM_DDE_FIRST + 6;
  WM_DDE_POKE             = WM_DDE_FIRST + 7;
  WM_DDE_EXECUTE          = WM_DDE_FIRST + 8;
  WM_DDE_LAST             = WM_DDE_FIRST + 8;

  WM_DWMCOMPOSITIONCHANGED        = $031E; 
  WM_DWMNCRENDERINGCHANGED        = $031F;
  WM_DWMCOLORIZATIONCOLORCHANGED  = $0320;
  WM_DWMWINDOWMAXIMIZEDCHANGE     = $0321;

  WM_APP                  = $8000;

{ NOTE: All Message Numbers below 0x0400 are RESERVED }

{ Private Window Messages Start Here }

  WM_USER                 = $0400;

{ Button Notification Codes }

const
  BN_CLICKED              = 0;
  BN_PAINT                = 1;
  BN_HILITE               = 2;
  BN_UNHILITE             = 3;
  BN_DISABLE              = 4;
  BN_DOUBLECLICKED        = 5;
  BN_PUSHED               = BN_HILITE;
  BN_UNPUSHED             = BN_UNHILITE;
  BN_DBLCLK               = BN_DOUBLECLICKED;
  BN_SETFOCUS             = 6;
  BN_KILLFOCUS            = 7;

{ Button Control Messages }
const
  BM_GETCHECK             = $00F0;
  BM_SETCHECK             = $00F1;
  BM_GETSTATE             = $00F2;
  BM_SETSTATE             = $00F3;
  BM_SETSTYLE             = $00F4;
  BM_CLICK                = $00F5;
  BM_GETIMAGE             = $00F6;
  BM_SETIMAGE             = $00F7;

{ Listbox Notification Codes }

const
  LBN_ERRSPACE            = (-2);
  LBN_SELCHANGE           = 1;
  LBN_DBLCLK              = 2;
  LBN_SELCANCEL           = 3;
  LBN_SETFOCUS            = 4;
  LBN_KILLFOCUS           = 5;

{ Listbox messages }

const
  LB_ADDSTR               = $0180;
  LB_INSERTSTR            = $0181;
  LB_DELETESTR            = $0182;
  LB_SELITEMRANGEEX       = $0183;
  LB_RESETCONTENT         = $0184;
  LB_SETSEL               = $0185;
  LB_SETCURSEL            = $0186;
  LB_GETSEL               = $0187;
  LB_GETCURSEL            = $0188;
  LB_GETTEXT              = $0189;
  LB_GETTEXTLEN           = $018A;
  LB_GETCOUNT             = $018B;
  LB_SELECTSTR            = $018C;
  LB_DIR                  = $018D;
  LB_GETTOPINDEX          = $018E;
  LB_FINDSTR              = $018F;
  LB_GETSELCOUNT          = $0190;
  LB_GETSELITEMS          = $0191;
  LB_SETTABSTOPS          = $0192;
  LB_GETHORIZONTALEXTENT  = $0193;
  LB_SETHORIZONTALEXTENT  = $0194;
  LB_SETCOLUMNWIDTH       = $0195;
  LB_ADDFILE              = $0196;
  LB_SETTOPINDEX          = $0197;
  LB_GETITEMRECT          = $0198;
  LB_GETITEMDATA          = $0199;
  LB_SETITEMDATA          = $019A;
  LB_SELITEMRANGE         = $019B;
  LB_SETANCHORINDEX       = $019C;
  LB_GETANCHORINDEX       = $019D;
  LB_SETCARETINDEX        = $019E;
  LB_GETCARETINDEX        = $019F;
  LB_SETITEMHEIGHT        = $01A0;
  LB_GETITEMHEIGHT        = $01A1;
  LB_FINDSTREXACT         = $01A2;
  LB_SETLOCALE            = $01A5;
  LB_GETLOCALE            = $01A6;
  LB_SETCOUNT             = $01A7;
  LB_INITSTORAGE          = $01A8;
  LB_ITEMFROMPOINT        = $01A9;
  LB_MSGMAX               = 432;

{ Combo Box Notification Codes }

const
  CBN_ERRSPACE            = (-1);
  CBN_SELCHANGE           = 1;
  CBN_DBLCLK              = 2;
  CBN_SETFOCUS            = 3;
  CBN_KILLFOCUS           = 4;
  CBN_EDITCHANGE          = 5;
  CBN_EDITUPDATE          = 6;
  CBN_DROPDOWN            = 7;
  CBN_CLOSEUP             = 8;
  CBN_SELENDOK            = 9;
  CBN_SELENDCANCEL        = 10;

{ Combo Box messages }

  CB_GETEDITSEL           = $0140;
  CB_LIMITTEXT            = $0141;
  CB_SETEDITSEL           = $0142;
  CB_ADDSTR               = $0143;
  CB_DELETESTR            = $0144;
  CB_DIR                  = $0145;
  CB_GETCOUNT             = $0146;
  CB_GETCURSEL            = $0147;
  CB_GETLBTEXT            = $0148;
  CB_GETLBTEXTLEN         = $0149;
  CB_INSERTSTR            = $014A;
  CB_RESETCONTENT         = $014B;
  CB_FINDSTR              = $014C;
  CB_SELECTSTR            = $014D;
  CB_SETCURSEL            = $014E;
  CB_SHOWDROPDOWN         = $014F;
  CB_GETITEMDATA          = $0150;
  CB_SETITEMDATA          = $0151;
  CB_GETDROPPEDCONTROLRECT= $0152;
  CB_SETITEMHEIGHT        = $0153;
  CB_GETITEMHEIGHT        = $0154;
  CB_SETEXTENDEDUI        = $0155;
  CB_GETEXTENDEDUI        = $0156;
  CB_GETDROPPEDSTATE      = $0157;
  CB_FINDSTREXACT         = $0158;
  CB_SETLOCALE            = 345;
  CB_GETLOCALE            = 346;
  CB_GETTOPINDEX          = 347;
  CB_SETTOPINDEX          = 348;
  CB_GETHORIZONTALEXTENT  = 349;
  CB_SETHORIZONTALEXTENT  = 350;
  CB_GETDROPPEDWIDTH      = 351;
  CB_SETDROPPEDWIDTH      = 352;
  CB_INITSTORAGE          = 353;
  CB_MSGMAX               = 354;

{ Edit Control Notification Codes }

const
  EN_SETFOCUS             = $0100;
  EN_KILLFOCUS            = $0200;
  EN_CHANGE               = $0300;
  EN_UPDATE               = $0400;
  EN_ERRSPACE             = $0500;
  EN_MAXTEXT              = $0501;
  EN_HSCROLL              = $0601;
  EN_VSCROLL              = $0602;

{ Edit Control Messages }

const
  EM_GETSEL               = $00B0;
  EM_SETSEL               = $00B1;
  EM_GETRECT              = $00B2;
  EM_SETRECT              = $00B3;
  EM_SETRECTNP            = $00B4;
  EM_SCROLL               = $00B5;
  EM_LINESCROLL           = $00B6;
  EM_SCROLLCARET          = $00B7;
  EM_GETMODIFY            = $00B8;
  EM_SETMODIFY            = $00B9;
  EM_GETLINECOUNT         = $00BA;
  EM_LINEINDEX            = $00BB;
  EM_SETHANDLE            = $00BC;
  EM_GETHANDLE            = $00BD;
  EM_GETTHUMB             = $00BE;
  EM_LINELENGTH           = $00C1;
  EM_REPLACESEL           = $00C2;
  EM_GETLINE              = $00C4;
  EM_LIMITTEXT            = $00C5;
  EM_CANUNDO              = $00C6;
  EM_UNDO                 = $00C7;
  EM_FMTLINES             = $00C8;
  EM_LINEFROMCHAR         = $00C9;
  EM_SETTABSTOPS          = $00CB;
  EM_SETPASSWORDCHAR      = $00CC;
  EM_EMPTYUNDOBUFFER      = $00CD;
  EM_GETFIRSTVISIBLELINE  = $00CE;
  EM_SETREADONLY          = $00CF;
  EM_SETWORDBREAKPROC     = $00D0;
  EM_GETWORDBREAKPROC     = $00D1;
  EM_GETPASSWORDCHAR      = $00D2;
  EM_SETMARGINS           = 211;
  EM_GETMARGINS           = 212;
  EM_SETLIMITTEXT         = EM_LIMITTEXT;    //win40 Name change
  EM_GETLIMITTEXT         = 213;
  EM_POSFROMCHAR          = 214;
  EM_CHARFROMPOS          = 215;
  EM_SETIMESTATUS         = 216;
  EM_GETIMESTATUS         = 217;

const
  { Scroll bar messages }
  SBM_SETPOS              = 224;             { not in win3.1  }
  SBM_GETPOS              = 225;             { not in win3.1  }
  SBM_SETRANGE            = 226;           { not in win3.1  }
  SBM_SETRANGEREDRAW      = 230;     { not in win3.1  }
  SBM_GETRANGE            = 227;           { not in win3.1  }
  SBM_ENABLE_ARROWS       = 228;      { not in win3.1  }
  SBM_SETSCROLLINFO       = 233;
  SBM_GETSCROLLINFO       = 234;

{ Dialog messages }

  DM_GETDEFID             = (WM_USER+0);
  DM_SETDEFID             = (WM_USER+1);
  DM_REPOSITION           = (WM_USER+2);

  PSM_PAGEINFO            = (WM_USER+100);
  PSM_SHEETINFO           = (WM_USER+101);

implementation

end.
