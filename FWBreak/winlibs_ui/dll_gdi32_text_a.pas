{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit dll_gdi32_text_a;

interface 
                          
uses
  atmcmbaseconst, winconst, wintype, wintypeA;

type                
  PTextMetricA        = ^TTextMetricA;
  PTextMetric         = PTextMetricA;
  TTextMetricA        = record
    tmHeight          : Longint;
    tmAscent          : Longint;
    tmDescent         : Longint;
    tmInternalLeading : Longint;
    tmExternalLeading : Longint;
    tmAveCharWidth    : Longint;
    tmMaxCharWidth    : Longint;
    tmWeight          : Longint;
    tmOverhang        : Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar       : AnsiChar;
    tmLastChar        : AnsiChar;
    tmDefaultChar     : AnsiChar;
    tmBreakChar       : AnsiChar;
    tmItalic          : Byte;
    tmUnderlined      : Byte;
    tmStruckOut       : Byte;
    tmPitchAndFamily  : Byte;
    tmCharSet         : Byte;
  end;                                          
                                 
  function TextOut(DC: HDC; X, Y: Integer; Str: PAnsiChar; Count: Integer): BOOL; stdcall; external gdi32 name 'TextOutA';
  function ExtTextOut(DC: HDC; X, Y: Integer; Options: Longint; Rect: PRect; Str: PAnsiChar;
    Count: Longint; Dx: PInteger): BOOL; stdcall; external gdi32 name 'ExtTextOutA';

  function PolyTextOut(DC: HDC; const PolyTextArray; Strings: Integer): BOOL; stdcall; external gdi32 name 'PolyTextOutA';
  
  function EnumFontFamiliesEx(DC: HDC; var p2: TLogFontA;
    p3: TFNFontEnumProc; p4: LPARAM; p5: DWORD): BOOL; stdcall; external gdi32 name 'EnumFontFamiliesExA';

  function GetTextExtentPoint32(DC: HDC; Str: PAnsiChar; Count: Integer;
      var Size: TSize): BOOL; stdcall; external gdi32 name 'GetTextExtentPoint32A';
  function GetTextExtentPoint(DC: HDC; Str: PAnsiChar; Count: Integer;
      var Size: TSize): BOOL; stdcall; external gdi32 name 'GetTextExtentPointA';
  function GetTextFace(DC: HDC; Count: Integer; Buffer: PAnsiChar): Integer; stdcall; external gdi32 name 'GetTextFaceA';
  function GetTextMetrics(DC: HDC; var TM: TTextMetricA): BOOL; stdcall; external gdi32 name 'GetTextMetricsA';

type
  PLogFontA         = ^TLogFontA;
  PLogFont          = PLogFontA;
  TLogFontA         = packed record
    lfHeight        : Longint;
    lfWidth         : Longint;
    lfEscapement    : Longint; // ��ת�Ƕ� ��������뵱ǰ����ϵ X ��֮�����ʮ��֮һ��Ϊ��λ�ĽǶ�
    lfOrientation   : Longint; // ָ��ÿ���ַ��뵱ǰ����ϵ X ��֮�����ʮ��֮һ��Ϊ��λ�ĽǶ�
    lfWeight        : Longint; // �� 0 �� 1000 ��������س̶� ,400 �Ǳ�׼���� 700 Ϊ�������� ,0 ��ʾ����Ĭ��ֵ
    lfItalic        : Byte;
    lfUnderline     : Byte;
    lfStrikeOut     : Byte;
    lfCharSet       : Byte;
    lfOutPrecision  : Byte;    // ������ȡ�����ȷ����ǰ��һЩ�趨ֵ�ľ�ȷ�̶�
    lfClipPrecision : Byte;    // �ü����ȡ��ü��� Windows ͼ�λ����µ�һ�����⴦�� ,��˵����ȥ��ͼ����������
                               // ͼ����Ĳ��� ,���������ͼ�εĴ����ٶ�
    lfQuality       : Byte;    // �������
    lfPitchAndFamily: Byte;
    lfFaceName      : array[0..LF_FACESIZE - 1] of AnsiChar;
  end;

  function CreateFont(nHeight, nWidth, nEscapement, nOrientaion, fnWeight: Integer;
      fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision,
      fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: PAnsiChar): HFONT; stdcall; external gdi32 name 'CreateFontA';
  function CreateFontIndirect(const p1: TLogFontA): HFONT; stdcall; external gdi32 name 'CreateFontIndirectA';
//  function CreateFontIndirectEx(const p1: PEnumLogFontExDV): HFONT; stdcall; external gdi32 name 'CreateFontIndirectExA';

implementation

end.
