# TCP & UDP golang server + assambly client

This project has an examples for golang TCP and UDP server and assambly TCP and UDP client for windows.
In essence, this is a regular chat server, just with a possibly useful client implementation in assembler.

### Server
In the config you can change the "protocol" option to "udp" or "tcp" to switch protocol.
You can also use other parameters in the config.

### Client
The client implementation uses WinAPI to work with sockets, accordingly this example only works with Windows.

To implement the client, some abstractions were written over the standard WinAPI functions:

Functions:
  
