unit poker_ddz;

interface

{ doudizhu }

uses
  define_Poker;

(*
    // 1. shuffle
    // 2. Dealing, Deing, Licensing
    //    ϴ��Shuffle. ����Deing äעTheBlinds
    //    ��˫�� Double deal
    //    ������ Crooked deal
    // 3. ��ׯ hog [ ����+3 , ��ʼ����λ�� ]
    // 4. �غ� round
          ���� Suit patterns ���� Suit placing ��ɫ����
               1: [1]
               2: [2]  [��ը]
               3: [3*1]
               4: [3*1 + 1] [4*1 (ը)] 
               5: [3*1 + 2*1 ��һ��] [4*1 + 1] [1*5 (˳��)]
               6: [3*2 (�ɻ�)] [2*3 (������)]  [1*6 (˳��)]
               7: [1*7 (˳��)]
               8: [1*8 (˳��)] [3*2 + 1*1 + 1*1 �ɻ�]
               9: [1*9 (˳��)]               
               10:[1*10 (˳��)] [3*2 + 2*2 �ɻ�]
          ����� ����Ȩ�� + 1

    // 5. ��� ���� Settlement balance
*)
implementation

end.
