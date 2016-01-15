unit dll_kernel32_device;

interface
             
const
  DDD_RAW_TARGET_PATH             = $00000001; // ʹ��lpTargetPath����
  DDD_REMOVE_DEFINITION           = $00000002; // ɾ��ָ���豸����
  DDD_EXACT_MATCH_ON_REMOVE       = $00000004; // ȷ������ɾ��δ�����Ķ���
  DDD_NO_BROADCAST_SYSTEM         = $00000008; // ���� WM_SETTINGCHANGE��Ϣ��״̬Ϊ�����͡�(Ĭ������£�����Ϣ״̬Ϊ���ͣ�

(*
  //  DefineDosDevice������������������

      ʹ��SetVolumeMountPoint��������һ���������š�
      ʹ��DeleteVolumeMountPoint����ɾ��һ���Ѵ��ڵ��������š�
      ��Ӧ�ò����DefinesDosDevice�����ķ������ӣ�������ں˶���ռ�\\Sessions\\X\\DosDevices\\xxxxxxxx\\ ��

      http://blog.csdn.net/timmy_zhou/article/details/8052143
      
      ��NTϵͳ�У�ÿ���豸���м��������·�����ڷ�����Щ�豸ʱ���Ե����ļ����ʣ���Щ·�������ִ�Сд�� 
      ����Ӳ����õ�·���ǣ�//./PhysicalDrive�����֣���//./PhysicalDrive0��ʾ��һ������Ӳ�̡�ȡ�ø�Ӳ�̾���ķ���һ����CreateFile�������� 
      CString hd=////.//PhysicalDrive0; 
      hDevice = CreateFile(hd, GENERIC_READ|GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL); 
      �򿪳ɹ���Ϳ�����ReadFile�Ⱥ������ж�д������ 
      ����Ӳ�̻�����������·�����硰/Device/Harddisk0���� 
      �������ʷ��������������¼��ַ����� 
      //?/C:��ʾC�̵�·�����÷���Ӳ�̵ķ������Զ������з��ʡ�C�̻�������"/Device/HarddiskVolume1",
              "/Device/Harddisk0/Partition1",
              //?/Volume{385baaca-8b42-11dc-bb79-0013d324fc7d}/(��GetVolumeNameForVolumeMountPoint�������)�� 
      ��ʾ���������Ӳ�������������Ϣ�����������Ӳ��������һ�������ľ��������Ӳ�̾���� 
      �������ĳЩ·����CreateFile�򲻿���������DefineDosDevice������������һ���̷�������̷�������A:,B:��
          Ҳ�������������(��[:,]:)����������(1:,2:)�����ڷ���ĸ�ĵ��̷������ҵĵ������ǲ��ɼ��ģ�
          ֻ�г�����Է��ʣ����ַ��������ڷ������ط����� 
      ���� 
      DefineDosDevice (DDD_RAW_TARGET_PATH, "[:" 
      "//Device//Harddisk0//Partition1");//����һ����[:���̷������̷����ɼ��� 
      ��������������������//������� 
      bRet = DefineDosDevice ( 
      DDD_RAW_TARGET_PATH|DDD_REMOVE_DEFINITION| 
      DDD_EXACT_MATCH_ON_REMOVE, "[:", 
      "//Device//Harddisk0//Partition1");//�����ɾ������̷�
      ====================================================================================================
      �������ط���---ʵ�ִ���
      ���������൱��umount��Ҫ����һ������ֻʣ��C�̡�

      QueryDosDevice(chDosDevice,chNtPath,MAX_PATH);
      for(int Mask=1;Mask;Mask<<=1,chDosDevice[0]++)
      {
      if(dwDisks&Mask)
      {
      QueryDosDevice(chDosDevice,chNtPath,MAX_PATH);

      SaveContext Context;
      Context.strDosDevice=chDosDevice;
      Context.strNtPath=chNtPath;

      //�ȱ�����������豸֮��Ĺ�ϵ
      NtDevices.push_back(Context);

      cout<<Context.strDosDevice<<"<--->"<<Context.strNtPath<<endl;

      //����C:�����������̷���һ��һ���Ĳ�����
      DefineDosDevice(DDD_REMOVE_DEFINITION,Context.strDosDevice.c_str(),NULL);
      }
      D:<--->/Device/HarddiskVolume2
      E:<--->/Device/CdRom0
      F:<--->/Device/CdRom1
      G:<--->/Device/HarddiskVolume4
      H:<--->/Device/HarddiskVolume5
      I:<--->/Device/HarddiskVolume6
      J:<--->/Device/HarddiskVolume7
      Z:<--->/Device/PGPdisks/PGPdiskVolume1
*)
  function DefineDosDeviceA(
      dwFlags: DWORD;
      // �豸�����ַ������Ǳ��뽫ð����Ϊ���һ���ַ���
      // ����һ���������ű����壬���¶����ɾ�������κ�����£�һ����б���ǲ������
      lpDeviceName: PAnsiChar;
      // ָ��·���ַ������������DDD_RAW_TARGET_PATH��������ָ��·���ַ���
      lpTargetPath: PAnsiChar
      ): BOOL; stdcall; external kernel32 name 'DefineDosDeviceA';
  function DefineDosDeviceW(
      dwFlags: DWORD;
      lpDeviceName: PWideChar;
      lpTargetPath: PWideChar
      ): BOOL; stdcall; external kernel32 name 'DefineDosDeviceW';

  function QueryDosDeviceA(
      lpDeviceName: PAnsiChar;
      lpTargetPath: PAnsiChar;
      ucchMax: DWORD): DWORD; stdcall; external kernel32 name 'QueryDosDeviceA';

  function QueryDosDeviceW(
      lpDeviceName: PWideChar;
      lpTargetPath: PWideChar;
      ucchMax: DWORD): DWORD; stdcall; external kernel32 name 'QueryDosDeviceW';

implementation

end.