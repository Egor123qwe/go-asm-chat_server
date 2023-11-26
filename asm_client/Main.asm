format PE Console 4.0
entry Start

include 'win32a.inc'
;socket functions for tcp & udp:
include 'socket\socket_main.asm'
;===== usage examples ======
;udp example:
include 'udp/udp_client.asm'
;tcp example:
include 'tcp/tcp_client.asm'
;===========================

section '.text' code readable executable

Start:      
  ;You can delete this block and use default values...
  ;==============================================================             
  ;Here you must select the protocol that is used on your server:
  ;----------- protocol ------------------
  mov [protocol], WS_TCP ;WS_UDP/WS_TCP
  ;---------------------------------------
  ;Here you must select the port that is used on your server:
  ;---------- port -----------
  mov [server_port_udp], 9999
  mov [server_port_tcp], 10000
  ;---------------------------
  ;===============================================================

  ;======== Console init ==========
  invoke SetConsoleTitleA, conTitle
  test eax, eax
  jz Exit
  invoke GetStdHandle, -10
  mov [hStdIn], eax
  invoke GetStdHandle, -11
  mov [hStdOut], eax
  ;================================
  
  ;=== Initializing the library ===
  stdcall ws_soket_init
  cmp eax, 0
  jz @F
     stdcall ws_close_connection
     stdcall show_error, socket_init_err
  @@:
  ;================================
  
  ;====== Creating a new socket ======
  stdcall ws_new_socket, [protocol]
  cmp eax, 0
  jnz @F
    stdcall show_error, socket_create_err 
  @@: 
  mov [socket_handle], eax
  ;===================================
  
  ;======== Creating a structure for a new connection =========
  ;----- Selecting a port ------
  mov eax, [server_port_tcp]
  cmp [protocol], WS_UDP 
  jnz @F
     mov eax, [server_port_udp]
  @@:
  ;-----------------------------
  stdcall ws_new_connection_structure, server_IP, eax
  ;eax - *sockaddr !!!
  ;============================================================

  ;====== TCP case ========
  cmp [protocol], WS_TCP
  jnz .not_tcp
    ;connect to tcp server
    stdcall ws_tcp_connect, [socket_handle], eax
    cmp eax, 0
    jz @F
       stdcall show_error, tcp_connect_err  
    @@:
    ;TCP chat client example
    stdcall start_tcp_chat, [socket_handle], [hStdOut], [hStdIn]
  .not_tcp:
  ;=======================
  
  ;====== UDP case =======
  cmp [protocol], WS_UDP
  jnz .not_udp
    ;UDP chat client example
    stdcall start_udp_chat, [socket_handle], eax, [hStdOut], [hStdIn]
  .not_udp:
  ;=======================

Exit:
  stdcall ws_close_connection
  invoke  ExitProcess, 0
  
  
;Error helper
proc show_error, err
  invoke MessageBoxA, 0, [err], error_caption, 0
  ret
endp  

section '.data' data readable writeable
  ;== socket functions includes ==
  include 'socket\socket_data.inc'
  ;===============================
  
  ;===== examples includes =====
  include 'udp/udp_client.inc'
  include 'tcp/tcp_client.inc'
  ;=============================
  
  ;=========== server config ==============
  ;Default values for server config:
  protocol                dd    ?
  server_IP               db    '127.0.0.1', 0 
  server_port_tcp         dd    10000
  server_port_udp         dd    9999
  ;=========================================
  
  socket_handle       dd    ?
  
  ;========= Console data ==========
  conTitle      db 'Console', 0
  hStdIn        dd ?
  hStdOut       dd ?
  ;==================================
  
  ;======== Errors messages =========
  error_caption     db   'socket error', 0
  socket_init_err   db   'Socket initialize failed', 0
  socket_create_err db   'Socket creation failed', 0
  tcp_connect_err   db   'TCP connection failed', 0
  ;==================================

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          wsock32,  'WSOCK32.DLL',\
          user32,   'USER32.DLL'
          
  include 'api\kernel32.inc'
  include 'api\wsock32.inc'
  include 'api\user32.inc'