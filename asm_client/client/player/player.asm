proc client.Subscribe_PlayerData, posAddr, turnAddr, HandItemAddr, PlayerState

  ;Init addreses
  mov eax, [posAddr]
  mov [cl_PosAddr], eax
  mov eax, [turnAddr]
  mov [cl_TurnAddr], eax
  mov eax, [HandItemAddr]
  mov [cl_HandItemAddr], eax
  mov eax, [PlayerState]
  mov [cl_StateAddr], eax
  
  stdcall _client.CopyPlayerData
  ret
endp




proc _client.StartServe_PlayerData uses esi, args
  mov esi, [args]
  ;===================================
  ;udp_socket_handle     = [esi]
  ;udp_soket_data_addr   = [esi + 4]
  ;playerId              = [esi + 8]
  ;groopId               = [esi + 12]
  ;sleepTime             = [esi + 16]
  ;===================================
  
  .ServeCircle:
      stdcall _client.CmpPlayerData
      cmp eax, 1
      jne .SkipSend
        ;Create a message
        
        ;Sending a message
        stdcall ws_socket_send_msg_udp, [esi], [esi + 4], tmp_mess, 5 
    
      .SkipSend:
      invoke Sleep, [esi + 16]
  jmp .ServeCircle  


  xor eax, eax
  ret
endp

proc client.Serve_PlayerData, udp_socket_handle, udp_soket_data_addr, playerId, groopId, sleepTime
  mov ecx, 0
  .writeArg:
     mov eax, [ebp + ecx + 8]
     mov [cl_ServeFuncARGS + ecx], eax 
  add ecx, 4
  cmp ecx, 5 * 4 
  jnz .writeArg
  
  invoke CreateThread, 0, 0, _client.StartServe_PlayerData, cl_ServeFuncARGS, 0, 0
  
  ret
endp