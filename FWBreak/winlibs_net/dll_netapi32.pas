unit dll_netapi32;

interface

// get local mac address

const
  netapi32 = 'netapi32.dll';

  
const
  NCBNAMSZ = 16;               // absolute length of a net name
  MAX_LANA = 254;              // lana's in range 0 to MAX_LANA inclusive

type
  // Network Control Block
  PNCB = ^TNCB;

  TNCBPostProc = procedure(P: PNCB);

  TNCB = packed record
    ncb_command: AnsiChar;         // command code
    ncb_retcode: AnsiChar;         // return code
    ncb_lsn: AnsiChar;             // local session number
    ncb_num: AnsiChar;             // number of our network name
    ncb_buffer: PAnsiChar;         // address of message buffer
    ncb_length: Word;          // size of message buffer
    ncb_callname: array[0..NCBNAMSZ - 1] of AnsiChar;  // blank-padded name of remote
    ncb_name: array[0..NCBNAMSZ - 1] of AnsiChar;      // our blank-padded netname
    ncb_rto: AnsiChar;             // rcv timeout/retry count
    ncb_sto: AnsiChar;             // send timeout/sys timeout
    ncb_post: TNCBPostProc;    // POST routine address
    ncb_lana_num: AnsiChar;        // lana (adapter) number
    ncb_cmd_cplt: AnsiChar;        // 0xff => commmand pending
    ncb_reserve: array[0..9] of AnsiChar;              // reserved, used by BIOS
    ncb_event: THandle;        // HANDLE to Win32 event which
                               // will be set to the signalled
                               // state when an ASYNCH command
                               // completes
  end;

  // Structure returned to the NCB command NCBASTAT is ADAPTER_STATUS followed
  // by an array of NAME_BUFFER structures.
  PAdapterStatus = ^TAdapterStatus;
  TAdapterStatus = packed record
    adapter_address: array[0..5] of AnsiChar;
    rev_major: AnsiChar;
    reserved0: AnsiChar;
    adapter_type: AnsiChar;
    rev_minor: AnsiChar;
    duration: Word;
    frmr_recv: Word;
    frmr_xmit: Word;
    iframe_recv_err: Word;
    xmit_aborts: Word;
    xmit_success: DWORD;
    recv_success: DWORD;
    iframe_xmit_err: Word;
    recv_buff_unavail: Word;
    t1_timeouts: Word;
    ti_timeouts: Word;
    reserved1: DWORD;
    free_ncbs: Word;
    max_cfg_ncbs: Word;
    max_ncbs: Word;
    xmit_buf_unavail: Word;
    max_dgram_size: Word;
    pending_sess: Word;
    max_cfg_sess: Word;
    max_sess: Word;
    max_sess_pkt_size: Word;
    name_count: Word;
  end;

  PNameBuffer = ^TNameBuffer;
  TNameBuffer = packed record
    name: array[0..NCBNAMSZ - 1] of AnsiChar;
    name_num: AnsiChar;
    name_flags: AnsiChar;
  end;

const
  // values for name_flags bits.
  NAME_FLAGS_MASK = $87;

  GROUP_NAME      = $80;
  UNIQUE_NAME     = $00;

  REGISTERING     = $00;
  REGISTERED      = $04;
  DEREGISTERED    = $05;
  DUPLICATE       = $06;
  DUPLICATE_DEREG = $07;

type
  // Structure returned to the NCB command NCBSSTAT is SESSION_HEADER followed
  // by an array of SESSION_BUFFER structures. If the NCB_NAME starts with an
  // asterisk then an array of these structures is returned containing the
  // status for all names.
  PSessionHeader = ^TSessionHeader;
  TSessionHeader = packed record
    sess_name: AnsiChar;
    num_sess: AnsiChar;
    rcv_dg_outstanding: AnsiChar;
    rcv_any_outstanding: AnsiChar;
  end;

  PSessionBuffer = ^TSessionBuffer;
  TSessionBuffer = packed record
    lsn: AnsiChar;
    state: AnsiChar;
    local_name: array[0..NCBNAMSZ - 1] of AnsiChar;
    remote_name: array[0..NCBNAMSZ - 1] of AnsiChar;
    rcvs_outstanding: AnsiChar;
    sends_outstanding: AnsiChar;
  end;

const
  // Values for state
  LISTEN_OUTSTANDING      = $01;
  CALL_PENDING            = $02;
  SESSION_ESTABLISHED     = $03;
  HANGUP_PENDING          = $04;
  HANGUP_COMPLETE         = $05;
  SESSION_ABORTED         = $06;

type
  // Structure returned to the NCB command NCBENUM.
  // On a system containing lana's 0, 2 and 3, a structure with
  // length =3, lana[0]=0, lana[1]=2 and lana[2]=3 will be returned.
  PLanaEnum = ^TLanaEnum;
  TLanaEnum = packed record
    length: AnsiChar;         //  Number of valid entries in lana[]
    lana: array[0..MAX_LANA] of AnsiChar;
  end;

  // Structure returned to the NCB command NCBFINDNAME is FIND_NAME_HEADER followed
  // by an array of FIND_NAME_BUFFER structures.
  PFindNameHeader = ^TFindNameHeader;
  TFindNameHeader = packed record
    node_count: Word;
    reserved: AnsiChar;
    unique_group: AnsiChar;
  end;

  PFindNameBuffer = ^TFindNameBuffer;
  TFindNameBuffer = packed record
    length: AnsiChar;
    access_control: AnsiChar;
    frame_control: AnsiChar;
    destination_addr: array[0..5] of AnsiChar;
    source_addr: array[0..5] of AnsiChar;
    routing_info: array[0..17] of AnsiChar;
  end;

  // Structure provided with NCBACTION. The purpose of NCBACTION is to provide
  // transport specific extensions to netbios.
  PActionHeader = ^TActionHeader;
  TActionHeader = packed record
    transport_id: Longint;
    action_code: Word;
    reserved: Word;
  end;

const
  // Values for transport_id
  ALL_TRANSPORTS  = 'M'#0#0#0;
  MS_NBF          = 'MNBF';


{ Special values and constants }

const
  // NCB Command codes
  NCBCALL         = $10;            // NCB CALL
  NCBLISTEN       = $11;            // NCB LISTEN
  NCBHANGUP       = $12;            // NCB HANG UP
  NCBSEND         = $14;            // NCB SEND
  NCBRECV         = $15;            // NCB RECEIVE
  NCBRECVANY      = $16;            // NCB RECEIVE ANY
  NCBCHAINSEND    = $17;            // NCB CHAIN SEND
  NCBDGSEND       = $20;            // NCB SEND DATAGRAM
  NCBDGRECV       = $21;            // NCB RECEIVE DATAGRAM
  NCBDGSENDBC     = $22;            // NCB SEND BROADCAST DATAGRAM
  NCBDGRECVBC     = $23;            // NCB RECEIVE BROADCAST DATAGRAM
  NCBADDNAME      = $30;            // NCB ADD NAME
  NCBDELNAME      = $31;            // NCB DELETE NAME
  NCBRESET        = $32;            // NCB RESET
  NCBASTAT        = $33;            // NCB ADAPTER STATUS
  NCBSSTAT        = $34;            // NCB SESSION STATUS
  NCBCANCEL       = $35;            // NCB CANCEL
  NCBADDGRNAME    = $36;            // NCB ADD GROUP NAME
  NCBENUM         = $37;            // NCB ENUMERATE LANA NUMBERS
  NCBUNLINK       = $70;            // NCB UNLINK
  NCBSENDNA       = $71;            // NCB SEND NO ACK
  NCBCHAINSENDNA  = $72;            // NCB CHAIN SEND NO ACK
  NCBLANSTALERT   = $73;            // NCB LAN STATUS ALERT
  NCBACTION       = $77;            // NCB ACTION
  NCBFINDNAME     = $78;            // NCB FIND NAME
  NCBTRACE        = $79;            // NCB TRACE

  ASYNCH          = $80;            // high bit set = asynchronous

  // NCB Return codes
  NRC_GOODRET     = $00;    // good return
                            // also returned when ASYNCH request accepted
  NRC_BUFLEN      = $01;    // illegal buffer length
  NRC_ILLCMD      = $03;    // illegal command
  NRC_CMDTMO      = $05;    // command timed out
  NRC_INCOMP      = $06;    // message incomplete, issue another command
  NRC_BADDR       = $07;    // illegal buffer address
  NRC_SNUMOUT     = $08;    // session number out of range
  NRC_NORES       = $09;    // no resource available
  NRC_SCLOSED     = $0a;    // session closed
  NRC_CMDCAN      = $0b;    // command cancelled
  NRC_DUPNAME     = $0d;    // duplicate name
  NRC_NAMTFUL     = $0e;    // name table full
  NRC_ACTSES      = $0f;    // no deletions, name has active sessions
  NRC_LOCTFUL     = $11;    // local session table full
  NRC_REMTFUL     = $12;    // remote session table full
  NRC_ILLNN       = $13;    // illegal name number
  NRC_NOCALL      = $14;    // no callname
  NRC_NOWILD      = $15;    // cannot put * in NCB_NAME
  NRC_INUSE       = $16;    // name in use on remote adapter
  NRC_NAMERR      = $17;    // name deleted
  NRC_SABORT      = $18;    // session ended abnormally
  NRC_NAMCONF     = $19;    // name conflict detected
  NRC_IFBUSY      = $21;    // interface busy, IRET before retrying
  NRC_TOOMANY     = $22;    // too many commands outstanding, retry later
  NRC_BRIDGE      = $23;    // NCB_lana_num field invalid
  NRC_CANOCCR     = $24;    // command completed while cancel occurring
  NRC_CANCEL      = $26;    // command not valid to cancel
  NRC_DUPENV      = $30;    // name defined by anther local process
  NRC_ENVNOTDEF   = $34;    // environment undefined. RESET required
  NRC_OSRESNOTAV  = $35;    // required OS resources exhausted
  NRC_MAXAPPS     = $36;    // max number of applications exceeded
  NRC_NOSAPS      = $37;    // no saps available for netbios
  NRC_NORESOURCES = $38;    // requested resources are not available
  NRC_INVADDRESS  = $39;    // invalid ncb address or length > segment
  NRC_INVDDID     = $3B;    // invalid NCB DDID
  NRC_LOCKFAIL    = $3C;    // lock of user area failed
  NRC_OPENERR     = $3f;    // NETBIOS not loaded
  NRC_SYSTEM      = $40;    // system error

  NRC_PENDING     = $ff;    // asynchronous command is not yet finished

{ main user entry point for NetBIOS 3.0
   Usage: Result = Netbios( pncb ); }

  function PeekMessage(P: PNCB): AnsiChar; stdcall; external netapi32 name 'PeekMessageA';

implementation

end.
