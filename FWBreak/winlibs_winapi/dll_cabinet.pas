unit dll_cabinet;

interface

implementation

(*
const  
  SHCONTCH_NOPROGRESSBOX = 4;  
  SHCONTCH_AUTORENAME = 8;  
  SHCONTCH_RESPONDYESTOALL = 16;  
  SHCONTF_INCLUDEHIDDEN = 128;  
  SHCONTF_FOLDERS = 32;  
  SHCONTF_NONFOLDERS = 64;  
  
function ShellUnzip(zipfile, targetfolder: string; filter: string = ''): boolean;  
var  
  shellobj: variant;  
  srcfldr, destfldr: variant;  
  shellfldritems: variant;  
begin  
  shellobj := CreateOleObject('Shell.Application');  
  
  srcfldr := shellobj.NameSpace(zipfile);  
  destfldr := shellobj.NameSpace(targetfolder);  
  
  shellfldritems := srcfldr.Items;  
  if (filter <> '') then  
    shellfldritems.Filter(SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,filter);  
  
  destfldr.CopyHere(shellfldritems, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);  
end;  

function ShellZip(zipfile, sourcefolder:string; filter: string = ''): boolean;  
const  
  emptyzip: array[0..23] of byte  = (80,75,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);  
var  
  ms: TMemoryStream;  
  shellobj: variant;  
  srcfldr, destfldr: variant;  
  shellfldritems: variant;  
  numt: integer;  
begin  
  if not FileExists(zipfile) then  
  begin  
    // create a new empty ZIP file  
    ms := TMemoryStream.Create;  
    ms.WriteBuffer(emptyzip, sizeof(emptyzip));  
    ms.SaveToFile(zipfile);  
    ms.Free;  
  end;  
  
  numt := NumProcessThreads;  
  
  shellobj := CreateOleObject('Shell.Application');  
  
  srcfldr := shellobj.NameSpace(sourcefolder);  
  destfldr := shellobj.NameSpace(zipfile);  
  
  shellfldritems := srcfldr.Items;  
  
  if (filter <> '') then  
    shellfldritems.Filter(SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,filter);  
  
  destfldr.CopyHere(shellfldritems, 0);  
  
  // wait till all shell threads are terminated  
  while NumProcessThreads <> numt do  
  begin  
    sleep(100);  
  end;  
end;  

{ Add files }
Shell := CreateOleObject('Shell.Application');
Zip := Shell.Namespace('C:\Test.zip');
Zip.CopyHere('C:\Unit1.pas');
repeat
Application.ProcessMessages;
until Zip.Items.Count = 1;
Zip := Unassigned;
Shell := Unassigned;
*)

(*
FCI����5��API�� 
FCICreate   ����   FCI   context 
FCIAddFile   ��   cabinet   ������ļ� 
FCIFlushCabinet   ������ǰ��   cabinet 
FCIFlushFolder   ������ǰ��folder   �������µ�   folder 
FCIDestroy   ����   FCI   context 

FDI����4��API�� 
FDICreate   ����   FDI   context 
FDIIsCabinet   �ж��Ƿ�ΪCABѹ���ļ������򷵻������� 
FDICopy   ��ѹ 
FDIDestroy   ����   FDI   context 
*)
end.