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
  tmpFormat: TFormatSettings;
begin
  // 2014/06/12-10:30
  i := 0;       
  if 0 < Pos(':', ADateTimeString) then
  begin
    tmpFormat.TimeSeparator := ':';
    i := Pos('-', ADateTimeString);   
    if 0 >= i then
      i := Pos(#32, ADateTimeString);
  end;
  FillChar(tmpFormat, SizeOf(tmpFormat), 0);
  if 0 < i then
  begin
    tmpStrDate := Copy(ADateTimeString, 1, i - 1);
    tmpStrTime := Copy(ADateTimeString, i + 1, maxint);  
  end else
  begin
    tmpStrDate := ADateTimeString;
    tmpStrTime := '';
  end;
  if 0 < Pos('/', tmpStrDate) then
  begin
    tmpFormat.DateSeparator := '/';
  end else
  begin
    if 0 < Pos('-', tmpStrDate) then
      tmpFormat.DateSeparator := '-';
  end;
  tmpFormat.ShortDateFormat := 'yyyy' + tmpFormat.DateSeparator + 'mm' + tmpFormat.DateSeparator + 'dd';
  tmpFormat.LongDateFormat := 'yyyy' + tmpFormat.DateSeparator + 'mm' + tmpFormat.DateSeparator + 'dd';
  tmpFormat.ShortTimeFormat := 'hh:nn:ss';
  tmpFormat.LongTimeFormat := 'hh:nn:ss';
  ADateTimeParse.Date := StrToDateDef(tmpStrDate, 0, tmpFormat);
  if '' <> tmpStrTime then
  begin
    ADateTimeParse.Time := StrToTimeDef(tmpStrTime, 0, tmpFormat);
    if 0 = ADateTimeParse.Time then
    begin
      // 11:30
      i := Pos(':', tmpStrTime);
      if 0 < i then
      begin
        ADateTimeParse.Hour := StrToIntDef(Copy(tmpStrTime, 1, i - 1), 0);
        tmpStrTime := Copy(tmpStrTime, i + 1, maxint);
        i := Pos(':', tmpStrTime);
        if 0 < i then
        begin

        end else
        begin
          ADateTimeParse.Minute := StrToIntDef(tmpStrTime, 0);
          ADateTimeParse.Time := EncodeTime(ADateTimeParse.Hour, ADateTimeParse.Minute, 0, 0);
        end;
      end;
    end;
  end;
  if 0 < ADateTimeParse.Date then
    DecodeDate(ADateTimeParse.Date, ADateTimeParse.Year, ADateTimeParse.Month, ADateTimeParse.Day);
  if 0 < ADateTimeParse.Time then
    DecodeTime(ADateTimeParse.Time, ADateTimeParse.Hour, ADateTimeParse.Minute, ADateTimeParse.Second, ADateTimeParse.MSecond);
end;

end.
