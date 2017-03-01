unit QuickList_Int64;

interface

uses
  QuickSortList;

type
  {-----------------------------------}
  PALInt64ListItem = ^TALInt64ListItem;
  TALInt64ListItem = record
    FInt64: Int64;
    FObject: TObject;
  end;

  {----------------------------------------}
  TALInt64List = class(TALBaseQuickSortList)
  public
    function  GetItem(AIndex: Integer): Int64;
    procedure SetItem(AIndex: Integer; const AItemKey: Int64);
    function  GetObject(AIndex: Integer): TObject;
    procedure PutObject(AIndex: Integer; AObject: TObject);
  public
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure InsertItem(AIndex: Integer; const AitemKey: Int64; AObject: TObject);
    function  CompareItems(const Index1, Index2: Integer): Integer; override;
  public
    function  IndexOf(AItemKey: Int64): Integer;
    function  IndexOfObject(AObject: TObject): Integer;
    function  Add(const AItemKey: Int64): Integer;
    Function  AddObject(const AItemKey: Int64; AObject: TObject): Integer;
    function  Find(AitemKey: Int64; var AIndex: Integer): Boolean;
    procedure Insert(AIndex: Integer; const AitemKey: Int64);
    procedure InsertObject(AIndex: Integer; const AitemKey: Int64; AObject: TObject);
    property  Items[Index: Integer]: Int64 read GetItem write SetItem; default;
    property  Objects[Index: Integer]: TObject read GetObject write PutObject;
  end;

implementation


{****************************************************}
function TALInt64List.Add(const AItemKey: Int64): Integer;
begin
  Result := AddObject(AItemKey, nil);
end;

{****************************************************************************}
function TALInt64List.AddObject(const AItemKey: Int64; AObject: TObject): Integer;
begin
  if not Sorted then
  begin
    Result := FCount
  end else if Find(AItemKey, Result) then
  begin
    case Duplicates of
      lstdupIgnore: Exit;
      lstdupError: Error(@SALDuplicateItem, 0);
    end;
  end;
  InsertItem(Result, AItemKey, AObject);
end;

{*************************************************************************************}
procedure TALInt64List.InsertItem(AIndex: Integer; const AitemKey: Int64; AObject: TObject);
var
  tmpListItem: PALInt64ListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInt64 := AitemKey;
  tmpListItem^.FObject := AObject;
  try
    inherited InsertItem(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{*************************************************************************}
function TALInt64List.CompareItems(const Index1, Index2: integer): Integer;
var
  tmpInt64: Int64;
begin
  tmpInt64 := PALInt64ListItem(Get(Index1))^.FInt64 - PALInt64ListItem(Get(Index2))^.FInt64;
  if tmpInt64 < 0 then
    result := -1
  else if tmpInt64 > 0 then
    result := 1
  else
    result := 0;
end;

{*******************************************************************}
function TALInt64List.Find(AitemKey: Int64; var AIndex: Integer): Boolean;
var L, H, I, C: Integer;

  {--------------------------------------------}
  Function _CompareInt64(D1,D2: Int64): Integer;
  Begin
    if D1 < D2 then result := -1
    else if D1 > D2 then result := 1
    else result := 0;
  end;

begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := _CompareInt64(GetItem(I), AitemKey);
    if C < 0 then
    begin
      L := I + 1
    end else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> lstdupAccept then
          L := I;
      end;
    end;
  end;
  AIndex := L;
end;

{***************************************************}
function TALInt64List.GetItem(AIndex: Integer): Int64;
begin
  Result := PALInt64ListItem(Get(Aindex))^.FInt64
end;

{**************************************************}
function TALInt64List.IndexOf(AItemKey: Int64): Integer;
begin
  if not Sorted then
  Begin
    Result := 0;
    while (Result < FCount) and (GetItem(result) <> AItemKey) do
    begin
      Inc(Result);
    end;
    if Result = FCount then
    begin
      Result := -1;
    end;
  end else
    if not Find(AItemKey, Result) then
    begin
      Result := -1;
    end;
end;

{***************************************************************}
procedure TALInt64List.Insert(AIndex: Integer; const AItemKey: Int64);
begin
  InsertObject(AIndex, AItemKey, nil);
end;

{***************************************************************************************}
procedure TALInt64List.InsertObject(AIndex: Integer; const AitemKey: Int64; AObject: TObject);
Var
  tmpListItem: PALInt64ListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInt64 := AitemKey;
  tmpListItem^.FObject := AObject;
  try
    inherited insert(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{*********************************************************************}
procedure TALInt64List.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lstDeleted then
    dispose(ptr);
  inherited Notify(Ptr, Action);
end;

{****************************************************************}
procedure TALInt64List.SetItem(AIndex: Integer; const AItemKey: Int64);
var
  tmpListItem: PALInt64ListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInt64 := AitemKey;
  tmpListItem^.FObject := nil;
  try
    Put(AIndex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{*******************************************************}
function TALInt64List.GetObject(AIndex: Integer): TObject;
begin
  if (AIndex < 0) or (AIndex >= FCount) then
    Error(@SALListIndexError, AIndex);
  Result :=  PALInt64ListItem(Get(Aindex))^.FObject;
end;

{*************************************************************}
function TALInt64List.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to Count - 1 do
  begin
    if GetObject(Result) = AObject then
    begin
      Exit;
    end;
  end;
  Result := -1;
end;

{*****************************************************************}
procedure TALInt64List.PutObject(AIndex: Integer; AObject: TObject);
begin
  if (AIndex < 0) or (AIndex >= FCount) then
  begin
    Error(@SALListIndexError, AIndex);
  end;
  PALInt64ListItem(Get(Aindex))^.FObject := AObject;
end;

end.
