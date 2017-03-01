unit QuickList_double;

interface

uses
  QuickSortList;

type
  {---------------------------------------}
  PALDoubleListItem = ^TALDoubleListItem;
  TALDoubleListItem = record
    FDouble: Double;
    FObject: TObject;
  end;

  {------------------------------------------}
  TALDoubleList = class(TALBaseQuickSortList)
  public
    function  GetItem(AIndex: Integer): double;
    procedure SetItem(AIndex: Integer; const AItemkey: double);
    function  GetObject(AIndex: Integer): TObject;
    procedure PutObject(AIndex: Integer; AObject: TObject);
  public
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure InsertItem(AIndex: Integer; const item: double; AObject: TObject);
    function  CompareItems(const Index1, Index2: Integer): Integer; override;
  public
    function  IndexOf(AItemKey: double): Integer;
    function  IndexOfObject(AObject: TObject): Integer;
    function  Add(const AItemKey: double): Integer;
    Function  AddObject(const AItemKey: double; AObject: TObject): Integer;
    function  Find(AItemKey: double; var AIndex: Integer): Boolean;
    procedure Insert(AIndex: Integer; const AitemKey: double);
    procedure InsertObject(AIndex: Integer; const AitemKey: double; AObject: TObject);
    property  Items[Index: Integer]: double read GetItem write SetItem; default;
    property  Objects[Index: Integer]: TObject read GetObject write PutObject;
  end;

implementation
                                                                   
{********************************************************}
function TALDoubleList.Add(const AItemKey: double): Integer;
begin
  Result := AddObject(AItemKey, nil);
end;

{********************************************************************************}
function TALDoubleList.AddObject(const AItemKey: double; AObject: TObject): Integer;
begin
  if not Sorted then
  begin
    Result := FCount
  end else if Find(AItemKey, Result) then
  begin
    case Duplicates of
      lstDupIgnore: Exit;
      lstDupError: Error(@SALDuplicateItem, 0);
    end;
  end;
  InsertItem(Result, AItemKey, AObject);
end;

{*****************************************************************************************}
procedure TALDoubleList.InsertItem(AIndex: Integer; const item: double; AObject: TObject);
Var
  tmpListItem: PALDoubleListItem;
begin
  New(tmpListItem);
  tmpListItem^.FDouble := item;
  tmpListItem^.FObject := AObject;
  try
    inherited InsertItem(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{***************************************************************************}
function TALDoubleList.CompareItems(const Index1, Index2: integer): Integer;
begin
  if PALDoubleListItem(Get(Index1))^.FDouble = PALDoubleListItem(Get(Index2))^.FDouble then
  begin
    Result := 0;
  end else
  begin
    if PALDoubleListItem(Get(Index1))^.FDouble > PALDoubleListItem(Get(Index2))^.FDouble then
    begin
      Result := 1;
    end else
    begin
      Result := -1;
    end;
  end;
  //result := PALDoubleListItem(Get(Index1))^.FDouble - PALDoubleListItem(Get(Index2))^.FDouble;
end;

{***********************************************************************}
function TALDoubleList.Find(AItemKey: Double; var AIndex: Integer): Boolean;
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
    C := GetItem(I) - AItemKey;
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
function TALDoubleList.GetItem(AIndex: Integer): double;
begin
  Result := PALDoubleListItem(Get(AIndex))^.FDouble
end;

{******************************************************}
function TALDoubleList.IndexOf(AItemKey: double): Integer;
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
  begin
    if not Find(AItemKey, Result) then
      Result := -1;
  end;
end;

{*******************************************************************}
procedure TALDoubleList.Insert(AIndex: Integer; const AItemKey: double);
begin
  InsertObject(AIndex, AItemKey, nil);
end;

{*******************************************************************************************}
procedure TALDoubleList.InsertObject(AIndex: Integer; const AitemKey: double; AObject: TObject);
Var
  tmpListItem: PALDoubleListItem;
begin
  New(tmpListItem);
  tmpListItem^.FDouble := AitemKey;
  tmpListItem^.FObject := AObject;
  try
    inherited insert(Aindex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{***********************************************************************}
procedure TALDoubleList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lstDeleted then
    dispose(ptr);
  inherited Notify(Ptr, Action);
end;

{********************************************************************}
procedure TALDoubleList.SetItem(AIndex: Integer; const AItemkey: double);
Var
  tmpListItem: PALDoubleListItem;
begin
  New(tmpListItem);
  tmpListItem^.FDouble := Aitemkey;
  tmpListItem^.FObject := nil;
  Try
    Put(AIndex, tmpListItem);
  except
    Dispose(tmpListItem);
    raise;
  end;
end;

{*********************************************************}
function TALDoubleList.GetObject(AIndex: Integer): TObject;
begin
  if (AIndex < 0) or (AIndex >= FCount) then
    Error(@SALListIndexError, AIndex);
  Result :=  PALDoubleListItem(Get(Aindex))^.FObject;
end;

{***************************************************************}
function TALDoubleList.IndexOfObject(AObject: TObject): Integer;
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
procedure TALDoubleList.PutObject(AIndex: Integer; AObject: TObject);
begin
  if (AIndex < 0) or (AIndex >= FCount) then
  begin
    Error(@SALListIndexError, AIndex);
  end;
  PALDoubleListItem(Get(Aindex))^.FObject := AObject;
end;

end.
