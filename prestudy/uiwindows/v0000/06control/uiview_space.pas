unit uiview_space;

interface

type
  TUIViewShapeType = (
    shapeUnknown,
    shapePoint,
    shapeLine, // ֱ��
    shapeCurve, // ����
    shapeTriangle, // ������
    shapeRect,     // ������� -- ����
    shapePolygon   // ������� -- �����
  );
  
  PUIViewShape  = ^TUIViewShape; 
  PUIViewLayout = ^TUIViewLayout;
  PUIViewSpace  = ^TUIViewSpace;
  
  TUIViewShape  = record
    ShapeType   : TUIViewShapeType;
    OffsetX     : integer;
    OffsetY     : integer;
    Width       : integer;
    Height      : integer;
  end;

  TUIViewLayout = record
    Parent      : PUIViewSpace;
    FirstChild  : PUIViewSpace;
    LastChild   : PUIViewSpace;
    PrevSibling : PUIViewSpace;
    NextSibling : PUIViewSpace;  
    Left        : integer;
    Top         : integer;
    Right       : integer;
    Bottom      : integer;
    //Space       : PUIViewSpace;  
  end;

  TUIViewSpace  = record
    Layout      : TUIViewLayout;
    Shape       : TUIViewShape;
  end;
  
implementation

end.
