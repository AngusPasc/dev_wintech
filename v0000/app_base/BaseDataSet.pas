unit BaseDataSet;

interface

type
  TBaseDataSetData = record
    DBType: integer;
    DataType: integer;
    DataSrcID: integer;    
  end;
  
  TBaseDataSetAccess = class
  protected
    fBaseDataSetData: TBaseDataSetData;
    function GetRecordCount: Integer; virtual;
    function GetRecordItem(AIndex: integer): Pointer; virtual;
  public
    constructor Create(ADBType, ADataSrcId: integer); virtual;
    function FindRecordByKey(AKey: Integer): Pointer; virtual;
    function CheckOutKeyRecord(AKey: Integer): Pointer; virtual;

    procedure Sort; virtual;  
    procedure Clear; virtual;
    
    class function DataTypeDefine: integer; virtual; abstract;
    
    property RecordCount: Integer read GetRecordCount;
    property RecordItem[AIndex: integer]: Pointer read GetRecordItem;
    property DBType: integer read fBaseDataSetData.DBType write fBaseDataSetData.DBType;
    property DataType: integer read fBaseDataSetData.DataType write fBaseDataSetData.DataType;
    property DataSrcID: integer read fBaseDataSetData.DataSrcID write fBaseDataSetData.DataSrcID;    
  end;

implementation

{ TBaseDataSetAccess }

constructor TBaseDataSetAccess.Create(ADBType, ADataSrcId: integer);
begin
  FillChar(fBaseDataSetData, SizeOf(fBaseDataSetData), 0);
  fBaseDataSetData.DBType := ADBType;
  fBaseDataSetData.DataType := DataTypeDefine;
  fBaseDataSetData.DataSrcId := ADataSrcId;
end;

function TBaseDataSetAccess.CheckOutKeyRecord(AKey: Integer): Pointer;
begin
  Result := nil;
end;

function TBaseDataSetAccess.FindRecordByKey(AKey: Integer): Pointer;
begin
  Result := nil;
end;

function TBaseDataSetAccess.GetRecordCount: Integer;
begin
  Result := 0;
end;

function TBaseDataSetAccess.GetRecordItem(AIndex: integer): Pointer;
begin
  Result := nil;
end;

procedure TBaseDataSetAccess.Sort;
begin
end;

procedure TBaseDataSetAccess.Clear;
begin
end;

end.
