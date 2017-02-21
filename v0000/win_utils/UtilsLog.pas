{------------------------------------------------------------------------------}
{ SDLogUtils.pas for SDShell                                                   }
{------------------------------------------------------------------------------}
{ ��Ԫ����: ��־���ߺ�����Ԫ                                                   }
{ ��Ԫ����: ʢ������ ���� (zhangyang@snda.com)                                 }
{ �ο��ĵ�:                                                                    }
{ ��������: 2005-12-05                                                         }
{------------------------------------------------------------------------------}
{ ��־ģ�鹦�ܽ���:                                                            }
{                                                                              }
{   * ������Ԫ������ѭ�����ã����ڶ����Ŀ��ֱ������                           }
{   * �Զ������߳���־������ʾ                                                 }
{   * ����־��Ϊ��ͨ��־���쳣��־���࣬���㶨λ����                           }
{   * ��־�ļ����ֱ�Ϊ(����ΪSDShell.exe): SDShell.log �� SDShellErr.log       }
{   * �ṩ�쳣��Ϣ��־���� LogException                                        }
{   * ��־�ļ�����ָ����С֮���Զ����´ν�����������ʱɾ��                     }
{   * ��ͨ�� SDDebugViewer.exe ��ʱ�鿴����ϸ��                                }
{                                                                              }
{ Log��־����:                                                                 }
{                                                                              }
{ procedure Log(const AMsg: ansistring);                            // Logһ����Ϣ }
{ procedure LogException(E: Exception; const AMsg: ansistring = '');// Log�쳣���� }
{ procedure LogWarning(const AMsg: ansistring);                     // Log������Ϣ }
{ procedure LogError(const AMsg: ansistring);                       // Log������Ϣ }
{ procedure LogWithTag(const AMsg: ansistring; const ATag: ansistring); // Log�ӱ��   }
{ procedure LogSeparator;                                       // Log�ָ���   }
{ procedure LogEnterProc(const AProcName: ansistring);              // Log������� }
{ procedure LogLeaveProc(const AProcName: ansistring);              // Log�˳����� }
{                                                                              }
{------------------------------------------------------------------------------}
{ �޸���ʷ��                                                                   }
(* 2007.01.31 liaofeng                                                          }
{   ��д����־ʱ�����жϣ����д��Ĵ�������һ�����������Զ��ضϻ���д��־     }
{   ������������ѡ�$DEFINE LOGTRUNCFILE������־��������ʱ�Ƿ��Զ��ض�(��д  }
{   ��־���������д���һ����־��Ĭ�ϱ���100K)��δ����ʱ��д�ļ�              }
 * 2007.05.29
    �޸�Ϊ��������ʼ����־�ļ������ҿ��Բ�����͸�����뿪�س��׹ر���־�ļ���Ҳ����
    �ڳ�����ر���־�ļ���


{-----------------------------------------------------------------------------*)
unit UtilsLog;

{$WARN SYMBOL_PLATFORM OFF}


{$DEFINE LOGTOFILE}           // �Ƿ�LOG���ļ�
{.$DEFINE LOGTODEBUGGER}      // �Ƿ�LOG��DebugView
{$DEFINE LOGSOURCEFILENAME}   // �Ƿ���LOG�ļ�����ʾԴ��������

{$DEFINE REROUTEASSERT}       // �Ƿ��滻Assert
{$DEFINE ASSERTMSGLOG}        // ��Assert��ϢLog���ļ�
{.$DEFINE ASSERTMSGSHOW}      // ��Assert��Ϣͨ��MessageBox��ʾ����
{$DEFINE ASSERTMSGRAISE}      // ��Assert��ϢRaise����

{.$DEFINE LOGERRORRAISE}       // ��LogError��LogException����Ϣraise����

{$DEFINE LOGTRUNCFILE}        // ������־��С����ʱ�ض��ļ���������д�ļ�

interface

{$IFDEF LOG}

uses
  Windows, SysUtils;

type
  PLogFile        = ^TLogFile;
  TLogFile        = record
    Initialized   : Boolean; { �Ƿ��ѳ�ʼ������ }
    AllowLogToFile: Boolean;// = True;
    LogFileNameMode: integer;
    LastLogTick   : DWORD;
    LogLock       : TRTLCriticalSection;                 { ��־д���� }
    FileHandle    : THandle;
    ErrFileHandle : THandle;   { ��־�ļ���� }
    LogWriteCount : Integer;    { ��־��д����� }
    FileName      : AnsiString;
    ErrorFileName : AnsiString; { �쳣��־�ļ���ȫ·�� }
  end;

{ Logϵ���������}
procedure Log(const ASourceFileName, AMsg: string; ALogFile: PLogFile = nil);                             // Logһ����Ϣ   
procedure SDLog(const ASourceFileName, AMsg: string; ALogFile: PLogFile = nil);                             // Logһ����Ϣ
procedure LogException(const ASourceFileName: string; E: Exception;
    ALogFile: PLogFile = nil;
    const AMsg: string = ''; ARaise: Boolean = False); // Log�쳣����
procedure LogWarning(const ASourceFileName, AMsg: string;
    ALogFile: PLogFile = nil);                      // Log������Ϣ
procedure LogError(const ASourceFileName, AMsg: string;
    ALogFile: PLogFile = nil; ErrorCode: Integer = 0); overload;    // Log������Ϣ
procedure LogError(const ASourceFileName, AMsg: string; E: Exception;
    ALogFile: PLogFile = nil; ARaise: Boolean=False); overload;              // Log������Ϣ
procedure LogWithTag(const ASourceFileName, AMsg, ATag: string;
    ALogFile: PLogFile = nil);  // Log�ӱ��
procedure LogSeparator(const ASourceFileName: string; ALogFile: PLogFile = nil); // Log�ָ���
procedure LogEnterProc(const ASourceFileName, AProcName: string;
    ALogFile: PLogFile = nil);               // Log�������
procedure LogLeaveProc(const ASourceFileName, AProcName: string;
    ALogFile: PLogFile = nil);               // Log�˳�����

procedure InitLogFileHandle(ALogFile: PLogFile = nil);
procedure SurfaceLogError(const ASource, AMsg: string; E: Exception;
    ALogFile: PLogFile = nil);

procedure InitLogFiles(ALogFile: PLogFile);
procedure CloseLogFiles(ALogFile: PLogFile = nil);

var
  G_LogFile          : TLogFile;
  G_CurrentProcessId : Cardinal = 0;                   { ��ǰ����Id }
//  G_MainThreadId     : Cardinal = 0;                       { ���߳�Id }

{$ENDIF}

implementation

{$IFDEF LOG}               
procedure SDLog(const ASourceFileName, AMsg: string; ALogFile: PLogFile = nil);                             // Logһ����Ϣ
begin
  Log(ASourceFileName, AMsg, ALogFile);
end;
//uses
//  IniFiles;

const
  { �����־�ļ���С,�������´�����ʱ�Զ�ɾ�����¿�ʼ }
  cMaxLogFileSize    = 1024 * 1024 * 256;
  { ���д��Ĵ����������Զ��ض���д }
  cMaxLogWriteCount  = 6 * 1000 * 1000;
  { �Զ��ض�ʱ�������д����־�Ĵ�С }
  cMaxLogSaveSize    = 1024 * 100;

procedure InitLogFileHandle(ALogFile: PLogFile);
begin
  if ALogFile.Initialized then
  begin
    try
      DeleteCriticalSection(ALogFile.LogLock);
    except
    end;
    ALogFile.Initialized := False;
  end;     
  if ALogFile.FileHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ALogFile.FileHandle);
    ALogFile.FileHandle := INVALID_HANDLE_VALUE;
  end;
  
  if ALogFile.ErrFileHandle <> INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ALogFile.ErrFileHandle);
    ALogFile.ErrFileHandle := INVALID_HANDLE_VALUE;
  end;
end;
  
function GetFileSize(const AFileName: string): Int64;
var
  HFileRes: THandle;
begin
  Result := 0;
  HFileRes := CreateFile(PChar(@AFileName[1]), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if HFileRes <> INVALID_HANDLE_VALUE then
  begin
    Result := Windows.GetFileSize(HFileRes, nil);
    CloseHandle(HFileRes);
  end;
end;

procedure InitLogFiles(ALogFile: PLogFile);
var
  s: ansistring;
//  ini: TIniFile;
begin
{$IFDEF LOGTOFILE}
  if not ALogFile.Initialized then
  begin
    if not ALogFile.AllowLogToFile then
      Exit;
//    ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
//    try
//      logmode := strtointdef(ini.ReadString('Log', 'LogMode', '0'), 0);
//    finally
//      ini.Free;
//    end;
    if ALogFile.FileName = '' then
    begin
      case ALogFile.LogFileNameMode of
        0: begin
          ALogFile.FileName := ansistring(ChangeFileExt(ParamStr(0), '.log'));
          ALogFile.ErrorFileName := ansistring(ChangeFileExt(ParamStr(0), '.Err.log'));
        end;
        1: begin
          s := ansistring(trim(ParamStr(0)));
          s := copy(s, 1, length(s) - 4) + '_' + AnsiString(formatdatetime('mmdd_hhmmss', now()));
          ALogFile.FileName := s + '.log';
          ALogFile.ErrorFileName := s + 'Err.log';
        end;
        2: begin
          ALogFile.Initialized := True;
          ALogFile.AllowLogToFile := False;
          exit;
        end;
      end;
    end;
    ALogFile.Initialized := true;
    try
      InitializeCriticalSection(ALogFile.LogLock);
    except
    end;
//      (ALogFile.FileHandle <> INVALID_HANDLE_VALUE) and
//                     (ALogFile.FileHandle <> 0) and
//                     (ALogFile.ErrFileHandle <> INVALID_HANDLE_VALUE) and
//                     (ALogFile.ErrFileHandle <> 0);
  end;
{$ENDIF}
end;

procedure CloseLogFiles(ALogFile: PLogFile);
begin
  // ��ʱ������
//  Exit;
  if ALogFile <> nil then
  begin
    if ALogFile.Initialized then
    begin
      if (ALogFile.FileHandle <> INVALID_HANDLE_VALUE) then
      begin
        try
        if CloseHandle(ALogFile.FileHandle) then
        begin
          ALogFile.FileHandle := 0;
        end;
        except
        end;
      end;
      if (ALogFile.ErrFileHandle <> INVALID_HANDLE_VALUE) then
      begin
        try
          if CloseHandle(ALogFile.ErrFileHandle) then
          begin
            ALogFile.ErrFileHandle := 0;
          end;
        except
        end;
      end;
      ALogFile.Initialized := False;

  // �����ܽ���
      try
        DeleteCriticalSection(ALogFile.LogLock);
      except
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// _Log - д����Ϣ����־�ļ�(��ָ���Ƿ�ͬʱд���쳣��־��)
//------------------------------------------------------------------------------
// ��������: Msg      = ��־��Ϣ
//           IsError  = �Ƿ�ͬʱ��¼���쳣��־��
// �� �� ֵ: ��
// ����ʱ��: 2005-12-5 22:29:51
//------------------------------------------------------------------------------
procedure _Log(const SourceFileName, AMsg: String;
  ALogFile: PLogFile;
  IsError: Boolean = False);
var
//  hFile: THandle;
  BytesWrite: Cardinal;
  LocalTime: TSystemTime;
//  LogFileName: ansistring;
  LogFileHandle: THandle;
  CurrentThreadId: Cardinal;
  IsThreadMsg: Boolean;
  ErrMsg:string;
  T: Int64;
  L: Integer;
{$IFDEF LOGTRUNCFILE}
  SaveBuffer: PChar;
{$ENDIF}
  LogInfo: ansistring;
  tmpMsg: ansistring;
  FileSize: DWORD;
begin
{$IFDEF LOGTOFILE}
  if ALogFile = nil then
  begin
    ALogFile := @G_LogFile;
  end;
  InitLogFiles(ALogFile);
  if not ALogFile.Initialized then
  begin
    Exit; //InitLogFiles;
  end;
  if not ALogFile.AllowLogToFile then
  begin
    Exit;
  end;
  tmpMsg := ansistring(AMsg);
  L:= Length(tmpMsg);
  if L<65536 then //����̫���ˡ�
  begin                   
    {$IFDEF LOGTRUNCFILE}
    SaveBuffer:= @tmpMsg[1];
    {$ENDIF}
//    if SaveBuffer[L] <> #0 then
//      Exit;
  end else
  begin
    Exit;
  end;

  CurrentThreadId := GetCurrentThreadId;
  IsThreadMsg := MainThreadId <> CurrentThreadId;

  if IsError then
  begin
    if (ALogFile.ErrFileHandle = 0) or
       (ALogFile.ErrFileHandle = INVALID_HANDLE_VALUE) then
    begin
      ALogFile.ErrFileHandle := CreateFileA(PAnsiChar(ALogFile.ErrorFileName),
          GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
        OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if ALogFile.ErrFileHandle <> INVALID_HANDLE_VALUE then
      begin
        if Windows.GetFileSize(ALogFile.ErrFileHandle, @FileSize) > cMaxLogFileSize then
          SetEndOfFile(ALogFile.ErrFileHandle);
        SetFilePointer(ALogFile.ErrFileHandle, 0, nil, FILE_END);
      end;
    end;
    LogFileHandle := ALogFile.ErrFileHandle
  end else
  begin
    if (ALogFile.FileHandle = 0) or
       (ALogFile.FileHandle = INVALID_HANDLE_VALUE) then
    begin
      ALogFile.FileHandle := CreateFileA(PAnsiChar(ALogFile.FileName), GENERIC_WRITE
        {$IFDEF LOGTRUNCFILE}or GENERIC_READ{$ENDIF},
        FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
        OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if ALogFile.FileHandle <> INVALID_HANDLE_VALUE then
      begin
        if Windows.GetFileSize(ALogFile.FileHandle, @FileSize) > cMaxLogFileSize then
        begin
          {$IFDEF LOGTRUNCFILE}
          InterlockedExchange(ALogFile.LogWriteCount, cMaxLogWriteCount);  // ��Ϊ�����־д��������´�д�ͻ��Զ��ض���
          {$ELSE}
          SetEndOfFile(G_LogFileHandle)
          {$ENDIF}
        end else
        begin
          InterlockedExchange(ALogFile.LogWriteCount, FileSize div 100);   // ���¹�����д����־����
        end;
        SetFilePointer(ALogFile.FileHandle, 0, nil, FILE_END);
      end;
    end;
    LogFileHandle := ALogFile.FileHandle;
    // ���д������Ƿ��ѳ������ƣ��������Զ��ضϻ���д
    if InterlockedIncrement(ALogFile.LogWriteCount) > cMaxLogWriteCount then
    begin
      if InterlockedExchange(ALogFile.LogWriteCount, 0) > cMaxLogWriteCount then
      begin
        {$IFDEF LOGTRUNCFILE}
        GetMem(SaveBuffer, cMaxLogSaveSize);
        try
          SetFilePointer(LogFileHandle, -cMaxLogSaveSize, nil, FILE_END);
          ReadFile(LogFileHandle, SaveBuffer^, cMaxLogSaveSize, BytesWrite, nil);
        {$ENDIF}
          SetFilePointer(LogFileHandle, 0, nil, FILE_BEGIN);
          SetEndOfFile(LogFileHandle);
        {$IFDEF LOGTRUNCFILE}
          WriteFile(LogFileHandle, SaveBuffer^, BytesWrite, BytesWrite, nil);
        except
        end;
        FreeMem(SaveBuffer);
        {$ENDIF}
      end;
    end;
  end;
//    LogFileName := G_LogErrorFileName else
//    LogFileName := G_LogFileName;

//  hFile := CreateFileA(PAnsiChar(LogFileName), GENERIC_WRITE, FILE_SHARE_READ, nil,
//    OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
//  if hFile = INVALID_HANDLE_VALUE then Exit;
  try
{$IFDEF LOGSOURCEFILENAME}
    LogInfo := '[' + ansistring(SourceFileName) + ']' + tmpMsg;
{$ELSE}
    LogInfo := Msg;
{$ENDIF LOGSOURCEFILENAME}
    if IsThreadMsg then
    begin
      LogInfo := AnsiString(Format(#9'[%.8x] %s', [CurrentThreadId, LogInfo]));
    end;
//    SetFilePointer(LogFileHandle, 0, nil, FILE_END);
    GetLocalTime(LocalTime);

    QueryPerformanceCounter(T);
    T:= T mod 1000000;
    LogInfo := ansistring(LogInfo + #13#10);
    //(*//
    try
      LogInfo := ansistring(Format('(%.8x) %.4d-%.2d-%.2d %.2d:%.2d:%.2d.%.3d.%.6d=%s'#13#10, [
        G_CurrentProcessId,
        LocalTime.wYear, LocalTime.wMonth, LocalTime.wDay,
        LocalTime.wHour, LocalTime.wMinute, LocalTime.wSecond,
        LocalTime.wMilliseconds, T,
        LogInfo]));
    except
      LogInfo := '';
    end;
    //*)

//    EnterCriticalSection(G_LogLock);
    try
      try
      SetFilePointer(LogFileHandle, 0, nil, FILE_END);

      WriteFile(LogFileHandle, LogInfo[1], Length(LogInfo), BytesWrite, nil);
      except
        on E: Exception do
        begin
          // ��һ����־����ı���
          ErrMsg := '��־����:' + E.Message + #13#10;
          WriteFile(LogFileHandle, ErrMsg[1], Length(ErrMsg), BytesWrite, nil);
        end;
      end;
//      FlushFileBuffers(LogFileHandle);
    finally
//      LeaveCriticalSection(G_LogLock);
    end;
  finally
//    CloseHandle(hFile);
  end;

  if IsError then
  begin
    _Log(SourceFileName, string(tmpMsg), ALogFile, False);
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// _LogE - ��¼������Ϣ����־�ļ�(ͬʱд����������־�ļ���)
//------------------------------------------------------------------------------
// ��������: Msg   = �����쳣�Ĺ�����(��������־����)
//           E     = �쳣����
// �� �� ֵ: ��
// ����ʱ��: 2005-12-5 22:30:54
//------------------------------------------------------------------------------
procedure _LogE(const SourceFileName, Msg: ansistring; E: Exception; ALogFile: PLogFile);
var
  LogInfo: ansistring;
begin
  LogInfo := ansistring(Format('!!! Runtime Exception: %s (ClassName: %s; Msg: %s)', [Msg, E.ClassName, E.Message]));
  _Log(string(SourceFileName), string(LogInfo), ALogFile, True);
end;

//------------------------------------------------------------------------------
// DebugOut - ���������Ϣ��
//------------------------------------------------------------------------------
// ��������: const S: ansistring
// �� �� ֵ: ��
// �д�����:
// ����ʱ��: 2006-5-9 12:05:15
//------------------------------------------------------------------------------
procedure DebugOut(const SourceFileName, S: ansistring);
begin
{$IFDEF LOGTODEBUGGER}
  OutputDebugStringA(PAnsiChar(Format('[%s] %s', [SourceFileName, S])));
{$ENDIF}
end;


// Log ϵ��������� == Start ==
procedure Log(const ASourceFileName, AMsg: String; ALogFile: PLogFile);                             // Logһ����Ϣ
begin
  DebugOut(ansistring(ASourceFileName), ansistring(AMsg));
  _Log(ASourceFileName, AMsg, ALogFile);
end;

procedure LogException(const ASourceFileName: String; E: Exception;
    ALogFile: PLogFile = nil;
    const AMsg: String='';
    ARaise: Boolean = False);
begin
  LogError(ASourceFileName, AMsg, E, ALogFile, ARaise);
//  DebugOut(ASourceFileName, Format('!! EXCEPTION [%s]: %s; %s', [E.ClassName, E.Message, AMsg]));
//  _LogE(ASourceFileName, AMsg, E);
  {$IFDEF LOGERRORRAISE}
    // Ϊ����鿴����
//    raise E;
  {$ENDIF}
end;

procedure LogWithTag(const ASourceFileName, AMsg: String; const ATag: String;
   ALogFile: PLogFile);
var
  S: String;
begin
  S := Format('[tag=%s] %s', [ATag, AMsg]);
  DebugOut(ansistring(ASourceFileName), ansistring(S));
  _Log(ASourceFileName, S, ALogFile);
end;

procedure LogWarning(const ASourceFileName, AMsg: string; ALogFile: PLogFile);
var
  S: ansistring;
begin
  S := '[WARNING] ' + AnsiString(AMsg);
  DebugOut(ansistring(ASourceFileName), S);
  _Log(ASourceFileName, string(S), ALogFile, True);
end;

procedure LogError(const ASourceFileName, AMsg: string;
    ALogFile: PLogFile = nil; ErrorCode: Integer = 0);
var
  S: ansistring;
begin
  if ErrorCode <> 0 then
    S := '[ERROR ErrorCode=' + ansistring(IntToStr(ErrorCode)) + '] ' + ansistring(AMsg)
  else
    S := '[ERROR] ' + ansistring(AMsg);
  DebugOut(ansistring(ASourceFileName), S);
  _Log(ASourceFileName, string(S), ALogFile, True);
  {$IFDEF LOGERRORRAISE}
    // Ϊ����鿴����
    // Ϊ�����ִ�������ʹ��HelpContext��ʶ
    raise Exception.Create('[' + ASourceFileName + ']' + AMsg).HelpContext = ErrorCode;
  {$ENDIF}
end;

procedure LogError(const ASourceFileName, AMsg: string; E: Exception;
    ALogFile: PLogFile = nil;
    ARaise: Boolean = False); overload;              // Log������Ϣ
var
  S: ansistring;
begin
  S:= ansistring(Format('!!! EXCEPTION [%s][%d]: %s; %s', [E.ClassName, E.HelpContext, E.Message, AMsg]));
  DebugOut(ansistring(ASourceFileName), S);
  _Log(ASourceFileName, string(S), ALogFile, True);
  {$IFDEF LOGERRORRAISE}
    // Ϊ����鿴����
    // Ϊ�����ִ�������ʹ��HelpContext��ʶ
    if ARaise then
      raise E;
  {$ENDIF}
end;

procedure LogSeparator(const ASourceFileName: string; ALogFile: PLogFile);
begin
  DebugOut(ansistring(ASourceFileName), '-----------------------');
  _Log(ASourceFileName, '-----------------------', ALogFile);
end;

procedure LogEnterProc(const ASourceFileName, AProcName: string; ALogFile: PLogFile);
var
  S: ansistring;
begin
  S := '[ENTERPROC] ' + ansistring(AProcName);
  DebugOut(ansistring(ASourceFileName), S);
  _Log(ASourceFileName, string(S), ALogFile);
end;

procedure LogLeaveProc(const ASourceFileName, AProcName: string; ALogFile: PLogFile);
var
  S: ansistring;
begin
  S := '[LEAVEPROC] ' + ansistring(AProcName);
  DebugOut(ansistring(ASourceFileName), S);
  _Log(ASourceFileName, string(S), ALogFile);
end;

procedure AssertErrorHandler(const Msg, Filename: string;
  LineNumber: Integer; ErrorAddr: Pointer);
begin
{$IFDEF ASSERTMSGSHOW} // ��Assert��Ϣͨ��MessageBox��ʾ����
  MessageBox(0, PAnsiChar(Format('%s (%s, line %d, address $%x)',
    [Msg, Filename, LineNumber, Pred(Integer(ErrorAddr))]))
    , '��־��ʾ', MB_OK + MB_ICONSTOP);
{$ENDIF}

{$IFDEF ASSERTMSGLOG} // ��Assert��ϢLog���ļ�
  Log(Format('%s, line %d, address $%x',
    [ExtractFileName(Filename), LineNumber, Pred(Integer(ErrorAddr))])
    , Msg, @G_LogFile);
{$ENDIF}

{$IFDEF ASSERTMSGRAISE}
  raise Exception.Create(Format('%s (%s, line %d, address $%x)',
    [Msg, Filename, LineNumber, Pred(Integer(ErrorAddr))]));
{$ENDIF}
end;

procedure RerouteAssertions;
begin
  System.AssertErrorProc := AssertErrorHandler;
end;

procedure SurfaceLogError(const ASource, AMsg: String; E: Exception; ALogFile: PLogFile = nil);
begin
  if E<>nil then
    LogError(ASource, AMsg, E, ALogFile, False)
  else
    LogError(ASource, AMsg, ALogFile);
end;

initialization
  // �滻ԭ�е�Assert
//  G_MainThreadId := GetCurrentThreadId;
  FillChar(G_LogFile, SizeOf(G_LogFile), 0);
  G_LogFile.AllowLogToFile := true;
  G_LogFile.FileHandle := INVALID_HANDLE_VALUE;
  G_LogFile.ErrFileHandle := INVALID_HANDLE_VALUE;
  {$IFDEF REROUTEASSERT}
  RerouteAssertions;
  {$ENDIF}

//finalization
//  CloseLogFiles(@G_LogFile);
{$ENDIF}

end.
