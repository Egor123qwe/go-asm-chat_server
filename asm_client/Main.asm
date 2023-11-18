format PE Console 4.0
entry Start

include 'win32a.inc'

include 'socket_consts.asm'
include 'socket_main.asm'
include 'socket_client.asm'

section '.text' code readable executable

Start:
  invoke SetConsoleTitleA, conTitle
  test eax, eax
  jz Exit
  invoke GetStdHandle, -10
  mov [hStdIn], eax
  invoke GetStdHandle, -11
  mov [hStdOut], eax
  
  ;Initializing the library
  stdcall ws_soket_init
  
  ;Creating a new socket
  stdcall ws_new_socket, WS_UDP  ;WS_UDP/WS_TCP
  mov [socket_handle], eax
  
  ;Creating a structure for a new connection
  stdcall ws_new_connection_structure, server_IP, [server_port]
  mov [soket_data_addr], eax
  
  chat_loop:
    invoke WriteConsoleA, [hStdOut], write_msg_text, [write_msg_text_len], chrsWritten, 0
    ;Reading a message
    invoke ReadConsoleA, [hStdIn], request_buf, 255, chrsRead, 0
    
    ;Sending a message
    stdcall ws_sokcet_send_msg, [socket_handle], [soket_data_addr], request_buf, [chrsRead]  
    cmp eax, SOCKET_ERROR
    jnz @F
      stdcall ws_socket_error, msg_send_err
      jmp Exit
    @@:
    
    ;Receiving a message
    stdcall ws_socket_get_msg, [socket_handle], response_buf, [response_buf_len]  
    cmp eax, 0
    jge @F
      stdcall ws_socket_error, msg_get_err
      jmp Exit
    @@:
    
    ;Message output
    mov word[response_buf + eax], $0D0A
    add eax, 2
    invoke WriteConsoleA, [hStdOut], response_buf, eax, chrsWritten, 0
  jmp chat_loop

Exit:
  stdcall ws_close_connection
  invoke  ExitProcess, 0

section '.data' data readable writeable
  include 'socket_data.inc'
  
  ;server config
  server_IP           db    '127.0.0.1', 0    ;10.211.55.4
  server_port         dd    8080
  
  socket_handle       dd    ?
  soket_data_addr     dd    ?
  
  msg_send_err        db    'message send failed', 0
  msg_get_err         db    'message get failed', 0
  
  response_buf        db    1024 dup (?)
  response_buf_len    dd    $ - response_buf


  write_msg_text      db   'Enter message: ', 0
  write_msg_text_len  dd   $ - write_msg_text 
  request_buf         db   100  dup  (0)
  
  conTitle      db 'Console', 0
  hStdIn        dd ?
  hStdOut       dd ?
  chrsRead      dd ?
  chrsWritten   dd ?

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          wsock32,  'WSOCK32.DLL',\
          user32,   'USER32.DLL'
          
  import user32,\
          MessageBoxA, 'MessageBoxA'
          
  include 'api\kernel32.inc'
  include 'api\wsock32.inc'