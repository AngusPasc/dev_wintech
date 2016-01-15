{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit dll_user32_rect;

interface

uses
  atmcmbaseconst, winconst, wintype;

  function SetRect(var lprc: TRect; xLeft, yTop, xRight, yBottom: Integer): BOOL; stdcall; external user32 name 'SetRect';

  function SetRectEmpty(var lprc: TRect): BOOL; stdcall; external user32 name 'SetRectEmpty';

  function UnionRect(var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL; stdcall; external user32 name 'UnionRect';

  function CopyRect(var lprcDst: TRect; const lprcSrc: TRect): BOOL; stdcall; external user32 name 'CopyRect';

  { InflateRect����������Сָ�����εĿ�͸� }
  function InflateRect(var lprc: TRect; dx, dy: Integer): BOOL; stdcall; external user32 name 'InflateRect';

  function IntersectRect(var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL; stdcall; external user32 name 'IntersectRect';

  function SubtractRect(var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL; stdcall; external user32 name 'SubtractRect';

  function OffsetRect(var lprc: TRect; dx, dy: Integer): BOOL; stdcall; external user32 name 'OffsetRect';

  function IsRectEmpty(const lprc: TRect): BOOL; stdcall; external user32 name 'IsRectEmpty';

  function EqualRect(const lprc1, lprc2: TRect): BOOL; stdcall; external user32 name 'EqualRect';

  function PtInRect(const lprc: TRect; pt: TPoint): BOOL; stdcall; external user32 name 'PtInRect';

  { �ú����������һ�����ڵ�����ռ��һ���ӳ����������һ���ڵ�����ռ��һ���
    hWndfrom��ת�������ڴ��ڵľ��������˲���ΪNULL��HWND_DESETOP��ٶ���Щ������Ļ�����ϡ�
����hWndTo��ת�����Ĵ��ڵľ��������˲���ΪNULL��HWND_DESKTOP����Щ�㱻ת��Ϊ��Ļ����
    pt := Mouse.CursorPos;
    MapWindowPoints(0, Handle, pt, 1);

    ScreenToClient �� ClientToScreen
    CPoint pt(0,0);
    int i = ::MapWindowPoints(this->m_hWnd,GetDesktopWindow()->m_hWnd, &pt,10);
  }
  function MapWindowPoints(hWndFrom, hWndTo: HWND; var lpPoints; cPoints: UINT): Integer; stdcall; external user32 name 'MapWindowPoints';
  
implementation

end.
