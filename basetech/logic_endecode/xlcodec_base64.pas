unit xlcodec_base64;

interface

uses
  define_char;

(*
Base64����������������ڴ���8Bit�ֽڴ���ı��뷽ʽ֮һ��
��ҿ��Բ鿴RFC2045��RFC2049��������MIME����ϸ�淶��
Base64�����������HTTP�����´��ݽϳ��ı�ʶ��Ϣ�����磬
��Java PersistenceϵͳHibernate�У��Ͳ�����Base64����һ���ϳ�
��Ψһ��ʶ����һ��Ϊ128-bit��UUID������Ϊһ���ַ�����
����HTTP����HTTP GET URL�еĲ�����������Ӧ�ó����У�
Ҳ������Ҫ�Ѷ��������ݱ���Ϊ�ʺϷ���URL���������ر���
�е���ʽ����ʱ������Base64������в��ɶ��ԣ�������������ݲ��ᱻ����������ֱ�ӿ���
*)
        
const
  Base64TableLength = 64;
  AA_BASE64: array[0..Base64TableLength - 1] of AnsiChar = (
    AC_CAPITAL_A, AC_CAPITAL_B, AC_CAPITAL_C, AC_CAPITAL_D, AC_CAPITAL_E, AC_CAPITAL_F,
    AC_CAPITAL_G, AC_CAPITAL_H, AC_CAPITAL_I, AC_CAPITAL_J, AC_CAPITAL_K, AC_CAPITAL_L,
    AC_CAPITAL_M, AC_CAPITAL_N, AC_CAPITAL_O, AC_CAPITAL_P, AC_CAPITAL_Q, AC_CAPITAL_R,
    AC_CAPITAL_S, AC_CAPITAL_T, AC_CAPITAL_U, AC_CAPITAL_V, AC_CAPITAL_W, AC_CAPITAL_X,
    AC_CAPITAL_Y, AC_CAPITAL_Z,       
    AC_SMALL_A, AC_SMALL_B, AC_SMALL_C, AC_SMALL_D, AC_SMALL_E, AC_SMALL_F,
    AC_SMALL_G, AC_SMALL_H, AC_SMALL_I, AC_SMALL_J, AC_SMALL_K, AC_SMALL_L,
    AC_SMALL_M, AC_SMALL_N, AC_SMALL_O, AC_SMALL_P, AC_SMALL_Q, AC_SMALL_R,
    AC_SMALL_S, AC_SMALL_T, AC_SMALL_U, AC_SMALL_V, AC_SMALL_W, AC_SMALL_X,
    AC_SMALL_Y, AC_SMALL_Z,   
    AC_DIGIT_ZERO, AC_DIGIT_ONE, AC_DIGIT_TWO, AC_DIGIT_THREE, AC_DIGIT_FOUR,
    AC_DIGIT_FIVE, AC_DIGIT_SIX, AC_DIGIT_SEVEN, AC_DIGIT_EIGHT, AC_DIGIT_NINE,
    AC_PLUS_SIGN, AC_SOLIDUS
    );
                    
//  Base64Table: AnsiChar[Base64TableLength]='ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
//                                           'abcdefghijklmnopqrstuvwxyz' +
//                                           '0123456789+/';
  Pad = AC_EQUALS_SIGN;
  
implementation

end.
