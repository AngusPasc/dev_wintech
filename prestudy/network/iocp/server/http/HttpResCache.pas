unit HttpResCache;

interface

uses
  win.diskfile;
  
type
  PHttpResCacheNode         = ^THttpResCacheNode;
  THttpResCacheNode         = record
    FileSession             : PWinFile;

    AccessHour              : Integer; //
    AccessMinute            : Integer; //
    AccessSecond            : Integer; // 
    AccessCounterPerSecond  : Integer; // һ���ڷ��ʴ���
    AccessCounterPerMinute  : Integer; // һ�����ڷ��ʴ���
    // �������һ����Դ����Ƶ��,��Դ��С���Ǻܴ�Ļ� ����
    // ȫ�����ص��ڴ��� �ر��ļ����
    CacheMemory             : Pointer;
  end;

  THttpResCache = record

  end;
  
implementation

end.
