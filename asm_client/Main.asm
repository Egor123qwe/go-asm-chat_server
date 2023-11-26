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
  ;################## Server config block ######################
  ;Here you must select the protocol that is used on your server:
  ;========= protocol ====================
  mov [CLIENT_TYPE], WS_TCP ;WS_UDP/WS_TCP
  ;=======================================
  
  ;Here you must select the port that is used on your server:
  ;========= port ============
  mov [server_port_tcp], 10000
  mov [server_port_udp], 9999
  ;==========================
  ;##############################################################

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
  ;================================
  
  ;====== Creating a new socket ======
  stdcall ws_new_socket, [CLIENT_TYPE]
  mov [socket_handle], eax
  ;===================================
  
  ;======== Creating a structure for a new connection =========
  ;----- Selecting a port ------
  mov eax, [server_port_tcp]
  cmp [CLIENT_TYPE], WS_UDP 
  jnz @F
     mov eax, [server_port_udp]
  @@:
  ;-----------------------------
  stdcall ws_new_connection_structure, server_IP, eax
  ;eax - *sockaddr !!!
  ;============================================================

  ;====== TCP case ========
  cmp [CLIENT_TYPE], WS_TCP
  jnz @F
    ;connect to tcp server
    stdcall ws_tcp_connect, [socket_handle], eax
    ;tcp chat client example
    stdcall start_tcp_chat, [socket_handle], [hStdOut], [hStdIn]
  @@:
  ;=======================
  
  ;====== UDP case =======
  cmp [CLIENT_TYPE], WS_UDP
  jnz @F
    ;udp chat client example
    stdcall start_udp_chat, [socket_handle], eax, [hStdOut], [hStdIn]
  @@:
  ;=======================

Exit:
  stdcall ws_close_connection
  invoke  ExitProcess, 0

section '.data' data readable writeable
  ;== socket functions includes ==
  include 'socket\socket_data.inc'
  ;===============================
  
  ;===== examples includes =====
  include 'udp/udp_client.inc'
  include 'tcp/tcp_client.inc'
  ;=============================
  
  ;=========== server config ==============
  server_IP               db    '127.0.0.1', 0 
  server_port_tcp         dd    10000
  server_port_udp         dd    9999
  ;=========================================
  
  CLIENT_TYPE         dd    ?
  socket_handle       dd    ?
  
  ;========= Console data ==========
  conTitle      db 'Console', 0
  hStdIn        dd ?
  hStdOut       dd ?
  ;==================================

section '.idata' import data readable

  library kernel32, 'KERNEL32.DLL',\
          wsock32,  'WSOCK32.DLL',\
          user32,   'USER32.DLL'
          
  include 'api\kernel32.inc'
  include 'api\wsock32.inc'
  include 'api\user32.inc'