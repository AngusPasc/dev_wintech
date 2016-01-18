unit BaseWinDisk;

interface

uses
  Windows;
  
type
  PWinDisk                = ^TWinDisk;
  TWinDisk                = record
    //lpRootPathName: PAnsiChar;
    DriveType             : UINT;
    SectorsPerCluster     : DWORD;
    BytesPerSector        : DWORD;
    NumberOfFreeClusters  : DWORD;
    TotalNumberOfClusters : DWORD;
  end;
  
implementation

(*
GetDiskFreeSpaceA ��ȡ��һ�����̵���֯�йص���Ϣ���Լ��˽�ʣ��ռ������
GetDiskFreeSpaceExA ��ȡ��һ�����̵���֯�Լ�ʣ��ռ������йص���Ϣ
GetDriveTypeA �ж�һ������������������
GetLogicalDrives �ж�ϵͳ�д�����Щ�߼���������ĸ
GetFullPathNameA ��ȡָ���ļ�����ϸ·��
GetVolumeInformationA ��ȡ��һ�����̾��йص���Ϣ
GetWindowsDirectoryA ��ȡWindowsĿ¼������·����
GetSystemDirectoryA ȡ��WindowsϵͳĿ¼����SystemĿ¼��������·����
*)
procedure OpenWinDisk(AWinDisk: PWinDisk);
var
  tmpMaximumComponentLength: DWORD;
  tmpFileSystemFlags: DWORD;
begin
  Windows.GetDiskFreeSpaceA('',
    AWinDisk.SectorsPerCluster,
    AWinDisk.BytesPerSector,
    AWinDisk.NumberOfFreeClusters,
    AWinDisk.TotalNumberOfClusters);
  AWinDisk.DriveType := Windows.GetDriveTypeA('c:');

  GetVolumeInformationA(
    '', //lpRootPathName: PAnsiChar;
    '', //lpVolumeNameBuffer: PAnsiChar;
    0, //nVolumeNameSize: DWORD;
    nil, //lpVolumeSerialNumber: PDWORD;
    tmpMaximumComponentLength,
    tmpFileSystemFlags,
    '', //lpFileSystemNameBuffer: PAnsiChar;
    0 //nFileSystemNameSize: DWORD
  );
  //Windows.GetFullPathNameA();
  //GetDiskFreeSpaceExA();
end;

end.
