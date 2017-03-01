unit QuickList_Int;

interface

uses
  QuickSortList;

type
  {---------------------------------------}
  PALIntegerListItem = ^TALIntegerListItem;
  TALIntegerListItem = record
    FInteger: integer;
    FObject: TObject;
  end;

  {------------------------------------------}
  TALIntegerList = class(TALBaseQuickSortList)
  public
    function  GetItem(AIndex: Integer): Integer;
    procedure SetItem(AIndex: Integer; const AItemKey: Integer);
    function  GetObject(AIndex: Integer): TObject;
    procedure PutObject(AIndex: Integer; AObject: TObject);
  public
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure InsertItem(AIndex: Integer; const AitemKey: integer; AObject: TObject);
    function  CompareItems(const Index1, Index2: Integer): Integer; override;
  public
    function  IndexOf(AItemKey: Integer): Integer;
    function  IndexOfObject(AObject: TObject): Integer;
    function  Add(const AItemKey: integer): Integer;
    Function  AddObject(const AItemKey: integer; AObject: TObject): Integer;
    function  Find(AItemKey: Integer; var AIndex: Integer): Boolean;
    procedure Insert(AIndex: Integer; const AitemKey: integer);
    procedure InsertObject(AIndex: Integer; const AitemKey: integer; AObject: TObject);
    property  Items[Index: Integer]: Integer read GetItem write SetItem; default;
    property  Objects[Index: Integer]: TObject read GetObject write PutObject;
  end;

implementation

{********************************************************}
function TALIntegerList.Add(const AItemKey: integer): Integer;
begin
  Result := AddObject(AItemKey, nil);
end;

{********************************************************************************}
function TALIntegerList.AddObject(const AItemKey: integer; AObject: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else if Find(AItemKey, Result) then
    case Duplicates of
      lstDupIgnore: Exit;
      lstDupError: Error(@SALDuplicateItem, 0);
    end;
  InsertItem(Result, AItemKey, AObject);
end;

{*****************************************************************************************}
procedure TALIntegerList.InsertItem(AIndex: Integer; const AitemKey: integer; AObject: TObject);
var
  tmpListItem: PALIntegerListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInteger := AitemKey;
  tmpListItem^.FObject := AObject;
  try
    inherited InsertItem(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{***************************************************************************}
function TALIntegerList.CompareItems(const Index1, Index2: integer): Integer;
begin
  result := PALIntegerListItem(Get(Index1))^.FInteger - PALIntegerListItem(Get(Index2))^.FInteger;
end;

{***********************************************************************}
function TALIntegerList.Find(AItemKey: Integer; var AIndex: Integer): Boolean;
var
  L: Integer;
  H: Integer;
  I: Integer;
  C: double;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := GetItem(I) - AItemkey;
    if C < 0 then
    begin
      L := I + 1
    end else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> lstDupAccept then
          L := I;
      end;
    end;
  end;
  AIndex := L;
end;

{*******************************************************}
function TALIntegerList.GetItem(AIndex: Integer): Integer;
begin
  Result := PALIntegerListItem(Get(Aindex))^.FInteger
end;

{******************************************************}
function TALIntegerList.IndexOf(AItemKey: Integer): Integer;
begin
  if not Sorted then
  begin
    Result := 0;
    while (Result < FCount) and (GetItem(result) <> AItemKey) do
    begin
      Inc(Result);
    end;
    if Result = FCount then
    begin
      Result := -1;
    end;
  end else if not Find(AItemKey, Result) then
    Result := -1;
end;

{*******************************************************************}
procedure TALIntegerList.Insert(AIndex: Integer; const AItemKey: Integer);
begin
  InsertObject(AIndex, AItemKey, nil);
end;

{*******************************************************************************************}
procedure TALIntegerList.InsertObject(AIndex: Integer; const AitemKey: integer; AObject: TObject);
var
  tmpListItem: PALIntegerListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInteger := AitemKey;
  tmpListItem^.FObject := AObject;
  try
    inherited insert(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{***********************************************************************}
procedure TALIntegerList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lstDeleted then
    dispose(ptr);
  inherited Notify(Ptr, Action);
end;

{********************************************************************}
procedure TALIntegerList.SetItem(AIndex: Integer; const AItemKey: Integer);
var
  tmpListItem: PALIntegerListItem;
begin
  New(tmpListItem);
  tmpListItem^.FInteger := AitemKey;
  tmpListItem^.FObject := nil;
  Try
    Put(AIndex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{*********************************************************}
function TALIntegerList.GetObject(AIndex: Integer): TObject;
begin
  if (AIndex < 0) or (AIndex >= FCount) then
    Error(@SALListIndexError, AIndex);
  Result :=  PALIntegerListItem(Get(Aindex))^.FObject;
end;

{***************************************************************}
function TALIntegerList.IndexOfObject(AObject: TObject): Integer;
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

{*******************************************************************}
procedure TALIntegerList.PutObject(AIndex: Integer; AObject: TObject);
begin
  if (AIndex < 0) or (AIndex >= FCount) then
  begin
    Error(@SALListIndexError, AIndex);
  end;
  PALIntegerListItem(Get(Aindex))^.FObject := AObject;
end;

end.
