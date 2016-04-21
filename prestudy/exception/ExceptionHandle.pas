unit ExceptionHandle;

interface

uses
  Windows;
  
(*//

    http://bbs.pediy.com/showthread.php?t=173853
    
    VEH          �������쳣����
    SEH          �ṹ���쳣����
    TopLevelEH   �����쳣����

    �����쳣���������ʵ������SEHʵ�ֵġ�������SEH��
    ����ע��һ�������쳣����������Ȼ���ǻ���SEHʵ�ֵ�
    ���������Դ��������߳��׳����쳣

    6. �����쳣�˿�֪ͨcsrss.exe
//*)

type
  PExecption_Handler  = ^TException_Handler;
  
  PException_Registration= ^TException_Registration;
  TException_Handler  = record
    ExceptionRecord   : PExceptionRecord;
    SEH               : PException_Registration;
    Context           : PContext;
    DispatcherContext : Pointer;
  end;

  TException_Registration= Record
    Prev              : PException_Registration;
    Handler           : PExecption_Handler;
  end;

const
  EXCEPTION_CONTINUE_EXECUTION= 0; ///�ָ�CONTEXT��ļĴ�������������ִ��
  EXCEPTION_CONTINUE_SEARCH= 1; ///�ܾ���������쳣��������¸��쳣������
  EXCEPTION_NESTED_EXCEPTION= 2; ///�����г������µ��쳣
  EXCEPTION_COLLIDED_UNWIND= 3; ///������Ƕ��չ������
  EH_NONE= 0;
  EH_NONCONTINUABLE= 1;
  EH_UNWINDING= 2;
  EH_EXIT_UNWIND= 4;
  EH_STACK_INVALID= 8;
  EH_NESTED_CALL= 16;
  STATUS_ACCESS_VIOLATION= $C0000005; ///���ʷǷ���ַ
  STATUS_ARRAY_BOUNDS_EXCEEDED= $C000008C;
  STATUS_FLOAT_DENORMAL_OPERAND= $C000008D;
  STATUS_FLOAT_DIVIDE_BY_ZERO= $C000008E;
  STATUS_FLOAT_INEXACT_RESULT= $C000008F;
  STATUS_FLOAT_INVALID_OPERATION= $C0000090;
  STATUS_FLOAT_OVERFLOW= $C0000091;
  STATUS_FLOAT_STACK_CHECK= $C0000092;
  STATUS_FLOAT_UNDERFLOW= $C0000093;
  STATUS_INTEGER_DIVIDE_BY_ZERO= $C0000094; ///��0����
  STATUS_INTEGER_OVERFLOW= $C0000095;
  STATUS_PRIVILEGED_INSTRUCTION= $C0000096;
  STATUS_STACK_OVERFLOW= $C00000FD;
  STATUS_CONTROL_C_EXIT= $C000013A;
  
var
  G_TEST: DWORD;
                
  procedure DoTest;

implementation

procedure Log( LogMsg: String );
begin
    Writeln( LogMsg );
end;

//������ص�����,�������Ǹ��е������,�ڶ�������������ԭ����ExceptionRegistration,ԭ��������������
function ExceptionHandler( ExceptionHandler: TEXCEPTION_HANDLER ): LongInt; Cdecl;
Begin
  Result := EXCEPTION_CONTINUE_SEARCH;
  if ExceptionHandler.ExceptionRecord.ExceptionFlags = EH_NONE Then
  begin
    case ExceptionHandler.ExceptionRecord.ExceptionCode Of
      STATUS_ACCESS_VIOLATION: begin
        //Log( '�����쳣Ϊ�Ƿ��ڴ���ʣ������޸�EBX������ִ��' );
        ExceptionHandler.Context.Ebx := DWORD( @G_TEST );
        Result := EXCEPTION_CONTINUE_EXECUTION;
      end;
      else
        Log( '����쳣���޷��������ñ��˴����' );
    end;
  end else if ExceptionHandler.ExceptionRecord.ExceptionFlags= EH_UNWINDING then
  begin
    Log( '�쳣չ������' );
  end;
end;

procedure DoTest;
asm
  //����SEH
  XOR EAX, EAX
  PUSH OFFSET ExceptionHandler
  PUSH FS:[EAX]
  MOV FS:[EAX], ESP
  //�����ڴ���ʴ���
  XOR EBX, EBX
  MOV [EBX], 0
  //ȡ��SEH
  XOR EAX, EAX
  //�����õ���� �����������õ��Ǹ�pop eaxѽ..����.һ��������
  MOV ECX, [ESP]
  MOV FS:[EAX], ECX
  ADD ESP, 8
end;

end.
