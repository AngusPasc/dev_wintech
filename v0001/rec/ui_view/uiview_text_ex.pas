unit uiview_text_ex;

interface

uses
  uiview_text;
  
  procedure TextLineAddCharW(ATextLine: PUITextLineW; ATextPos: PUITextLinePos; AChar: WideChar);

implementation

uses
  Windows;
  
procedure TextLineAddCharW(ATextLine: PUITextLineW; ATextPos: PUITextLinePos; AChar: WideChar);
begin
  if nil = ATextLine.FirstCharBufferNode then
  begin
    ATextLine.FirstCharBufferNode := CheckOutUICharBufferNodeW(ATextLine, nil);
  end;
  if nil = ATextPos.CurrentNode then
  begin
    ATextPos.CurrentNode := ATextLine.FirstCharBufferNode;
  end;
  if ATextPos.CurrentNode.BufferLen = ATextPos.CurrentNode.BufferSize then
  begin
    // ��ǰ���ݳ����Ѿ� �� Buffer �����
    if ATextPos.Position = ATextPos.CurrentNode.BufferSize then
    begin
      // ������� Buffer β��
      ATextPos.CurrentNode := CheckOutUICharBufferNodeW(ATextLine, ATextPos.CurrentNode);
      ATextPos.Position := 0;
    end else
    begin
      // ������� Buffer �м�
      CheckOutUICharBufferNodeW(ATextLine, ATextPos.CurrentNode);
      // ����������� copy ����һ�� Buffer ��
      CopyMemory(
        @ATextPos.CurrentNode.NextSibling.Buffer.Data[0],
        @ATextPos.CurrentNode.Buffer.Data[ATextPos.Position],
        (ATextPos.CurrentNode.BufferLen - ATextPos.Position) * 2);
      ATextPos.CurrentNode.NextSibling.BufferLen :=
          ATextPos.CurrentNode.BufferLen - ATextPos.Position;
      // ���ԭ�Ȳ�������� buffer ����
      FillChar(ATextPos.CurrentNode.Buffer.Data[ATextPos.Position],
        ATextPos.CurrentNode.BufferLen - ATextPos.Position, 0);
      ATextPos.CurrentNode.BufferLen := ATextPos.Position;
    end;
  end;
  if ATextPos.Position = ATextPos.CurrentNode.BufferLen then
  begin
    ATextPos.CurrentNode.Buffer.Data[ATextPos.Position] := AChar;
    Inc(ATextPos.CurrentNode.BufferLen);
    ATextPos.Position := ATextPos.CurrentNode.BufferLen;
  end else
  begin
    CopyMemory(
      @ATextPos.CurrentNode.Buffer.Data[ATextPos.Position + 1],
      @ATextPos.CurrentNode.Buffer.Data[ATextPos.Position],
      (ATextPos.CurrentNode.BufferLen - ATextPos.Position) * 2);
    ATextPos.CurrentNode.Buffer.Data[ATextPos.Position] := AChar;
    Inc(ATextPos.CurrentNode.BufferLen);
    Inc(ATextPos.Position);
  end;
end;

end.
