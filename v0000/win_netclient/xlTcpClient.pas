unit xlTcpClient;

interface

uses
  xlClientSocket;

type
  PxlTcpClient  = ^TxlTcpClient;
  TxlTcpClient  = record
    Base        : TxlNetClient
  end;

  function CheckOutTcpClient: PxlTcpClient;
  procedure CheckInTcpClient(var AClient: PxlTcpClient);
  
  function TcpClientConnect(ATcpClient: PxlTcpClient; AConnectAddress: PxlNetServerAddress): Boolean;
  procedure TcpClientDisconnect(ATcpClient: PxlTcpClient);
  procedure TcpClientSetReadTimeOut(ANetClient: PxlTcpClient; const Value: Integer);

implementation

uses
  Windows, WinSock2, xlNetwork;

function CheckOutTcpClient: PxlTcpClient;
begin
  Result := System.New(PxlTcpClient);
  FillChar(Result^, SizeOf(TxlTcpClient), 0);  
  InitializeNetwork(@Network);
end;

procedure CheckInTcpClient(var AClient: PxlTcpClient);
begin
  if nil <> AClient then
  begin
    TcpClientDisconnect(AClient);
    FreeMem(AClient);
    AClient := nil;
  end;
end;

function TcpClientConnect(ATcpClient: PxlTcpClient; AConnectAddress: PxlNetServerAddress): Boolean;
var
  tmpRet: DWORD;
  tmpUlong: u_long;
  //strErr:string;
  tmpSockAddr: WinSock2.TSockAddrIn;
  tmpTimeOut: TTimeVal;
  tmpFDSet: TFDSet;
begin
  Result := false;
  //FUserCancelld := FALSE;
  if (Winsock2.INVALID_SOCKET = ATcpClient.Base.ConnectSocketHandle) or
     (0 = ATcpClient.Base.ConnectSocketHandle) then
  begin
    ATcpClient.Base.ConnectSocketHandle := Winsock2.Socket(AF_INET,SOCK_STREAM,0);
    if INVALID_SOCKET = ATcpClient.Base.ConnectSocketHandle then
    begin
      //RaiseWSExcption();
      exit;
    end;
  end;
  if nil <> AConnectAddress then
  begin
    ATcpClient.Base.ConnectAddress := AConnectAddress;
  end;
  if nil <> ATcpClient.Base.ConnectAddress then
  begin
    if '' = ATcpClient.Base.ConnectAddress.HOST then
    begin
      //raise Exception.Create('TsfSocket.Connect,HOST 为空');
    end;
    if 0 = ATcpClient.Base.ConnectAddress.Port then
    begin
      //raise Exception.Create('TsfSocket.Connect,PORT 必须大于 0');
    end;
  end;
  if ATcpClient.Base.TimeOutConnect > 0 then
  begin
    //设置非阻塞方式连接
    tmpUlong := 1;
    tmpRet := ioctlsocket(ATcpClient.Base.ConnectSocketHandle, FIONBIO, tmpUlong);
    if(DWORD(SOCKET_ERROR) = tmpRet) then
    begin
      tmpRet := Winsock2.WSAGetLastError();
      if 0 <> tmpRet then
      begin
      end;
      //strErr := GetLastErrorErrorMessage(iRet);
//      raise
//        exception.CreateFmt('Connect [1] socket error %d  %s',[iRet,strErr]);
    end;
  end;   
  ZeroMemory(@tmpSockAddr,SizeOf(tmpSockAddr));
  tmpSockAddr.sin_family      := AF_INET;
  if '' = AConnectAddress.Ip then
  begin
    AConnectAddress.Ip := Host2Ip(ATcpClient.Base.ConnectAddress.host);
  end;
  tmpSockAddr.sin_addr.S_addr := Winsock2.inet_addr(PAnsiChar(@AConnectAddress.Ip[1]));
  
  tmpSockAddr.sin_port        := Winsock2.htons(ATcpClient.Base.ConnectAddress.Port);
    // function connect(s: TSocket; name: PSockAddr; namelen: Integer): Integer; stdcall;
  Result := true;
  tmpRet := Winsock2.connect(ATcpClient.Base.ConnectSocketHandle, PSockAddr(@tmpSockAddr), SizeOf(tmpSockAddr));
  if DWORD(SOCKET_ERROR) = tmpRet then
  begin
    tmpRet := Winsock2.WSAGetLastError();
    if tmpRet <> WSAEWOULDBLOCK then
    begin         
      Result := false;
      //strErr := GetLastErrorErrorMessage(iRet);
      //raise exception.CreateFmt('Connect socket [2] error %d  %s',[iRet,strErr]);
    end;
  end;
  if ATcpClient.Base.TimeOutConnect > 0 then
  begin
    //select 模型，即设置超时
    tmpTimeOut.tv_sec  := ATcpClient.Base.TimeOutConnect div 1000;
    tmpTimeOut.tv_usec := ATcpClient.Base.TimeOutConnect mod 1000;
    // ---------------------------------
    //FD_ZERO(tmpFDSet);
    tmpFDSet.fd_count := 0;
    // ---------------------------------
    //FD_SET(ATcpClient.SocketHandle, tmpFDSet);        
    if tmpFDSet.fd_count < FD_SETSIZE then
    begin
      tmpFDSet.fd_array[tmpFDSet.fd_count] := ATcpClient.Base.ConnectSocketHandle;
      Inc(tmpFDSet.fd_count);
    end;
    // ---------------------------------
    tmpRet := WinSock2.select(0, nil{0}, @tmpFDSet, nil{0}, @tmpTimeOut);
    if tmpRet = 0 then //超时
    begin
      WinSock2.CloseSocket(ATcpClient.Base.ConnectSocketHandle);
      Result := false;
      //FErrorCode := WSAETIMEDOUT;//10060 连接超时
      //raise exception.CreateFmt('TsfSocket.Connect failure TimeOut %d ms',[ATcpClient.TimeOutConnect]);
    end;
    //一般非锁定模式套接比较难控制，可以根据实际情况考虑 再设回阻塞模式
    tmpUlong := 0;
    tmpRet := ioctlsocket(ATcpClient.Base.ConnectSocketHandle, FIONBIO, tmpUlong);
    if(DWORD(SOCKET_ERROR) = tmpRet) then
    begin
      //FErrorCode := Winsock2.WSAGetLastError();
      //strErr := GetLastErrorErrorMessage(iRet);
      //raise exception.CreateFmt('Connect socket [3] error %d  %s',[FErrorCode,strErr]);
      Result := false;
    end;
  end;     
  //FConnected := TRUE;
  //ATcpClient.RecvCount := 0;
  //ATcpClient.SendCount := 0;
end;

procedure TcpClientDisconnect(ATcpClient: PxlTcpClient);
var
  tmpLinger: TLinger;
begin
  if Winsock2.INVALID_SOCKET = ATcpClient.Base.ConnectSocketHandle then
    Exit;
  WinSock2.Shutdown(ATcpClient.Base.ConnectSocketHandle, SD_SEND);
  //Self.FErrorCode := 0;
  tmpLinger.l_onoff  := 1;
  tmpLinger.l_linger := 0;
  if SOCKET_ERROR = Winsock2.SetSockOpt(ATcpClient.Base.ConnectSocketHandle,
                        SOL_SOCKET,
                        SO_LINGER,
                        @tmpLinger,
                        SizeOf(tmpLinger)) then
  begin
   // ErrCode := WSAGetLastError();
   // TmpStr := IntToStr(ErrCode);
   // MessageBox(0,'aaaaaaaaaaaaaaaaaaa',PChar(TmpStr),0);
  end;
  //closesocket()的语义受SO_LINGER与SO_DONTLINGER选项影响，对比如下：
  //选项          间隔   关闭方式  等待关闭与否
  //SO_DONTLINGER 不关心 优雅      否
  //SO_LINGER     零     强制      否
  //SO_LINGER     非零   优雅      是

  //如无错误发生，则closesocket()返回0
  if 0 = Winsock2.CloseSocket(ATcpClient.Base.ConnectSocketHandle) then
  begin
    ATcpClient.Base.ConnectSocketHandle := Winsock2.INVALID_SOCKET;
  end else
  begin
    // 返回SOCKET_ERROR错误，应用程序可通过WSAGetLastError()获取
  end;
//  FConnected := FALSE;
//  FInputStream.Position := 0;
//  FInputStream.ReadEndPosition := 0;
//  Windows.ZeroMemory(FInputStream.Memory,FInputStream.Size);
end;

procedure TcpClientSetReadTimeOut(ANetClient: PxlTcpClient; const Value: Integer);
var
  tmpNetTimeout: Integer;
begin
  tmpNetTimeout := Value;
  if SOCKET_ERROR = WinSock2.Setsockopt(
               ANetClient.Base.ConnectSocketHandle,
               SOL_SOCKET,
               SO_RCVTIMEO,
               PAnsiChar(@tmpNetTimeout),
               Sizeof(tmpNetTimeout)) then
  begin
      //RaiseWSExcption();
  end;
end;

end.
