unit UtilsDateTime;

interface
                  
type
  PDateTimeParseRecord = ^TDateTimeParseRecord;
  TDateTimeParseRecord = record
    Year: Word;
    Month: Word;
    Day: Word;
    Hour: Word;
    Minute: Word;
    Second: Word;
    MSecond: Word;
    Date: TDateTime;
    Time: TDateTime;
  end;
        
  function SeasonOfMonth(AMonth: Word): Word;
  function IsCurrentSeason(ADate: TDateTime): Boolean;   
  procedure ParseDateTime(ADateTimeParse: PDateTimeParseRecord; ADateTimeString: AnsiString);

implementation

uses
  SysUtils;
  
function SeasonOfMonth(AMonth: Word): Word;
begin
  Result := ((AMonth - 1) div 3) + 1;
end;

function IsCurrentSeason(ADate: TDateTime): Boolean;
var
  tmpYear1, tmpMonth1,
  tmpYear2, tmpMonth2,
  tmpDay: Word;
begin
  DecodeDate(ADate, tmpYear1, tmpMonth1, tmpDay);
  DecodeDate(now, tmpYear2, tmpMonth2, tmpDay);
  Result := (tmpYear1 = tmpYear2) and (SeasonOfMonth(tmpMonth1) = SeasonOfMonth(tmpMonth2));
end;

procedure ParseDateTime(ADateTimeParse: PDateTimeParseRecord; ADateTimeString: AnsiString);
var
  i: integer;
  tmpStrDate: AnsiString;
  tmpStrTime: AnsiString;
  tmpStrHead: AnsiString;
  tmpStrEnd: AnsiString;
  tmpFormat: TFormatSettings;
begin
  // 2014/06/12-10:30
  i := Pos('-', ADateTimeString);
  if 0 < i then
  begin
    tmpStrDate := Copy(ADateTimeString, 1, i - 1);
    tmpStrTime := Copy(ADateTimeString, i + 1, maxint);
    FillChar(tmpFormat, SizeOf(tmpFormat), 0);
    tmpFormat.DateSeparator := '/';
    tmpFormat.TimeSeparator := ':'; 
    tmpFormat.ShortDateFormat := 'yyyy/mm/dd';
    tmpFormat.LongDateFormat := 'yyyy/mm/dd';
    tmpFormat.ShortTimeFormat := 'hh:nn:ss';
    tmpFormat.LongTimeFormat := 'hh:nn:ss';
    ADateTimeParse.Date := StrToDateDef(tmpStrDate, 0, tmpFormat);
    ADateTimeParse.Time := StrToTimeDef(tmpStrTime, 0, tmpFormat);
    if 0 < ADateTimeParse.Date then
      DecodeDate(ADateTimeParse.Date, ADateTimeParse.Year, ADateTimeParse.Month, ADateTimeParse.Day);
    if 0 < ADateTimeParse.Time then
      DecodeTime(ADateTimeParse.Time, ADateTimeParse.Hour, ADateTimeParse.Minute, ADateTimeParse.Second, ADateTimeParse.MSecond);
  end;
end;

end.
