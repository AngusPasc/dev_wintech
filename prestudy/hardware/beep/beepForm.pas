unit beepForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
              
procedure PlaySong1;
const
  t = 800;
begin
  Windows.Beep(330, t);
  Windows.Beep(392, t);
  Windows.Beep(262, t*2);

  Windows.Beep(294, t);
  Windows.Beep(330, t);
  Windows.Beep(196, t*2);

  Windows.Beep(262, t);
  Windows.Beep(294, t);
  Windows.Beep(330, t);
  Windows.Beep(392, t);
  Windows.Beep(294, t*4);
end;

procedure PlaySong2;
{* 
  �ͱ� 
  ����:�������ݳ��� 
  ר��:ɭ�ֺ�ԭҰ 
  ����:����ͬ(��һ��ʦ) 
  *}  
const  
  ONE_BEEP = 600;  
  HALF_BEEP = 300;  
  { 
  NOTE_1 = 440; 
  NOTE_2 = 495; 
  NOTE_3 = 550; 
  NOTE_4 = 587; 
  NOTE_5 = 660; 
  NOTE_6 = 733; 
  NOTE_7 = 825; 
  }  
  NOTE_1 = 440*1;  
  NOTE_2 = 495*1;  
  NOTE_3 = 550*1;  
  NOTE_4 = 587*1;  
  NOTE_5 = 660*1;  
  NOTE_6 = 733*1;  
  NOTE_7 = 825*1;  
begin  
  try  
    //��ͤ��  
    Windows.Beep(NOTE_5, ONE_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_5, HALF_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP * 2);  
  
    //�ŵ���  
    Windows.Beep(NOTE_6, ONE_BEEP);
    Windows.Beep(NOTE_1 * 2, ONE_BEEP);
    Windows.Beep(NOTE_5, ONE_BEEP * 2);

    //���ݱ�����
    Windows.Beep(NOTE_5, ONE_BEEP);
    Windows.Beep(NOTE_1, HALF_BEEP);
    Windows.Beep(NOTE_2, HALF_BEEP);  
    Windows.Beep(NOTE_3, ONE_BEEP);  
    Windows.Beep(NOTE_2, HALF_BEEP);  
    Windows.Beep(NOTE_1, HALF_BEEP);  
    Windows.Beep(NOTE_2, ONE_BEEP * 4);  
  
    //������������  
    Windows.Beep(NOTE_5, ONE_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_5, HALF_BEEP);  
    Windows.Beep(NOTE_1 * 2, HALF_BEEP * 3);  
    Windows.Beep(NOTE_7, HALF_BEEP);  
    Windows.Beep(NOTE_6, ONE_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP);
    Windows.Beep(NOTE_5, ONE_BEEP * 2);  
  
    //Ϧ��ɽ��ɽ  
    Windows.Beep(NOTE_5, ONE_BEEP);  
    Windows.Beep(NOTE_2, HALF_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_4, HALF_BEEP * 3);  
    Windows.Beep(round(NOTE_7 / 2), HALF_BEEP);  
    Windows.Beep(NOTE_1, ONE_BEEP * 4);  
  
    //��֮��  
    Windows.Beep(NOTE_6, ONE_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP * 2);  
  
    //��֮��  
    Windows.Beep(NOTE_7, ONE_BEEP);  
    Windows.Beep(NOTE_6, HALF_BEEP);  
    Windows.Beep(NOTE_7, HALF_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP * 2);  
  
    //֪��������  
    Windows.Beep(NOTE_6, HALF_BEEP);  
    Windows.Beep(NOTE_7, HALF_BEEP);  
    Windows.Beep(NOTE_1 * 2, HALF_BEEP);  
    Windows.Beep(NOTE_6, HALF_BEEP);  
    Windows.Beep(NOTE_6, HALF_BEEP);  
    Windows.Beep(NOTE_5, HALF_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_1, HALF_BEEP);  
    Windows.Beep(NOTE_2, ONE_BEEP * 4);  
  
    //һ���Ǿƾ��໶  
    Windows.Beep(NOTE_5, ONE_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_5, HALF_BEEP);  
    Windows.Beep(NOTE_1 * 2, HALF_BEEP * 3);  
    Windows.Beep(NOTE_7, HALF_BEEP);  
    Windows.Beep(NOTE_6, ONE_BEEP);  
    Windows.Beep(NOTE_1 * 2, ONE_BEEP);  
    Windows.Beep(NOTE_5, ONE_BEEP * 2);
  
    //�������κ�  
    Windows.Beep(NOTE_5, ONE_BEEP);  
    Windows.Beep(NOTE_2, HALF_BEEP);  
    Windows.Beep(NOTE_3, HALF_BEEP);  
    Windows.Beep(NOTE_4, HALF_BEEP * 3);  
    Windows.Beep(round(NOTE_7 / 2), HALF_BEEP);  
    Windows.Beep(NOTE_1, ONE_BEEP * 3);  
  except  
    on E: Exception do  
      Writeln(E.Classname, ': ', E.Message);  
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  //Windows.Beep();
  //Windows.Beep(1200, 10);
  //Windows.MessageBeep(MB_OK);
  //Windows.MessageBeep(MB_ICONEXCLAMATION); 
  //Windows.Beep(440, 1000);
  //PlaySong2;
  SysUtils.beep;
  //Windows.Beep(����, ����);
end;

end.
