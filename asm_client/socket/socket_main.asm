include 'socket_consts.asm'
include 'socket_funcs.asm'

;init socket library
proc ws_soket_init
  invoke WSAStartup, [ws_soket_version], ws_wsa
  ret
endp

;wrapper function for create socket (TCP/UDP)
proc ws_new_socket, socket_type  ;WS_UDP/WS_TCP
  locals 
    type            dd    ?
    protocol        dd    ?
    socket_handle   dd    ?
  endl

  ;UDP case
  cmp [socket_type], WS_UDP
  jnz @F
    mov [type],     SOCK_DGRAM
    mov [protocol], IPPROTO_UDP 
    jmp .data_ready
  @@:
  ;TCP case
  cmp [socket_type], WS_TCP
  jnz @F
    mov [type],     SOCK_STREAM
    mov [protocol], IPPROTO_TCP
    jmp .data_ready
  @@:
  ;else
  jmp .error
  .data_ready:
  
  invoke socket, AF_INET, [type], [protocol]
  cmp eax, INVALID_SOCKET
  jz .error
  mov [socket_handle], eax
                                            
  invoke setsockopt, eax, SOL_SOCKET, SO_KEEPALIVE, ws_bOptVal, [ws_bOptLen]
  cmp eax, 0
  jnz .error
      
  jmp .return
  .error:
      ;return error discriptor
      mov [socket_handle], 0 
  .return:
  ;return socket discriptor in eax
  mov eax, [socket_handle]
  ret
endp

;wrapper function for create connection structure (TCP/UDP)
proc ws_new_connection_structure, ip, port

  invoke GetProcessHeap
  invoke HeapAlloc, eax, 0, sizeof.sockaddr_in
  mov esi, eax
  
  mov     [esi + sockaddr_in.sin_family], AF_INET
  invoke  htons, [port]
  mov     [esi + sockaddr_in.sin_port], ax 
  invoke  inet_addr, [ip]
  mov     [esi + sockaddr_in.sin_addr], eax
  
  ;return sock_addr structure in eax
  mov eax, esi

  ret
endp

;wrapper function for tcp connection
proc ws_tcp_connect, socket_handle, server_addr
  invoke connect, [socket_handle], [server_addr], sizeof.sockaddr
  ret
endp

;wrapper function for close socket
proc ws_close_connection
  invoke WSACleanup
  ret
endp                   