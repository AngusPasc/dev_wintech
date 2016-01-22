unit xlencrypt_aes;

interface
              
(*
    �߼����ܱ�׼��Ӣ�Advanced Encryption Standard����д��AES��
    ������ѧ���ֳ�Rijndael���ܷ�

    �ϸ��˵��AES��Rijndael���ܷ�������ȫһ������Ȼ��ʵ��Ӧ���ж��߿��Ի�������
    ��ΪRijndael���ܷ�����֧�ָ���Χ���������Կ���ȣ�AES�����鳤�ȹ̶�Ϊ128 ���أ�
    ��Կ�����������128��192��256���أ���Rijndaelʹ�õ���Կ�����鳤�ȿ�����32λ��
    ����������128λΪ���ޣ�256����Ϊ���ޡ����ܹ�����ʹ�õ���Կ����Rijndael��Կ���ɷ���������
    �����AES��������һ���ر����������ɵġ�
*)

uses
  BaseType;

type
  TAESBuffer          = TByte16; //array [0..15] of Byte;
  TAESKey128          = TByte16; //array [0..15] of Byte;
  TAESKey192          = array [0..23] of Byte;
  TAESKey256          = TByte32; //array [0..31] of Byte;
  TAESExpandedKey128  = array [0..43] of LongWord;
  TAESExpandedKey192  = array [0..53] of LongWord;
  TAESExpandedKey256  = array [0..63] of LongWord;
                     
  PAESBuffer          = ^TAESBuffer;
  PAESKey128          = ^TAESKey128;
  PAESKey192          = ^TAESKey192;
  PAESKey256          = ^TAESKey256;
  PAESExpandedKey128  = ^TAESExpandedKey128;
  PAESExpandedKey192  = ^TAESExpandedKey192;
  PAESExpandedKey256  = ^TAESExpandedKey256;

// ECB ģʽ
// CBC ģʽ

implementation

end.
