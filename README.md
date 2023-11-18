# Minicraft-Server


Описание примера с клиента
### udp_example api
Инициализация сокета:
stdcall soket_init 
  - return socket discriptor in eax

Создание структуры для нового подсоединения:
stdcall new_connection, [udp_soket], server_IP, [server_port] 
  - return *sock_addr structure in eax 
  
Отправка соединения для полученного соединения:
stdcall udp_send, [udp_soket], [soket_data], message, [message_len]  
  - return result of send (if err: eax = SOCKET_ERROR)
  
Закрытие соединения:
  -stdcall close_connection
