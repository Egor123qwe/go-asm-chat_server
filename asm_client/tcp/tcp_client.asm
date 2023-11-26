;example tcp client chat
proc start_tcp_chat, socket_handle, hStdOut, hStdIn
  .chat_loop:
    invoke WriteConsoleA, [hStdOut], write_msg_text_tcp, [write_msg_text_len_tcp], chrsWritten_tcp, 0
    ;Reading a message
    invoke ReadConsoleA, [hStdIn], request_buf_tcp, 255, chrsRead_tcp, 0
    
    ;Sending a message
    stdcall ws_socket_send_msg_tcp, [socket_handle], request_buf_tcp, [chrsRead_tcp]  
    cmp eax, SOCKET_ERROR
    jnz @F
      stdcall show_error, msg_send_err_tcp
      jmp .Exit
    @@:
    
    ;Receiving a message
    stdcall ws_socket_get_msg_tcp, [socket_handle], response_buf_tcp, [response_buf_len_tcp]  
    cmp eax, 0
    jge @F
      stdcall show_error, msg_get_err_tcp
      jmp .Exit
    @@:
    
    ;Message output
    mov word[response_buf_tcp + eax], $0D0A
    add eax, 2
    invoke WriteConsoleA, [hStdOut], response_buf_tcp, eax, chrsWritten_tcp, 0
  
  jmp .chat_loop
  
  .Exit:
  ret
endp