unit SQLite3WrapBlob;

interface
               
{$IFDEF MSWINDOWS}

uses
  Windows, Classes, SQLite3Wrap, SQLite3;
  
type
  { TSQLite3BlobStream class }
  TSQLite3BlobStream = class(TStream)
  private
    FHandle: SQLite3.PSQLite3Blob;
    FOwnerDatabase: TSQLite3Database;
    FTable: WideString;
    FColumn: WideString;
    FRowID: Int64;
    FWriteAccess: Boolean;

    FCurrentThreadID: Cardinal;
    FSize: Integer;
    FPosition: Integer;
    FBusyMode: TSQLite3BusyMode;
    FLastOpenTime: Cardinal;

    function  IsOpenCloseMode: Boolean;
    procedure DoOpenBlob;
    procedure DoCloseBlob;
    procedure SetBusyMode(const Value: TSQLite3BusyMode);
  protected
    procedure DoCheckBusy;
    procedure SetSize(NewSize: Longint); override;
  public
    constructor Create(OwnerDatabase: TSQLite3Database; const Table, Column: WideString; const RowID: Int64; WriteAccess: Boolean = True; BusyMode: TSQLite3BusyMode = bmAuto);
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;

    procedure Reopen;
    property BusyMode: TSQLite3BusyMode read FBusyMode write SetBusyMode;
  end;


  { TSQLite3BlobHandler class }

  TSQLite3BlobHandler = class(TObject)
  public
    FHandle: PSQLite3Blob;
    FOwnerDatabase: TSQLite3Database;
  public
    constructor Create(OwnerDatabase: TSQLite3Database; const Table, Column: WideString; const RowID: Int64; const WriteAccess: Boolean = True);
    destructor Destroy; override;

    function Bytes: Integer;
    procedure Read(Buffer: Pointer; const Size, Offset: Integer);
    procedure Write(Buffer: Pointer; const Size, Offset: Integer);

    property Handle: PSQLite3Blob read FHandle;
    property OwnerDatabase: TSQLite3Database read FOwnerDatabase;
  end;

  function BlobOpen(ASQLite3DB: TSQLite3Database; const Table, Column: WideString; const RowID: Int64; const WriteAccess: Boolean = True): TSQLite3BlobHandler;
  function BlobOpenStream(ASQLite3DB: TSQLite3Database; const Table, Column: WideString; const RowID: Int64; const WriteAccess: Boolean = True; BusyMode: TSQLite3BusyMode = bmAuto): TStream; //TSQLite3BlobStream;

{$ENDIF}

implementation
           
{$IFDEF MSWINDOWS}

uses
  SQLite3Utils;

  
function BlobOpenStream(ASQLite3DB: TSQLite3Database; const Table, Column: WideString;
  const RowID: Int64; const WriteAccess: Boolean; BusyMode: TSQLite3BusyMode): TStream; //TSQLite3BlobStream;
begin
  Result := TSQLite3BlobStream.Create(ASQLite3DB, Table, Column, RowID, WriteAccess, BusyMode);
end;

{ TSQLite3BlobHandler }

function TSQLite3BlobHandler.Bytes: Integer;
begin
  Result := _sqlite3_blob_bytes(FHandle);
end;

constructor TSQLite3BlobHandler.Create(OwnerDatabase: TSQLite3Database; const Table,
  Column: WideString; const RowID: Int64; const WriteAccess: Boolean);
begin
  FOwnerDatabase := OwnerDatabase;
  FOwnerDatabase.CheckHandle;
  FOwnerDatabase.Check(
    _sqlite3_blob_open(FOwnerDatabase.FHandle, 'main', PAnsiChar(StrToUTF8(Table)),
      PAnsiChar(StrToUTF8(Column)), RowID, Ord(WriteAccess), FHandle)
  );
  FOwnerDatabase.FBlobHandlerList.Add(Self);
end;

destructor TSQLite3BlobHandler.Destroy;
begin
  FOwnerDatabase.FBlobHandlerList.Remove(Self);
  _sqlite3_blob_close(FHandle);
  inherited;
end;

procedure TSQLite3BlobHandler.Read(Buffer: Pointer; const Size,
  Offset: Integer);
begin
  FOwnerDatabase.Check(_sqlite3_blob_read(FHandle, Buffer, Size, Offset));
end;

procedure TSQLite3BlobHandler.Write(Buffer: Pointer; const Size,
  Offset: Integer);
begin
  FOwnerDatabase.Check(_sqlite3_blob_write(FHandle, Buffer, Size, Offset));
end;
  
{ TSQLite3BlobStream }

function BlobOpen(ASQLite3DB: TSQLite3Database; const Table, Column: WideString;
  const RowID: Int64; const WriteAccess: Boolean): TSQLite3BlobHandler;
begin
  Result := TSQLite3BlobHandler.Create(ASQLite3DB, Table, Column, RowID, WriteAccess);
end;

constructor TSQLite3BlobStream.Create(OwnerDatabase: TSQLite3Database;
  const Table, Column: WideString; const RowID: Int64;
  WriteAccess: Boolean = True; BusyMode: TSQLite3BusyMode = bmAuto);
begin
  FOwnerDatabase := OwnerDatabase;
  FOwnerDatabase.CheckHandle;

  FTable := Table;
  FColumn := Column;
  FRowID := RowID;
  FWriteAccess := WriteAccess;
  FBusyMode := BusyMode;

  FCurrentThreadID := GetCurrentThreadId;
  DoOpenBlob; // 打开一下，至少需要先得到BlobSize
  if IsOpenCloseMode then
    DoCloseBlob;
  FOwnerDatabase.DoAddBlobStream(Self);
end;

destructor TSQLite3BlobStream.Destroy;
begin
  FOwnerDatabase.DoRemoveBlobStream(Self);
  DoCloseBlob;

  inherited;
end;

procedure TSQLite3BlobStream.DoCheckBusy;
begin
  // 等主线程不忙了，子线程里面再干活
  if G_SqliteMainBusy then
  begin
    if FCurrentThreadID <> MainThreadID then
    begin
      DoCloseBlob;
      repeat
        G_SqliteMainBusy := False;
        Sleep(1)
      until not G_SqliteMainBusy;
      DoOpenBlob;
    end;
  end;
end;

procedure TSQLite3BlobStream.DoCloseBlob;
begin
  if FHandle <> nil then
  begin
    _sqlite3_blob_close(FHandle);
    FHandle := nil;
  end;
end;

procedure TSQLite3BlobStream.DoOpenBlob;
begin
  if FHandle <> nil then
    Exit;

  FOwnerDatabase.Check(
    _sqlite3_blob_open(FOwnerDatabase.FHandle, 'main', PAnsiChar(SQLite3Utils.StrToUTF8(FTable)),
      PAnsiChar(StrToUTF8(FColumn)), FRowID, Ord(FWriteAccess), FHandle)
  );
  FSize := _sqlite3_blob_bytes(FHandle);
  FLastOpenTime := GetTickCount;
end;

function TSQLite3BlobStream.IsOpenCloseMode: Boolean;
begin
  Result := (FBusyMode = bmOpenClose) or
            ((FBusyMode = bmAuto) and (FCurrentThreadID <> MainThreadID));
end;

function TSQLite3BlobStream.Read(var Buffer; Count: Integer): Longint;
begin
  DoCheckBusy;

  if IsOpenCloseMode then
    DoOpenBlob;
  FOwnerDatabase.Check(_sqlite3_blob_read(FHandle, @Buffer, Count, FPosition));
  if IsOpenCloseMode then
    DoCloseBlob;

  Inc(FPosition, Count);
  Result := Count;
end;

procedure TSQLite3BlobStream.Reopen;
begin
  DoCloseBlob;
  DoOpenBlob;
end;

function TSQLite3BlobStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

procedure TSQLite3BlobStream.SetBusyMode(const Value: TSQLite3BusyMode);
begin
  if FBusyMode <> Value then
  begin
    FBusyMode := Value;

    if IsOpenCloseMode then
      DoCloseBlob
    else
      DoOpenBlob;
  end;
end;

procedure TSQLite3BlobStream.SetSize(NewSize: Integer);
begin
  raise ESQLite3Error.Create('TSQLite3BlobStream.SetSize is not support');
end;

function TSQLite3BlobStream.Write(const Buffer; Count: Integer): Longint;
begin
  DoCheckBusy;

  if IsOpenCloseMode then
    DoOpenBlob;
  FOwnerDatabase.Check(_sqlite3_blob_write(FHandle, @Buffer, Count, FPosition));
  if IsOpenCloseMode then
    DoCloseBlob;
  Inc(FPosition, Count);
  Result := Count;
end;
{$ENDIF}

end.
