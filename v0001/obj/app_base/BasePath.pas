unit BasePath;

interface

type
  TBasePath = class
  protected
    function GetDataBasePath(ADBType, ADataType: integer; ADataSrc: integer): WideString; virtual;
    function GetInstallPath: WideString; virtual;
    procedure SetDataBasePath(ADBType, ADataType: integer; ADataSrc: integer; const Value: WideString); virtual;
    procedure SetInstallPath(const Value: WideString); virtual;
  public
    function IsFileExists(AFileUrl: WideString): Boolean; virtual;
    function IsPathExists(APathUrl: WideString): Boolean; virtual;

    function GetRootPath: WideString; virtual;
    function GetFileRelativePath(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; virtual;
    function GetFilePath(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; virtual;

    function GetFileName(ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; virtual;
    function GetFileExt(ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; virtual;
             
    function GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer): WideString; overload; virtual;
    function GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; overload; virtual;
    function GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; overload; virtual;

    function CheckOutFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; virtual;

    property InstallPath: WideString read GetInstallPath write SetInstallPath;  
    property DataBasePath[ADBType, ADataType: integer; ADataSrc: integer]: WideString read GetDataBasePath write SetDataBasePath;
  end;
  
implementation

function TBasePath.GetDataBasePath(ADBType, ADataType: integer; ADataSrc: integer): WideString;
begin
  Result := '';
end;

function TBasePath.GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer): WideString;
begin
  Result := GetFileUrl(ADBType, ADataType, ADataSrc, 0, nil);
end;

function TBasePath.GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString;
begin
  Result := GetFileUrl(ADBType, ADataType, ADataSrc, AParamType, AParam, '');
end;

function TBasePath.CheckOutFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; 
begin
  Result := '';
end;
                      
function TBasePath.GetRootPath: WideString;
begin
  Result := '';
end;

function TBasePath.GetFileRelativePath(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString; 
begin
  Result := '';
end;

function TBasePath.GetFilePath(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString;
begin
  Result := '';
end;

function TBasePath.GetFileName(ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString; 
begin
  Result := '';
end;

function TBasePath.GetFileExt(ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer): WideString;
begin
  Result := '';
end;

function TBasePath.GetFileUrl(ADBType, ADataType: integer; ADataSrc: integer; AParamType: integer; AParam: Pointer; AFileExt: WideString): WideString;
begin
  Result := '';
end;

function TBasePath.GetInstallPath: WideString;
begin
  Result := '';
end;

function TBasePath.IsFileExists(AFileUrl: WideString): Boolean;
begin
  Result := false;
end;

function TBasePath.IsPathExists(APathUrl: WideString): Boolean;
begin
  Result := false;
end;

procedure TBasePath.SetDataBasePath(ADBType, ADataType: integer; ADataSrc: integer; const Value: WideString);
begin
end;

procedure TBasePath.SetInstallPath(const Value: WideString);
begin
end;

end.
