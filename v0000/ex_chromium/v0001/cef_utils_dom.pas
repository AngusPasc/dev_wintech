
{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}
unit cef_utils_dom;
{$ALIGN ON}
{$MINENUMSIZE 4}
{$I cef.inc}

interface

uses
  Sysutils, cef_type, cef_api;
  
  function GetDomNodeInnerText(ANode: PCefDomNode; AExcludeText: string): string;

implementation

uses
  cef_apilib;
  
function GetDomNodeInnerText(ANode: PCefDomNode; AExcludeText: string): string;
var
  tmpChild: PCefDomNode;
  tmpName: ustring;
begin
  Result := '';           
  tmpName := CefStringFreeAndGet(ANode.get_name(ANode));   
  if SameText('#text', tmpName) then
  begin
    Result := CefStringFreeAndGet(ANode.get_value(ANode));
    if '' <> AExcludeText then
    begin
      if 0 < Pos(AExcludeText, Result) then
      begin
        Result := '';
      end;
    end;
  end;
  tmpChild := ANode.get_first_child(ANode);
  while tmpChild <> nil do
  begin
    Result := Result + GetDomNodeInnerText(tmpChild, AExcludeText);
    tmpChild := tmpChild.get_next_sibling(tmpChild);
  end;
end;

end.
