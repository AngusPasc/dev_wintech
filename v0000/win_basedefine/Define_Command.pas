unit Define_Command;

interface

const                         
  Cmd_SysBase         = 100;
  Cmd_AppBase         = 200;
  // �ⲿ֪ͨ���� �ر�
  Cmd_S2C_ClientShutdown  = Cmd_AppBase + 1;
  // �ⲿ֪ͨ���� ����
  Cmd_S2C_ClientRestart   = Cmd_AppBase + 2;
  
  Cmd_CustomAppBase   = 500;

implementation

end.
