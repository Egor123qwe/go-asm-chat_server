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
  
  ;Инициализация библиотеки
  stdcall ws_soket_init
  
  ;создание нового сокета
  stdcall ws_new_socket, WS_UDP  ;WS_TCP
  mov [socket_handle], eax
  
  ;Создание структуры для нового подсоединения
  stdcall ws_new_connection_structure, server_IP, [server_port]
  mov [soket_data], eax
  
  ;Отправка соединения для полученного соединения
  stdcall ws_sokcet_send_msg, [socket_handle], [soket_data], message, [message_len]  
  ;Пример обработки ошибки
  cmp eax, SOCKET_ERROR
  jnz @F
    stdcall ws_socket_error, msg_send_err
    jmp Exit
  @@:
  
  stdcall ws_socket_get_msg, [socket_handle], request_buf, [request_buf_len] 
  ;Пример обработки ошибки
  cmp eax, 0
  jge @F
    stdcall ws_socket_error, msg_get_err
    jmp Exit
  @@:
  
  ;вывод сообщения:
  invoke WriteConsoleA, [hStdOut], request_buf, [request_buf_len], chrsWritten, 0
  
  invoke ReadConsoleA, [hStdIn], readBuf, 1, chrsRead, 0

Exit:
  stdcall ws_close_connection
  invoke  ExitProcess, 0

section '.data' data readable writeable
  include 'socket_data.inc'
  
  ;server config
  server_IP     db    '127.0.0.1', 0
  server_port   dd    8080
  
  ;
  socket_handle dd    ?
  soket_data    dd    ?
  
  message       db    'Hello, server!', 0
  message_len   dd    $ - message
  
  msg_send_err  db    'message sand failed', 0
  msg_get_err   db    'message get failed', 0
  
  request_buf      db    1024 dup (?)
  request_buf_len  dd    $ - request_buf


  conTitle      db 'Console', 0
  hStdIn        dd ?
  hStdOut       dd ?
  chrsRead      dd ?
  chrsWritten   dd ?
  

section '.bss' readable writeable
  readBuf          db    ?

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          wsock32,  'WSOCK32.DLL',\
          user32,   'USER32.DLL'
          
  import user32,\
          MessageBoxA, 'MessageBoxA'
          
  include 'api\kernel32.inc'
  include 'api\wsock32.inc'