error_caption     db   'socket error', 0
socket_init_err   db   'Socket initialize failed', 0

wsa               WSADATA
sock_addr         sockaddr_in
soket_version     dd    0202h

ws_server_addr    sockaddr

bOptVal           dd    1
bOptLen           dd    $ - bOptVal

ws_server_addr_len   dd   sizeof.sockaddr  


