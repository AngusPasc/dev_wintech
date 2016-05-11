unit uiwin.screen;

interface

uses
  Windows, MultiMon;

type
  PWinMonitor       = ^TWinMonitor;
  TWinMonitor       = packed record
    MonitorHandle   : MultiMon.HMONITOR;
  end;

  PWinScreen        = ^TWinScreen;        
  TWinScreen        = packed record
    PixelsPerInch   : Integer; 
    DefaultKbLayout : HKL;

    PixelSize       : TSize;
    PhysicalSize    : TSize;
  end;

  function GetMonitorBoundsRect(AWinMonitor: PWinMonitor): TRect;    
  procedure GetDisplayDevicePhysicalSize(AScreen: PWinScreen; AScreenDC: HDC);  
  function GetDisplayDeviceSizeMM(AScreen: PWinScreen): double;
  function GetDisplayDeviceSizeInch(AScreen: PWinScreen): double;

implementation

function GetMonitorBoundsRect(AWinMonitor: PWinMonitor): TRect;
var
  tmpMonInfo: TMonitorInfo;
begin
  tmpMonInfo.cbSize := SizeOf(tmpMonInfo);
  GetMonitorInfo(AWinMonitor.MonitorHandle, @tmpMonInfo);
  Result := tmpMonInfo.rcMonitor;
end;

                   
function InitializeScreen(AScreen: PWinScreen): Integer;
var
  tmpDC: HDC;
begin
  tmpDC := GetDC(0);
  AScreen.PixelsPerInch := Windows.GetDeviceCaps(tmpDC, LOGPIXELSY);    
  AScreen.DefaultKbLayout := Windows.GetKeyboardLayout(0);
  ReleaseDC(0, tmpDC);
end;
  
function GetScreenMonitorCount: Integer;
begin
  //if FMonitors.Count = 0 then
  Result := GetSystemMetrics(SM_CMONITORS);
//  else
//    Result := FMonitors.Count;
end;
            
function GetScreenWorkAreaRect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0);
end;

function GetScreenPixelHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYSCREEN);
end;

function GetScreenPixelWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXSCREEN);
end;

procedure GetMonitorSizeFromEDID;//(TCHAR* adapterName, DWORD& Width, DWORD& Height)
begin
  // HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Enum\\DISPLAY\\
  // "Driver"\"Device Parameters"\"EDID"
(*//
EDID: Extended Display Identification Data����չ��ʾ��ʶ���ݣ�
��һ��VESA ��׼���ݸ�ʽ�����а����йؼ������������ܵĲ�����
������Ӧ����Ϣ�����ͼ���С����ɫ���á�����Ԥ���á�Ƶ�ʷ�Χ������
�Լ���ʾ���������кŵ��ַ����� ��Щ��Ϣ������ display ���У�����ͨ��
һ�� DDC��Display Data Channel����ϵͳ����ͨ�ţ���������ʾ���� PC
ͼ��������֮����еġ����°汾�� EDID ������ CRT��LCD �Լ�������
��ʾ��������ʹ�ã�������Ϊ EDID �ṩ�˼���������ʾ������ͨ��������
EDID ��128���ֽ���ɣ����»�������
0-7 ��ͷ��Ϣ ��8���ֽڣ���00 FF FF FF FF FF FF 00 ���
8-9������ID
10-11�� ��ƷID
12-15��32-bit���к�
16-17 ����������
18-19 �� EDID �汾
20-24 �� ��ʾ���Ļ�����Ϣ����Դ�����߶ȣ���ȣ�
25-34 �� ��ʾ������ɫ����
35-37 �� ��ʾ���Ļ���ʱ�򣬶�ʱ ���ֱ���
38-53 �� ��ʾ���ı�׼ʱ�򼰶�ʱ
54-125�� ��ʾ������ϸʱ�򼰶�ʱ
126�� ��չ��־λ��EDID-1.3�汾��Ҫ���ԣ�����Ϊ0
127�� �����ֵ֤
//*)
end;

procedure GetDisplayDevicePhysicalSize(AScreen: PWinScreen; AScreenDC: HDC);
var
  tmpDC: HDC;
//  tmpPixelX, tmpPixelY: integer;
//  tmpLogPixelX, tmpLogPixelY: integer;  
begin
  // ����GetDeviceCaps����������
  // ��Win7ϵͳ�¸ó���������׼ȷ
  // WinXPϵͳ�»����Ͽ�����ȷ����
  if 0 <> AScreenDC then
  begin
    // Windows Vista���ϲ�֧�ֵ��º���GetMonitorDisplayAreaSize
    
//    tmpPixelX := GetDeviceCaps(tmpDC, HORZRES); //����������
//    tmpPixelY := GetDeviceCaps(tmpDC, VERTRES);
//
//    tmpLogPixelX := GetDeviceCaps(tmpDC, LOGPIXELSX); //��ÿӢ�����
//    tmpLogPixelY := GetDeviceCaps(tmpDC, LOGPIXELSY); //��ÿӢ�����
    //��֤��ֵ�ǣ���HORZRES/VERTRES�ֱ�Ϊ800/600��1280/1024��1360/768ʱ��LOGPIXELSX/LOGPIXELSYһֱΪ96

    //HORZSIZE/HORZRES/LOGPIXELSX�ȡ�
    //�������ߵĹ�ϵͨ�����㣺HORZSIZE = 25.4 * HORZRES/LOGPIXELSX
//    // ����һ���豸��λ���ڶ���0.1mm
//    double scaleX = 254.0 / (double)GetDeviceCaps(dc.m_hAttribDC, LOGPIXELSX);
//    double scaleY = 254.0 / (double)GetDeviceCaps(dc.m_hAttribDC, LOGPIXELSY);
    AScreen.PhysicalSize.cx := GetDeviceCaps(AScreenDC, HORZSIZE);
    AScreen.PhysicalSize.cy := GetDeviceCaps(AScreenDC, VERTSIZE);
  end else
  begin
    //tmpDC := GetDC(0);
    tmpDC := CreateDCA('display', nil, nil, nil);
    if 0 <> tmpDC then
    begin
      try
        GetDisplayDevicePhysicalSize(AScreen, tmpDC);
      finally
        //ReleaseDC(0, tmpDC);
        DeleteDC(tmpDC);
      end;
    end;
  end;
  // ���ҵ�����һ�ַ�ʽ����ʾ��������ߴ类�洢��EDID
  // �����Ӵ�����������ֵ�ĸ�����ע����С�������ܽ���EDID��������Ķ���ʾ���Ŀ�Ⱥ͸߶�
end;

function GetDisplayDeviceSizeMM(AScreen: PWinScreen): double;
begin
  Result := Sqrt(
       AScreen.PhysicalSize.cx * AScreen.PhysicalSize.cx +
       AScreen.PhysicalSize.cy * AScreen.PhysicalSize.cy);
end;

function GetDisplayDeviceSizeInch(AScreen: PWinScreen): double; 
const
  MILLIMETRE_TO_INCH = 0.0393701; // ���׻��㵽Ӣ��
begin
  Result := GetDisplayDeviceSizeMM(AScreen) * MILLIMETRE_TO_INCH;
end;
{
  GetSystemMetrics                                                                                       _
    SM_ARRANGE  ��־����˵��ϵͳ��ΰ�����С������
      ARW_BOTTOMLEFT
    SM_CLEANBOOT ����ϵͳ������ʽ
      0 ��������
      1 ��ȫģʽ����
      2 ���簲ȫģʽ����
    SM_CMOUSEBUTTONS
      ����ֵΪϵͳ֧�ֵ������� ����0 ��ϵͳ��û�а�װ���
    SM_CXCURSOR, SM_CYCURSOR ����������ֵΪ��λ�ı�׼���Ŀ�Ⱥ͸߶�
    SM_CXFIXEDFRAME, SM_CYFIXEDFRAME Χ�ƾ��б��⵫�޷��ı�ߴ�Ĵ��ڣ�ͨ����һЩ�Ի��򣩵ı߿�ĺ��
    SM_CXFULLSCREEN, SM_CYFULLSCREEN ȫ��Ļ���ڵĴ�������Ŀ�Ⱥ͸߶�
    SM_CXSCREEN, SM_CYSCREEN ������Ϊ��λ�������Ļ�ߴ�
}

(*//
  //������ʾ��Ϊʡ��ģʽ
  SendMessage(m_hWnd, WM_SYSCOMMAND, SC_MONITORPOWER, 1);
  //�ر���ʾ��
  SendMessage(m_hWnd, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
  //����ʾ��
  SendMessage(m_hWnd, WM_SYSCOMMAND, SC_MONITORPOWER, -1);
//*)

procedure UpdateDisplayDevice();
var
  tmpDisplayDeviceA: TDeviceModeA;
begin
  //��ɫ���
  //if (m_ctrlBitsPerPixel.GetCurSel() == 0)
  tmpDisplayDeviceA.dmBitsPerPel := 16;
  //if (m_ctrlBitsPerPixel.GetCurSel() == 1)
  tmpDisplayDeviceA.dmBitsPerPel := 32;
  //�ֱ���
  //if (m_ctrlPixels.GetCurSel() == 0)
  tmpDisplayDeviceA.dmPelsWidth := 800;
  tmpDisplayDeviceA.dmPelsHeight := 600;
  //else if (m_ctrlPixels.GetCurSel() == 1)
  tmpDisplayDeviceA.dmPelsWidth := 1024;
  tmpDisplayDeviceA.dmPelsHeight := 768;
  //ˢ����
  //if (m_ctrlDispalyFrequencry.GetCurSel() == 0)
  tmpDisplayDeviceA.dmDisplayFrequency := 60;
  //else if (m_ctrlDispalyFrequencry.GetCurSel() == 1)
  tmpDisplayDeviceA.dmDisplayFrequency := 75;

  tmpDisplayDeviceA.dmSize := sizeof(tmpDisplayDeviceA);
  tmpDisplayDeviceA.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY;

  //������ʾ����
  if (DISP_CHANGE_SUCCESSFUL = ChangeDisplaySettings(tmpDisplayDeviceA, 0)) then
  begin
    //���µ����ò�������ע���
    Windows.ChangeDisplaySettingsA(tmpDisplayDeviceA, CDS_UPDATEREGISTRY);
  end else
  begin
    //�ָ�Ĭ������
    FillChar(tmpDisplayDeviceA, SizeOf(tmpDisplayDeviceA), 0);
    Windows.ChangeDisplaySettings(tmpDisplayDeviceA, 0);
  end;
end;

end.
