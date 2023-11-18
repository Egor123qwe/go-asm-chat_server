proc ws_soket_init
  invoke WSAStartup, [soket_version], wsa
  cmp eax, 0
  jne .error
  jmp .return
  .error:
     stdcall ws_socket_error, socket_init_err
     stdcall ws_close_connection
  .return:
  ret
endp

proc ws_new_socket, socket_type  ;WS_UDP/WS_TCP
  invoke socket, AF_INET, SOCK_DGRAM, IPPROTO_UDP
  cmp eax, INVALID_SOCKET
  je .error  
  push eax 
  
  invoke setsockopt, eax, SOL_SOCKET, SO_KEEPALIVE, bOptVal, [bOptLen]
  cmp eax, 0
  jnz .error
    
  pop eax     
  jmp .return
  .error:
      stdcall ws_socket_error, socket_init_err    
  .return:
  ;return socket discriptor in eax
  ret
endp

proc ws_new_connection_structure, ip, port
  
  mov     [sock_addr.sin_family], AF_INET
  invoke  htons, [port]
  mov     [sock_addr.sin_port], ax 
  invoke  inet_addr, [ip]
  mov     [sock_addr.sin_addr], eax
  
  ;return sock_addr structure in eax
  mov eax, sock_addr

  ret
endp

proc ws_close_connection
  invoke WSACleanup
  ret
endp

proc ws_socket_error, err
  invoke MessageBoxA, 0, [err], error_caption, 0
  ret
endp                     