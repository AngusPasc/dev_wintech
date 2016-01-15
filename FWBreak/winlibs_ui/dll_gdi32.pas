{$IFDEF FREEPASCAL}
{$MODE DELPHI}
{$ENDIF}
unit dll_gdi32;

interface 
                          
uses
  atmcmbaseconst, winconst, wintype;

const
  CCHDEVICENAME       = 32;     { size of a device name string  }    
  CCHFORMNAME         = 32;     { size of a form name string  }    
                            
  { Ternary raster operations }
  SRCCOPY             = $00CC0020;     { dest = source                    }
  SRCPAINT            = $00EE0086;     { dest = source OR dest            }
  SRCAND              = $008800C6;     { dest = source AND dest           }
  SRCINVERT           = $00660046;     { dest = source XOR dest           }
  SRCERASE            = $00440328;     { dest = source AND (NOT dest )    }

  NOTSRCCOPY          = $00330008;     { dest = (NOT source)              }
  NOTSRCERASE         = $001100A6;     { dest = (NOT src) AND (NOT dest)  }
  
  MERGECOPY           = $00C000CA;     { dest = (source AND pattern)      }
  MERGEPAINT          = $00BB0226;     { dest = (NOT source) OR dest      }

  PATCOPY             = $00F00021;     { dest = pattern                   }
  PATPAINT            = $00FB0A09;     { dest = DPSnoo                    }
  PATINVERT           = $005A0049;     { dest = pattern XOR dest          }

  // Inverts the destination rectangle
  DSTINVERT           = $00550009;     { dest = (NOT dest)                }
  
  BLACKNESS           = $00000042;     { dest = BLACK                     }
  WHITENESS           = $00FF0062;     { dest = WHITE                     }

  (* copy Screen                        
  BitBlt(bmp.Canvas.Handle,Left, Top, Width, Height, GetDC(0), Left, Top, SRCCOPY or CAPTUREBLT); //*)
  CAPTUREBLT          = $40000000;
  (*
  http://blog.163.com/xmh_2006/blog/static/2495631720089635810420/

  λͼ��windowsͼ�α���зǳ���Ҫ��һ�����档�ڽ�����ͨ��λͼ�����У���GDI����BitBlt��StretchBlt, StretchDIBits��
  �����õ�һ����դ�����룬��ROP�룬��SRCCOPY��PATPAINT��SRCAND�ȣ���������ڿ���ͼ���������漰������ROP2��
  ROP3��ROP4��Ĳ���
  ---------------------------------------------------------------
  ��Ԫ��դ������������ʹ��GDI���ߺ��������ʱ��GDIʹ�ö�Ԫ��դ������ROP2��ϻ��ʻ�ˢ���غ�Ŀ�������Եõ�
  �µ�Ŀ�����ء���SetROP2������GetROP2����֧��16�ֶ�Ԫ��դ�������磺(�����wingdi.h)
  #define R2_NOT              6   // Dn
  #define R2_XORPEN           7   // DPx
  ---------------------------------------------------------------
  ��Ԫ��դ����������ͼ����ͬ���Ĺ�դ�����������ɸ�������Ч��������Ҫ��������������أ�Դͼ�����ء�Ŀ��ͼ��
  ���غͻ�ˢ���أ�ģ��ͼ�����أ�����֮Ϊ��Ԫ��դ������ʹ�õ���ROP3�룬�磺(����Ĳμ�wingdi.h)
  #define SRCPAINT (DWORD)0x00EE0086 // dest = source OR dest
  #define SRCAND   (DWORD)0x008800C6 // dest = source AND dest
  ---------------------------------------------------------------
  ��Ԫ��դ�������ǻ����Դͼ�����أ�Ŀ��ͼ�����غ�ģ�廭ˢ�����⣬��������һ������λͼ���õ�4�������γ���
  ��Ԫ��դ��������Ӧ��ΪROP4�룬GDI������MaskBlt����ʹ�õ���ROP4�룬Ҳ��Ψһ������Ԫ��դ������API����
  ---------------------------------------------------------------
  ��դ�����ı��룺
  һ���ֽڿ��Ա���256�ֹ�դ�������ٶ�PΪ���ʻ�ˢ��λ��SΪԴͼ���λ��DΪĿ��ͼ���λ����������Ľ����P
  һ��������Ϊ0xF0����������Ľ����Sһ��������Ϊ0xCC����������Ľ����Dһ��������Ϊ0xAA��
  Const BYTE rop_P  =0xF0; // 1 1 1 1 0 0 0 0
  Const BYTE rop_S  =0xCC; // 1 1 0 0 1 1 0 0
  Const BYTE rop_D  =0xAA; // 1 0 1 0 1 0 1 0       
  *)
  // Prevents the bitmap from being mirrored
  NOMIRRORBITMAP      = $80000000;

  { constants for the biCompression field }
  BI_RGB = 0;
  BI_RLE8 = 1;
  BI_RLE4 = 2;
  BI_BITFIELDS = 3;

type                      
  PBitmapInfoHeader   = ^TBitmapInfoHeader;
  TBitmapInfoHeader   = packed record
    biSize            : DWORD;
    biWidth           : Longint;
    biHeight          : Longint;
    biPlanes          : Word;
    biBitCount        : Word;
    biCompression     : DWORD;
    biSizeImage       : DWORD;
    biXPelsPerMeter   : Longint;
    biYPelsPerMeter   : Longint;
    biClrUsed         : DWORD;
    biClrImportant    : DWORD;
  end;

{ Bitmap Header Definition }
  PBitmap             = ^TBitmap;
  TBitmap             = packed record
    bmType            : Longint;
    bmWidth           : Longint;
    bmHeight          : Longint;
    bmWidthBytes      : Longint;
    bmPlanes          : Word;
    bmBitsPixel       : Word;
    bmBits            : Pointer;
  end;

  PRGBTriple          = ^TRGBTriple;
  TRGBTriple          = packed record
    rgbtBlue          : Byte;
    rgbtGreen         : Byte;
    rgbtRed           : Byte;
  end;

  PRGBQuad            = ^TRGBQuad;
  TRGBQuad            = packed record
    rgbBlue           : Byte;
    rgbGreen          : Byte;
    rgbRed            : Byte;
    rgbReserved       : Byte;
  end;

  PBitmapInfo         = ^TBitmapInfo;
  TBitmapInfo         = packed record
    bmiHeader         : TBitmapInfoHeader;
    bmiColors         : array[0..0] of TRGBQuad;
  end;
                                      
  PDeviceModeA        = ^TDeviceModeA;
  TDeviceModeA        = packed record
    dmDeviceName      : array[0..CCHDEVICENAME - 1] of AnsiChar;
    dmSpecVersion     : Word;
    dmDriverVersion   : Word;
    dmSize            : Word;
    dmDriverExtra     : Word;
    dmFields          : DWORD;
    dmOrientation     : SHORT;
    dmPaperSize       : SHORT;
    dmPaperLength     : SHORT;
    dmPaperWidth      : SHORT;
    dmScale           : SHORT;
    dmCopies          : SHORT;
    dmDefaultSource   : SHORT;
    dmPrintQuality    : SHORT;
    dmColor           : SHORT;
    dmDuplex          : SHORT;
    dmYResolution     : SHORT;
    dmTTOption        : SHORT;
    dmCollate         : SHORT;
    dmFormName        : array[0..CCHFORMNAME - 1] of AnsiChar;
    dmLogPixels       : Word;
    dmBitsPerPel      : DWORD;
    dmPelsWidth       : DWORD;
    dmPelsHeight      : DWORD;
    dmDisplayFlags    : DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod       : DWORD;
    dmICMIntent       : DWORD;
    dmMediaType       : DWORD;
    dmDitherType      : DWORD;
    dmICCManufacturer : DWORD;
    dmICCModel        : DWORD;
    dmPanningWidth    : DWORD;
    dmPanningHeight   : DWORD;
  end;

  PDeviceModeW        = ^TDeviceModeW;
  TDeviceModeW        = record
    dmDeviceName      : array[0..CCHDEVICENAME - 1] of WideChar;
    dmSpecVersion     : Word;
    dmDriverVersion   : Word;
    dmSize            : Word;
    dmDriverExtra     : Word;
    dmFields          : DWORD;
    dmOrientation     : SHORT;
    dmPaperSize       : SHORT;
    dmPaperLength     : SHORT;
    dmPaperWidth      : SHORT;
    dmScale           : SHORT;
    dmCopies          : SHORT;
    dmDefaultSource   : SHORT;
    dmPrintQuality    : SHORT;
    dmColor           : SHORT;
    dmDuplex          : SHORT;
    dmYResolution     : SHORT;
    dmTTOption        : SHORT;
    dmCollate         : SHORT;
    dmFormName        : array[0..CCHFORMNAME - 1] of WideChar;
    dmLogPixels       : Word;
    dmBitsPerPel      : DWORD;
    dmPelsWidth       : DWORD;
    dmPelsHeight      : DWORD;
    dmDisplayFlags    : DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod       : DWORD;
    dmICMIntent       : DWORD;
    dmMediaType       : DWORD;
    dmDitherType      : DWORD;
    dmICCManufacturer : DWORD;
    dmICCModel        : DWORD;
    dmPanningWidth    : DWORD;
    dmPanningHeight   : DWORD;
  end;

//  PDevMode            = PDeviceMode;  {compatibility with Delphi 1.0}
//  TDevMode            = TDeviceMode;  {compatibility with Delphi 1.0}

  PPixelFormatDescriptor = ^TPixelFormatDescriptor;
  TPixelFormatDescriptor = packed record
    nSize             : Word;
    nVersion          : Word;
    dwFlags           : DWORD;
    iPixelType        : Byte;
    cColorBits        : Byte;
    cRedBits          : Byte;
    cRedShift         : Byte;
    cGreenBits        : Byte;
    cGreenShift       : Byte;
    cBlueBits         : Byte;
    cBlueShift        : Byte;
    cAlphaBits        : Byte;
    cAlphaShift       : Byte;
    cAccumBits        : Byte;
    cAccumRedBits     : Byte;
    cAccumGreenBits   : Byte;
    cAccumBlueBits    : Byte;
    cAccumAlphaBits   : Byte;
    cDepthBits        : Byte;
    cStencilBits      : Byte;
    cAuxBuffers       : Byte;
    iLayerType        : Byte;
    bReserved         : Byte;
    dwLayerMask       : DWORD;
    dwVisibleMask     : DWORD;
    dwDamageMask      : DWORD;
  end;
                                           
  PXForm              = ^TXForm;
  TXForm              = packed record
    eM11              : Single;
    eM12              : Single;
    eM21              : Single;
    eM22              : Single;
    eDx               : Single;
    eDy               : Single;
  end;

  function SelectObject(ADC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall; external gdi32 name 'SelectObject';
  function DeleteObject(p1: HGDIOBJ): BOOL; stdcall; external gdi32 name 'DeleteObject';
  
  function MoveToEx(ADC: HDC; p2, p3: Integer; p4: PPoint): BOOL; stdcall; external gdi32 name 'MoveToEx';
  function LineTo(ADC: HDC; X, Y: Integer): BOOL; stdcall; external gdi32 name 'LineTo';
  function Pie(ADC: HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer): BOOL; stdcall; external gdi32 name 'Pie';
  function Rectangle(ADC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall; external gdi32 name 'Rectangle';
  
const
  { Background Modes }
  TRANSPARENT = 1;
  OPAQUE = 2;
  BKMODE_LAST = 2;

  function SetBkMode(ADC: HDC; BkMode: Integer): Integer; stdcall; external gdi32 name 'SetBkMode';

  function RoundRect(ADC: HDC; X1, Y1, X2, Y2, X3, Y3: Integer): BOOL; stdcall; external gdi32 name 'RoundRect';

  function AngleArc(ADC: HDC; p2, p3: Integer; p4: DWORD; p5, p6: Single): BOOL; stdcall; external gdi32 name 'AngleArc';
  function Arc(ADC: HDC; left, top, right, bottom, startX, startY, endX, endY: Integer): BOOL; stdcall; external gdi32 name 'Arc';
  function ArcTo(ADC: HDC; RLeft, RTop, RRight, RBottom: Integer; X1, Y1, X2, Y2: Integer): BOOL; stdcall; external gdi32 name 'ArcTo';

  function BeginPath(ADC: HDC): BOOL; stdcall; external gdi32 name 'BeginPath';
  function CloseFigure(ADC: HDC): BOOL; stdcall; external gdi32 name 'CloseFigure';
  function EndPath(ADC: HDC): BOOL; stdcall; external gdi32 name 'EndPath';
  function FillPath(ADC: HDC): BOOL; stdcall; external gdi32 name 'FillPath';

  function StartPage(ADC: HDC): Integer; stdcall; external gdi32 name 'StartPage';
  function EndPage(ADC: HDC): Integer; stdcall; external gdi32 name 'EndPage';

  function Chord(ADC: HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer): BOOL; stdcall; external gdi32 name 'Chord';
  function Ellipse(ADC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall; external gdi32 name 'Ellipse';
  function Polygon(ADC: HDC; var Points; Count: Integer): BOOL; stdcall; external gdi32 name 'Polygon';
  function Polyline(ADC: HDC; var Points; Count: Integer): BOOL; stdcall; external gdi32 name 'Polyline';
  function PolyBezier(ADC: HDC; const Points; Count: DWORD): BOOL; stdcall; external gdi32 name 'PolyBezier';
  function PolyBezierTo(ADC: HDC; const Points; Count: DWORD): BOOL; stdcall; external gdi32 name 'PolyBezierTo';

  // CreateDIBSection��������һ��DIBSECTION�ṹ����CreateDIBitmap��������BITMAP�ṹ
  {
  CreateDIBitmap The DDB that is created will be whatever bit depth your reference DC is.
  CreateDIBSection To create a bitmap that is of different bit depth
  ����Ҫ������DIB��DDB�����𣬶���DDB��DIB��ת����ֻҪ����һ��λͼ��Ϣͷ�����ˣ����Ǵ�DIB��DDB��ת����
  Ҫ���ݵ�ǰDC��λͼ��ʽ������λɫ�ʣ�������Ҫ��չҲ����Ҫ����ɫ��λ��������㿼��������أ�������Ϊ�����ٶȵ���ʧ��
  ���GDI��DDB��ͼ�϶������ģ�ֱ�ӿ���λͼ���ݵ��Դ漴��

  ʹ��CreateDIBSection()���׿���,��Ϊ�㹹���BITMAPINFO�Ƕ���bit�Ͱ�����bit����������λ����.
  ��CreateDIBitmap(), create��������DDB,�Ǻ���Ļɫ����ͬ��,����̨����������16Bit��,������̨
  ������������24bit������32bit,���Բ����ڴ���ٿ�/ά��
  }
  
const
  DIB_RGB_COLORS = 0;     { color table in RGBs  }
  DIB_PAL_COLORS = 1;     { color table in palette indices  }

  function CreateDIBSection(ADC: HDC; const p2: TBitmapInfo; p3: UINT;
      var p4: Pointer; p5: THandle; p6: DWORD): HBITMAP; stdcall; external gdi32 name 'CreateDIBSection';

  { dwUsage =
        CBM_INIT  �˺���ʹ�ô���ϢϢͷ�ṹ����ȡλͼ����Ŀ�ȡ��߶��Լ�������Ϣ
                        ϵͳ��ʹ��lpblnit��lpbmi��������ָ�����������λͼ�е�λ���г�ʼ��
                        fdwlnitΪ0����ôϵͳ�����λͼ��λ���г�ʼ��
    wUsage
        DIB_PAL_COLORS  �ṩһ����ɫ�����Ҹñ��ɸ�λͼҪѡ����豸�������߼���ɫ���16λ����ֵ�������
        DIB_RGB_COLORS  �ṩһ����ɫ�����ұ��а�����ԭ���RGBֵ

    bitinfo.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
    bitinfo.bmiHeader.biWidth         = lWidth;
    bitinfo.bmiHeader.biHeight        = lHeight;
    bitinfo.bmiHeader.biPlanes        = 1;
    bitinfo.bmiHeader.biBitCount      = wBitCount;
    bitinfo.bmiHeader.biCompression   = BI_RGB;
    bitinfo.bmiHeader.biSizeImage     = lWidth*lHeight*(wBitCount/8);
    bitinfo.bmiHeader.biXPelsPerMeter = 96;
    bitinfo.bmiHeader.biYPelsPerMeter = 96;
    bitinfo.bmiHeader.biClrUsed       = 0;
    bitinfo.bmiHeader.biClrImportant  = 0;
  }
  function CreateDIBitmap(ADC: HDC; var InfoHeader: TBitmapInfoHeader;
      dwUsage: DWORD; InitBits: PAnsiChar; var InitInfo: TBitmapInfo; wUsage: UINT): HBITMAP; stdcall; external gdi32 name 'CreateDIBitmap';
  { return ERROR_INVALID_BITMAP
    CreateBitmap()Ҫ�趨��С��ͼ����ȣ���ÿ�����ض���λ����CreateCompatibleBitmap()����������DC�л�ȡͼ�����
  }
  function CreateBitmap(Width, Height: Integer; Planes, BitCount: Longint; Bits: Pointer): HBITMAP; stdcall; external gdi32 name 'CreateBitmap';
  function CreateBitmapIndirect(const p1: TBitmap): HBITMAP; stdcall; external gdi32 name 'CreateBitmapIndirect';

  { HDC memDC = CreateCompatibleDC ( hDC );
    HBITMAP memBM = CreateCompatibleBitmap ( hDC, nWidth, nHeight );
    SelectObject ( memDC, memBM )
  }
  function CreateCompatibleBitmap(ADC: HDC; Width, Height: Integer): HBITMAP; stdcall; external gdi32 name 'CreateCompatibleBitmap';
  function CreateDiscardableBitmap(ADC: HDC; p2, p3: Integer): HBITMAP; stdcall; external gdi32 name 'CreateDiscardableBitmap';

  function CreateCompatibleDC(ADC: HDC): HDC; stdcall; external gdi32 name 'CreateCompatibleDC';
  function DeleteDC(ADC: HDC): BOOL; stdcall; external gdi32 name 'DeleteDC';

  function CreateDC(lpszDriver, lpszDevice, lpszOutput: PAnsiChar; lpdvmInit: PDeviceModeA): HDC; stdcall; external gdi32 name 'CreateDCA';
  function ResetDC(ADC: HDC; const InitData: TDeviceModeA): HDC; stdcall; external gdi32 name 'ResetDCA';

  // �ú���ͨ������������ѡ�������ͼ��ģʽ
  // ����λͼ�����ʡ���ɫ�塢���塢�ʡ����򡢻�ͼģʽ��ӳ��ģʽ����������������ջ��Ϊ���棬ָ���豸�����Ļ����ĵ�ǰ״̬
  function SaveDC(ADC: HDC): Integer; stdcall; external gdi32 name 'SaveDC';
  function RestoreDC(ADC: HDC; SavedDC: Integer): BOOL; stdcall; external gdi32 name 'RestoreDC';

  // �ú����Ĺ����ǰ��豸�����Ļ���������δ���Ĳ���ȡ��
  // CancelDc����һ���ɶ��߳�Ӧ�ó���ʹ�ã�����ȡ��һ���߳��Ļ滭������
  // ����߳�A������һ���߳��Ļ滭�������߳�B����ͨ�����ô˺�����ȡ����
  // ���һ��������ȡ������ô��Ӱ����߳̽�����һ�����󣬲��Ҹû滭�����Ľ���ǲ�ȷ���ģ�
  // ���һ�������в�û�л滭�������������˸ú���������Ҳ�ǲ�ȷ����
  function CancelDC(ADC: HDC): BOOL; stdcall; external gdi32 name 'CancelDC';

  function BitBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC;
      XSrc, YSrc: Integer; Rop: DWORD): BOOL; stdcall; external gdi32 name 'BitBlt';
  function GetStretchBltMode(ADC: HDC): Integer; stdcall; external gdi32 name 'GetStretchBltMode';
  function StretchBlt(DestDC: HDC; X, Y, Width, Height: Integer; SrcDC: HDC;
      XSrc, YSrc, SrcWidth, SrcHeight: Integer; Rop: DWORD): BOOL; stdcall; external gdi32 name 'StretchBlt';
  function StretchDIBits(ADC: HDC; DestX, DestY, DestWidth, DestHeight, SrcX,
      SrcY, SrcWidth, SrcHeight: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo;
      Usage: UINT; Rop: DWORD): Integer; stdcall; external gdi32 name 'StretchDIBits';

  {
      �趨��ǰǰ��ɫ�Ļ��ģʽ��
          R2_NOT  ����ȡ������˼
      3. R2_NOPPixel remains unchanged.
      4. R2_NOTPixel is the inverse of the screen color. //��ǰ���Ƶ�����ֵ��Ϊ��Ļ����ֵ�ķ����������Ը��ǵ��ϴεĻ�ͼ�����Զ������ϴλ��Ƶ�ͼ�Σ�
      5. R2_COPYPENPixel is the pen color. //ʹ�õ�ǰ�Ļ��ʵ���ɫ
      6. R2_NOTCOPYPENPixel is the inverse of the pen color.
      //�����ǵ�ǰ���ʵ���ɫ����Ļɫ���������õ��Ļ�ͼģʽ��
      7. R2_MERGEPENNOTPixel is a combination of the pen color and the inverse of the screen color (final pixel = (NOT screen pixel) OR pen).
      8. R2_MASKPENNOTPixel is a combination of the colors common to both the pen and the inverse of the screen (final pixel = (NOT screen pixel) AND pen). //R2_COPYPEN��R2_NOT�Ľ���
      9. R2_MERGENOTPENPixel is a combination of the screen color and the inverse of the pen color (final pixel = (NOT pen) OR screen pixel). //R2_NOTCOPYPEN����Ļ����ֵ�Ĳ���
      10. R2_MASKNOTPENPixel is a combination of the colors common to both the screen and the inverse of the pen (final pixel = (NOT pen) AND screen pixel). //R2_NOTCOPYPEN����Ļ����ֵ�Ľ���
      11. R2_MERGEPENPixel is a combination of the pen color and the screen color (final pixel = pen OR screen pixel). //R2_COPYPEN����Ļ����ֵ�Ĳ���
      12. R2_NOTMERGEPENPixel is the inverse of the R2_MERGEPEN color (final pixel = NOT(pen OR screen pixel)). //R2_MERGEPEN�ķ�ɫ
      13. R2_MASKPENPixel is a combination of the colors common to both the pen and the screen (final pixel = pen AND screen pixel). //R2_COPYPEN����Ļ����ֵ�Ľ���
      14. R2_NOTMASKPENPixel is the inverse of the R2_MASKPEN color (final pixel = NOT(pen AND screen pixel)). //R2_MASKPEN�ķ�ɫ
      15. R2_XORPENPixel is a combination of the colors that are in the pen or in the screen, but not in both (final pixel = pen XOR screen pixel). //R2_COPYPEN����Ļ����ֵ�����
      16. R2_NOTXORPENPixel is the inverse of the R2_XORPEN color (final pixel = NOT(pen XOR screen pixel)). //R2_XORPEN�ķ�ɫ
  }
const
  R2_BLACK       = 1;     {  0   } //���л��Ƴ���������Ϊ��ɫ
  R2_NOTMERGEPEN = 2;     { DPon } //���л��Ƴ���������Ϊ��ɫ
  R2_MASKNOTPEN  = 3;     { DPna } //�κλ��ƽ����ı䵱ǰ��״̬
  R2_NOTCOPYPEN  = 4;     { PN   }
  R2_MASKPENNOT  = 5;     { PDna }
  R2_NOT         = 6;     { Dn   } //��ǰ���ʵķ�ɫ
  R2_XORPEN      = 7;     { DPx  }
  R2_NOTMASKPEN  = 8;     { DPan }
  R2_MASKPEN     = 9;     { DPa  }
  R2_NOTXORPEN   = 10;    { DPxn }
  R2_NOP         = 11;    { D    }
  R2_MERGENOTPEN = 12;    { DPno }
  R2_COPYPEN     = 13;    { P    }
  R2_MERGEPENNOT = 14;    { PDno }
  R2_MERGEPEN    = 15;    { DPo  }
  R2_WHITE       = $10;   {  1   }

  { ��Ƥ���ͼ�����ʹ��ʵ��
      // ��������ƶ���ʼ��ͼ
      if (nFlags == MK_LBUTTON)
      {   // ��������RGB(0x00, 0x00, 0xFF)
          HPEN hPen = ::CreatePen(PS_SOLID, m_PenWidth, RGB(0x00, 0x00, 0xFF));
          // ʹ�û���
          ::SelectObject(m_hMemDC, hPen);
          //����ϵͳɫ��ģʽȡ��ɫ
          int oldRop=::SetROP2(m_hMemDC,R2_NOTXORPEN);
          // ����
          ::MoveToEx(m_hMemDC,m_pOrigin.x,m_pOrigin.y, NULL);
          ::LineTo(m_hMemDC, m_pPrev.x,m_pPrev.y);
          //�ָ�ϵͳĬ��ɫ��ģʽ
          ::SetROP2(m_hMemDC,oldRop);
          ::MoveToEx(m_hMemDC, m_pOrigin.x, m_pOrigin.y, NULL);
          ::LineTo(m_hMemDC, point.x, point.y);
          m_pPrev = point;
          Invalidate(FALSE);
  }
  function SetROP2(ADC: HDC; p2: Integer): Integer; stdcall; external gdi32 name 'SetROP2';

const
  { StretchBlt() Modes }
  // ʹ�����������ڵ�������ɫֵ�����߼�AND���룩�������㡣�����λͼ�ǵ�ɫλͼ��
  // ��ô��ģʽ��������ɫ����Ϊ���ۣ�������ɫ���ص�
  BLACKONWHITE = 1;
  // ʹ����ɫֵ�����߼�OR���򣩲����������λͼΪ��ɫλͼ����ô��ģʽ��������ɫ����Ϊ���ۣ�������ɫ���ص�
  WHITEONBLACK = 2;
  //ɾ�����ء���ģʽɾ�����������������У�����������Ϣ
  COLORONCOLOR = 3;
  // ��Դ�������е�����ӳ�䵽Ŀ������������ؿ��У�����Ŀ�����ؿ��һ����ɫ��Դ���ص���ɫ�ӽ���
  // ��������HALFTONE����ģ֮��Ӧ�ó���������SetBrushOrgEx����������ˢ�ӵ���ʼ�㡣���û��
  // �ɹ�����ô�����ˢ��û��׼�����
  HALFTONE = 4;
  MAXSTRETCHBLTMODE = 4;

  // �ú�����������ָ���豸�����е�λͼ����ģʽ
  // �������ִ�гɹ�����ô����ֵ������ǰ������ģʽ���������ִ��ʧ�ܣ���ô����ֵΪ0
  function SetStretchBltMode(ADC: HDC; StretchMode: Integer): Integer; stdcall; external gdi32 name 'SetStretchBltMode';

  function CheckColorsInGamut(ADC: HDC; var RGBQuads, Results; Count: DWORD): BOOL; stdcall; external gdi32 name 'CheckColorsInGamut';

  function ChoosePixelFormat(ADC: HDC; p2: PPixelFormatDescriptor): Integer; stdcall; external gdi32 name 'ChoosePixelFormat';
  function SetPixelFormat(ADC: HDC; PixelFormat: Integer; FormatDef: PPixelFormatDescriptor): BOOL; stdcall; external gdi32 name 'SetPixelFormat';

  function GetDeviceCaps(ADC: HDC; Index: Integer): Integer; stdcall; external gdi32 name 'GetDeviceCaps';

  //=====================================================================
  function GetViewportExtEx(ADC: HDC; var Size: TSize): BOOL; stdcall; external gdi32 name 'GetViewportExtEx';
  // ȡ��Ŀǰ�豸�ʹ��ڵ�ԭ��
  function GetViewportOrgEx(ADC: HDC; var Point: TPoint): BOOL; stdcall; external gdi32 name 'GetViewportOrgEx';
  function GetWindowExtEx(ADC: HDC; var Size: TSize): BOOL; stdcall; external gdi32 name 'GetWindowExtEx';
  function GetWindowOrgEx(ADC: HDC; var Point: TPoint): BOOL; stdcall; external gdi32 name 'GetWindowOrgEx';

  function GetWorldTransform(ADC: HDC; var p2: TXForm): BOOL; stdcall; external gdi32 name 'GetWorldTransform';
  function ModifyWorldTransform(ADC: HDC; const p2: TXForm; p3: DWORD): BOOL; stdcall; external gdi32 name 'ModifyWorldTransform';

  // �߼���(0,0)��ӳ��Ϊ�豸��(cxClient/2,cyClient/2)
  function SetViewportOrgEx(ADC: HDC; X, Y: Integer; Point: PPoint): BOOL; stdcall; external gdi32 name 'SetViewportOrgEx';
  function SetViewportExtEx(ADC: HDC; XExt, YExt: Integer; Size: PSize): BOOL; stdcall; external gdi32 name 'SetViewportExtEx';
  function SetWindowOrgEx(ADC: HDC; X, Y: Integer; Point: PPoint): BOOL; stdcall; external gdi32 name 'SetWindowOrgEx';
  function SetWindowExtEx(ADC: HDC; XExt, YExt: Integer; Size: PSize): BOOL; stdcall; external gdi32 name 'SetWindowExtEx';


  function SetWorldTransform(ADC: HDC; const p2: TXForm): BOOL; stdcall; external gdi32 name 'SetWorldTransform';
  function SetBrushOrgEx(ADC: HDC; X, Y: Integer; PrevPt: PPoint): BOOL; stdcall; external gdi32 name 'SetBrushOrgEx';
  //=====================================================================

  function OffsetViewportOrgEx(ADC: HDC; X, Y: Integer; var Points): BOOL; stdcall; overload; external gdi32 name 'OffsetViewportOrgEx';
  function OffsetViewportOrgEx(ADC: HDC; X, Y: Integer; Points: PPoint): BOOL; stdcall; overload; external gdi32 name 'OffsetViewportOrgEx';

  function OffsetWindowOrgEx(ADC: HDC; X, Y: Integer; var Points): BOOL; stdcall; overload; external gdi32 name 'OffsetWindowOrgEx';
  function OffsetWindowOrgEx(ADC: HDC; X, Y: Integer; Points: PPoint): BOOL; stdcall; overload; external gdi32 name 'OffsetWindowOrgEx';
  function ScaleViewportExtEx(ADC: HDC; XM, XD, YM, YD: Integer; Size: PSize): BOOL; stdcall; external gdi32 name 'ScaleViewportExtEx';
  function ScaleWindowExtEx(ADC: HDC; XM, XD, YM, YD: Integer; Size: PSize): BOOL; stdcall; external gdi32 name 'ScaleWindowExtEx';

  function WidenPath(ADC: HDC): BOOL; stdcall; external gdi32 name 'WidenPath';
  function StrokePath(ADC: HDC): BOOL; stdcall; external gdi32 name 'StrokePath';
  function StrokeAndFillPath(ADC: HDC): BOOL; stdcall; external gdi32 name 'StrokeAndFillPath';
  function SelectClipPath(ADC: HDC; Mode: Integer): BOOL; stdcall; external gdi32 name 'SelectClipPath';

  // SwapBufferÿ�ε��ö���GetAPI����GetAPI��LoadLibrary,��GetProcAddress��
  // ��ȻSwapBuffersÿ��LoadLibrary/FreeLibarayҲ��ֻ�Ǹı����ü�����������
  // ��GetProcAddress�����п����ģ�������Cache����Ҳ���п����ġ�׷����Դ����
  // ���ҵ���GetProcAdress��source code������GetProcAddress�ǵ���LdrGetProcedureAddress������׷�飬LdrGetProcedureAddress��
  // http://www.cnblogs.com/cgwolver/archive/2009/04/01/1427317.html
  // ƽ��ÿ֡�࿪��0.5�����롣��һ�£�FPS�ﵽ 30֡��ʱ��ÿ֡����ʱ��Ƭֻ��33���룬ȴ�����װ��˷ѵ�0.5������
  // Ҫ����������⣬��û����Լ�ȥ��� wglSwapBuffers �������
  // ����ģʽopengl�£���Ҳ��ص�os �� GdiSwapBuffers
  // ����API������Ҳ�������� ChoosePixelFormat��DescribePixelFormat��GetPixelFormat��SetPixelFormat
  // opengl32.dll
  // һ�ֽ���ķ����ǣ��ڵ���ChoosePixelFormat��DescribePixelFormat��GetPixelFormat��SetPixelFormat��Щ����֮ǰ��
  // �ȵ��� LoadLibrary("OpenGL32.dll")�������Ͳ���Ƶ���ļ���ж��dll
  function SwapBuffers(ADC: HDC): BOOL; stdcall; external gdi32 name 'SwapBuffers';
  // wglSwapMultipleBuffers --- an undocumented wgl api

  function CreateBrushIndirect(const p1: TLogBrush): HBRUSH; stdcall; external gdi32 name 'CreateBrushIndirect';
  function CreatePatternBrush(ABitmap: HBITMAP): HBRUSH; stdcall; external gdi32 name 'CreatePatternBrush';
  
type  { Logical Pen }
  PLogPen           = ^TLogPen;
  TLogPen           = packed record
    lopnStyle       : UINT;
    lopnWidth       : TPoint;
    lopnColor       : COLORREF;
  end;
  
const                 
  { Brush Styles }
  BS_SOLID                = 0;
  BS_NULL                 = 1;
  BS_HOLLOW               = BS_NULL;
  BS_HATCHED              = 2;
  BS_PATTERN              = 3;
  BS_INDEXED              = 4;
  BS_DIBPATTERN           = 5;
  BS_DIBPATTERNPT         = 6;
  BS_PATTERN8X8           = 7;
  BS_DIBPATTERN8X8        = 8;
  BS_MONOPATTERN          = 9;
                 
  { Pen Styles }
  PS_SOLID       = 0;
  PS_DASH        = 1;      { ------- }
  PS_DOT         = 2;      { ....... }
  PS_DASHDOT     = 3;      { _._._._ }
  PS_DASHDOTDOT  = 4;      { _.._.._ }
  PS_NULL = 5;
  PS_INSIDEFRAME = 6;
  PS_USERSTYLE = 7;
  PS_ALTERNATE = 8;
  PS_STYLE_MASK = 15;

  PS_ENDCAP_ROUND = 0;
  PS_ENDCAP_SQUARE = $100;
  PS_ENDCAP_FLAT = $200;
  PS_ENDCAP_MASK = 3840;

  PS_JOIN_ROUND = 0;
  PS_JOIN_BEVEL = $1000;
  PS_JOIN_MITER = $2000;
  PS_JOIN_MASK = 61440;

  PS_COSMETIC = 0;
  PS_GEOMETRIC = $10000;
  PS_TYPE_MASK = $F0000;

  function CreatePen(Style, Width: Integer; Color: COLORREF): HPEN; stdcall; external gdi32 name 'CreatePen';
  function CreatePenIndirect(const LogPen: TLogPen): HPEN; stdcall; external gdi32 name 'CreatePenIndirect';

  function PtInRegion(RGN: HRGN; X, Y: Integer): BOOL; stdcall; external gdi32 name 'PtInRegion';
  function PtVisible(ADC: HDC; X, Y: Integer): BOOL; stdcall; external gdi32 name 'PtVisible';


const
  RDH_RECTANGLES = 1;

type
  PRgnDataHeader = ^TRgnDataHeader;
  TRgnDataHeader = packed record
    dwSize: DWORD;
    iType: DWORD;
    nCount: DWORD;
    nRgnSize: DWORD;
    rcBound: TRect;
  end;

  PRgnData = ^TRgnData;
  TRgnData = record
    rdh: TRgnDataHeader;
    Buffer: array[0..0] of AnsiChar;
    Reserved: array[0..2] of AnsiChar;
  end;

  function GetRegionData(ARGN: HRGN; p2: DWORD; p3: PRgnData): DWORD; stdcall; external gdi32 name 'GetRegionData';
  function GetRgnBox(ARGN: HRGN; var p2: TRect): Integer; stdcall; external gdi32 name 'GetRgnBox';

const
  { Object Definitions for EnumObjects() }
  OBJ_PEN         = 1;
  OBJ_BRUSH       = 2;
  OBJ_DC          = 3;
  OBJ_METADC      = 4;
  OBJ_PAL         = 5;
  OBJ_FONT        = 6;
  OBJ_BITMAP      = 7;
  OBJ_REGION      = 8;
  OBJ_METAFILE    = 9;
  OBJ_MEMDC       = 10;
  OBJ_EXTPEN      = 11;
  OBJ_ENHMETADC   = 12;
  OBJ_ENHMETAFILE = 13;

type
  TFNGObjEnumProc = TFarProc;
  
  function GetObjectType(h: HGDIOBJ): DWORD; stdcall; external gdi32 name 'GetObjectType';
  function EnumObjects(ADC: HDC; p2: Integer; p3: TFNGObjEnumProc; p4: LPARAM): Integer; stdcall; external gdi32 name 'EnumObjects';


const // Region identifiers for GetRandomRgn
  CLIPRGN = 1;
  METARGN = 2;
  APIRGN = 3;
  SYSRGN = 4;
  
  function GetRandomRgn(ADC: HDC; Rgn: HRGN; iNum: Integer): Integer; stdcall; external gdi32;
  function OffsetRgn(ARGN: HRGN; XOffset, YOffset: Integer): Integer; stdcall; external gdi32 name 'OffsetRgn';
  function OffsetClipRgn(ADC: HDC; XOffset, YOffset: Integer): Integer; stdcall; external gdi32 name 'OffsetClipRgn';
  function PaintRgn(ADC: HDC; RGN: HRGN): BOOL; stdcall; external gdi32 name 'PaintRgn';

const
  { Stock Logical Objects }
  WHITE_BRUSH   = 0;
  LTGRAY_BRUSH  = 1;
  GRAY_BRUSH    = 2;
  DKGRAY_BRUSH  = 3;
  BLACK_BRUSH   = 4;
  NULL_BRUSH    = 5;
  HOLLOW_BRUSH  = NULL_BRUSH;
  WHITE_PEN     = 6;
  BLACK_PEN     = 7;
  NULL_PEN      = 8;
  OEM_FIXED_FONT    = 10;
  ANSI_FIXED_FONT   = 11;
  ANSI_VAR_FONT     = 12;
  SYSTEM_FONT       = 13;
  DEVICE_DEFAULT_FONT = 14;  // Ĭ������
  DEFAULT_PALETTE   = 15;
  SYSTEM_FIXED_FONT = $10;
  DEFAULT_GUI_FONT  = 17;
  DC_BRUSH          = 18;
  DC_PEN            = 19;
  STOCK_LAST        = 19;
  
  function GetStockObject(Index: Integer): HGDIOBJ; stdcall; external gdi32 name 'GetStockObject';

  
  function CreateRoundRectRgn(ALeft, ATop, ARight, ABottom,
    AEllipseX, AEllipseY: Integer): HRGN; stdcall; external gdi32 name 'CreateRoundRectRgn';

  function DrawEscape(ADC: HDC; p2, p3: Integer; p4: LPCSTR): BOOL; stdcall; external gdi32 name 'DrawEscape';

  function GetBkColor(ADC: HDC): COLORREF; stdcall; external gdi32 name 'GetBkColor';
  function GetDCBrushColor(ADC: HDC): COLORREF; stdcall; external gdi32 name 'GetDCBrushColor';
  function GetDCPenColor(ADC: HDC): COLORREF; stdcall; external gdi32 name 'GetDCPenColor';
  function GetDCOrgEx(ADC: HDC; var Origin: TPoint): BOOL; stdcall; external gdi32 name 'GetDCOrgEx';

  function GetBkMode(ADC: HDC): Integer; stdcall; external gdi32 name 'GetBkMode';
  function GetBoundsRect(ADC: HDC; var Bounds: TRect; Flags: UINT): UINT; stdcall; external gdi32 name 'GetBoundsRect';
  function GetBrushOrgEx(ADC: HDC; var lppt: TPoint): BOOL; stdcall; external gdi32 name 'GetBrushOrgEx';

  {�ú�������һ���߼���ɫ�塣��ָ��ϵͳȥӳ���ɫ�壬��Ȼ����ǰ��û�б�ӳ�������һ�θ�Ӧ��Ϊһ��ָ���ĵ�ɫ����ú���ʱ��
   ��ϵͳ�Ѹ��߼���ɫ����ȫ����ӳ�䵽ϵͳ��ɫ���� }
  function UnrealizeObject(AGDIObj: HGDIOBJ): BOOL; stdcall; external gdi32 name 'UnrealizeObject';

  {ִ���κ�δ���Ļ�ͼ����}
  function GdiFlush: BOOL; stdcall; external gdi32 name 'GdiFlush';

  { ��ò�Ҫ�� SetBitmapBits,Ӧ����api����SetDIBits���� ??? }
  function SetBitmapBits(
      p1: HBITMAP;
      p2: DWORD;
      bits: Pointer): Longint; stdcall; external gdi32 name 'SetBitmapBits';


  function GetDIBits(DC: HDC; Bitmap: HBitmap; StartScan, NumScans: UINT;
    Bits: Pointer; var BitInfo: TBitmapInfo; Usage: UINT): Integer; stdcall; external gdi32 name 'GetDIBits';

  function SetDIBits(
      ADC: HDC;
      ABitmap: HBITMAP;
      AStartScan: UINT;
      ANumScans: UINT;
      ABits: Pointer;
      var BitsInfo: TBitmapInfo;
      Usage: UINT
      ): Integer; stdcall; external gdi32 name 'SetDIBits';

  { ���Ӧ���ǻ��������� Memory
        HBitmap һ�� ���� Bit һ��
        HBitmap ���ڴ���� Ӧ�û����� CreateBitmap / CreateBitmapIndirect
  }
  function SetDIBitsToDevice(
      ADC: HDC;
      DestX: Integer; DestY: Integer;
      Width: DWORD; Height: DWORD;
      SrcX: Integer; SrcY: Integer;
      nStartScan: UINT;  // ��ʲôλ�ÿ�ʼ��ʾdib
      NumScans: UINT;    // ɨ�������
      Bits: Pointer;     //ָ����dib��ʲôλ�ÿ�ʼɨ��
      var BitsInfo: TBitmapInfo;
      Usage: UINT   // DIB_RGB_COLORS
      ): Integer; stdcall; external gdi32 name 'SetDIBitsToDevice';
  // http://topic.csdn.net/u/20120921/16/DE29E5A8-911E-44B5-A776-0FAEBD02BA85.html

const
  { Mapping Modes }
  MM_TEXT = 1;
  MM_LOMETRIC = 2;
  MM_HIMETRIC = 3;
  MM_LOENGLISH = 4;
  MM_HIENGLISH = 5;
  MM_TWIPS = 6;
  MM_ISOTROPIC = 7;
  MM_ANISOTROPIC = 8;

  { Min and Max Mapping Mode values }
  MM_MIN = MM_TEXT;
  MM_MAX = MM_ANISOTROPIC;
  MM_MAX_FIXEDSCALE = MM_TWIPS;

  function SetMapMode(ADC: HDC; p2: Integer): Integer; stdcall; external gdi32 name 'SetMapMode';
  // SetWindowOrg
  function SetMapperFlags(ADC: HDC; AFlag: DWORD): DWORD; stdcall; external gdi32 name 'SetMapperFlags';
  function SetGraphicsMode(ADC: HDC; iMode: Integer): Integer; stdcall; external gdi32 name 'SetGraphicsMode';

//  function AlphaBlend(ADC: HDC; p2, p3, p4, p5: Integer;
//      DC6: HDC; p7, p8, p9, p10: Integer; p11: TBlendFunction): BOOL; stdcall; external msimg32 name 'AlphaBlend';
//  function AlphaDIBBlend(ADC: HDC; p2, p3, p4, p5: Integer; const p6: Pointer;
//      const p7: PBitmapInfo; p8: UINT; p9, p10, p11, p12: Integer; p13: TBlendFunction): BOOL; stdcall; external msimg32 name 'AlphaDIBBlend';
//  function TransparentBlt(ADC: HDC; p2, p3, p4, p5: Integer;
//      ADC6: HDC; p7, p8, p9, p10: Integer; p11: UINT): BOOL; stdcall; external msimg32 name 'TransparentBlt';
  function TransparentDIBits(ADC: HDC; p2, p3, p4, p5: Integer; const p6: Pointer;
      const p7: PBitmapInfo; p8: UINT; p9, p10, p11, p12: Integer; p13: UINT): BOOL; stdcall; external gdi32 name 'TransparentDIBits';

  { ȡ��ָ��DC��ͼ��ģʽ }
  function GetGraphicsMode(ADC: HDC): Integer; stdcall; external gdi32 name 'GetGraphicsMode';

  // �ú���������ӡ���豸������������

const
  { device capabilities indices }
  DC_FIELDS = 1;
  DC_PAPERS = 2;
  DC_PAPERSIZE = 3;
  DC_MINEXTENT = 4;
  DC_MAXEXTENT = 5;
  DC_BINS = 6;
  DC_DUPLEX = 7;
  DC_SIZE = 8;
  DC_EXTRA = 9;
  DC_VERSION = 10;
  DC_DRIVER = 11;
  DC_BINNAMES = 12;
  DC_ENUMRESOLUTIONS = 13;
  DC_FILEDEPENDENCIES = 14;
  DC_TRUETYPE = 15;
  DC_PAPERNAMES = 16;
  DC_ORIENTATION = 17;
  DC_COPIES = 18;
  DC_BINADJUST = 19;
  DC_EMF_COMPLIANT = 20;
  DC_DATATYPE_PRODUCED = 21;
  DC_COLLATE = 22;
  DC_MANUFACTURER = 23;
  DC_MODEL = 24;
  DC_COLORDEVICE = 23;
  DC_NUP = 24;
  DC_PERSONALITY = 25;
  DC_PRINTRATE = 26;
  DC_PRINTRATEUNIT = 27;

  PRINTRATEUNIT_PPM = 1;
  PRINTRATEUNIT_CPS = 2;
  PRINTRATEUNIT_LPM = 3;
  PRINTRATEUNIT_IPM = 4;

  DC_PRINTERMEM = 28;
  DC_MEDIAREADY = 29;

  { bit fields of the return value (DWORD) for DC_TRUETYPE }
  DCTT_BITMAP = 1;
  DCTT_DOWNLOAD = 2;
  DCTT_SUBDEV = 4;
  DCTT_DOWNLOAD_OUTLINE = 8;

  { return values for DC_BINADJUST }
  DCBA_FACEUPNONE = 0;
  DCBA_FACEUPCENTER = 1;
  DCBA_FACEUPLEFT = 2;
  DCBA_FACEUPRIGHT = 3;
  DCBA_FACEDOWNNONE = $100;
  DCBA_FACEDOWNCENTER = 257;
  DCBA_FACEDOWNLEFT = 258;
  DCBA_FACEDOWNRIGHT = 259;

  function DeviceCapabilitiesA(
      pDriverName: PAnsiChar;
      pDeviceName: PAnsiChar;
      pPort: PAnsiChar;
      iIndex: Integer;
      pOutput: PAnsiChar;
      DevMode: PDeviceModeA
      ): Integer; stdcall; external gdi32 name 'DeviceCapabilitiesA';
  function DeviceCapabilitiesW(
      pDriverName: PWideChar;
      pDeviceName: PWideChar;
      pPort: PWideChar;
      iIndex: Integer;
      pOutput: PWideChar;
      DevMode: PDeviceModeW
      ): Integer; stdcall; external gdi32 name 'DeviceCapabilitiesW';
  
implementation

end.
