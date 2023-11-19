format PE Console 4.0
entry Start

include 'win32a.inc'
include 'socket\socket_main.asm'
;usage examples
include 'udp/udp_client.asm'
include 'tcp/tcp_client.asm'

section '.text' code readable executable

Start:
  mov [CLIENT_TYPE], WS_UDP ;WS_UDP/WS_TCP

  ;console init
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
  stdcall ws_new_socket, [CLIENT_TYPE]
  mov [socket_handle], eax
  
  ;Creating a structure for a new connection
  stdcall ws_new_connection_structure, server_IP, [server_port]
  ;eax - *sockaddr

  cmp [CLIENT_TYPE], WS_TCP
  jnz @F
    stdcall ws_tcp_connect, [socket_handle], eax
    stdcall start_tcp_chat, [socket_handle], [hStdOut], [hStdIn]
  @@:
  
  cmp [CLIENT_TYPE], WS_UDP
  jnz @F
    stdcall start_udp_chat, [socket_handle], eax, [hStdOut], [hStdIn]
  @@:

Exit:
  stdcall ws_close_connection
  invoke  ExitProcess, 0

section '.data' data readable writeable
  include 'socket\socket_data.inc'
  include 'udp/udp_client.inc'
  include 'tcp/tcp_client.inc'
  
  CLIENT_TYPE         dd    ?
  
  ;server config
  server_IP           db    '127.0.0.1', 0 
  server_port         dd    8080
  
  socket_handle       dd    ?
  
  conTitle      db 'Console', 0
  hStdIn        dd ?
  hStdOut       dd ?

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          wsock32,  'WSOCK32.DLL',\
          user32,   'USER32.DLL'
          
  import user32,\
          MessageBoxA, 'MessageBoxA'
          
  include 'api\kernel32.inc'
  include 'api\wsock32.inc'