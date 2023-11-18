proc ws_sokcet_send_msg, socket, soket_info, msg, msg_len 
  invoke sendto, [socket], [msg], [msg_len], 0, [soket_info], sizeof.sockaddr_in

  ret
endp

proc ws_socket_get_msg, socket, buf, buf_len 
  invoke recvfrom, [socket], [buf], [buf_len], 0, server_addr, server_addr_len
  
  
  ret
endp