write_msg_text_tcp      db   'Enter message: ', 0
write_msg_text_len_tcp  dd   $ - write_msg_text_tcp 

request_buf_tcp         db   100  dup  (?)

msg_send_err_tcp        db    'message send failed', 0
msg_get_err_tcp         db    'message get failed', 0

chrsRead_tcp            dd     ?
chrsWritten_tcp         dd     ?

response_buf_tcp        db    1024 dup (?)
response_buf_len_tcp    dd    $ - response_buf_tcp