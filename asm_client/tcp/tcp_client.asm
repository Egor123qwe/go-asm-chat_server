;example tcp client chat
proc start_tcp_chat, socket_handle, hStdOut, hStdIn
  .chat_loop:
    invoke WriteConsoleA, [hStdOut], write_msg_text_tcp, [write_msg_text_len_tcp], chrsWritten_tcp, 0
    ;Reading a message
    invoke ReadConsoleA, [hStdIn], request_buf_tcp, 255, chrsRead_tcp, 0
    
    ;Sending a message
    
    ;Receiving a message
    
    ;Message output
  
  jmp .chat_loop
  
  .Exit:
  ret
endp