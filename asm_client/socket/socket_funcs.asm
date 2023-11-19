;wrapper function for send data to server (TCP/UDP)
proc ws_socket_send_msg, socket, soket_info, msg, msg_len, socket_type 
  ;upd case
  cmp [socket_type], WS_UDP
  jnz @F
    invoke sendto, [socket], [msg], [msg_len], 0, [soket_info], sizeof.sockaddr_in
    jmp .return
  @@:
  ;tcp case
  cmp [socket_type], WS_TCP
  jnz @F
    invoke send, [socket], [msg], [msg_len], 0
    jmp .return
  @@:
  
  .return:
  ret
endp

;wrapper function for get data from server (TCP/UDP)
proc ws_socket_get_msg, socket, buf, buf_len 
  invoke recvfrom, [socket], [buf], [buf_len], 0, ws_server_addr, ws_server_addr_len

  ;return number of bytes received in eax
  ret
endp