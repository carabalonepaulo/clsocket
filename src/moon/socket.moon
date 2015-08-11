ffi = require 'ffi'

ffi.cdef [[
    typedef long SOCKET;
    int cls_socket(int af, int type, int proto);
    int cls_connect(SOCKET s, const char * host, int port, int family);
    int cls_bind(SOCKET s, const char * host, int port);
    int cls_listen(SOCKET s, int backlog);
    int cls_select(SOCKET s, int tmout);
    SOCKET cls_accept(SOCKET s);
    int cls_send(SOCKET s, const char * message);
    int cls_avaliable(SOCKET s);
    int cls_receive(SOCKET s, char * buffer, int len);
    int cls_close(SOCKET s);
]]

clsocket = ffi.load 'clsocket.dll'

class Socket
    new: (af, ty, family) =>
        @descriptor = clsocket.cls_socket(af, ty, family)
        if @descriptor == 1 then error 'error socket'

    connect: (host, port, family = nil) =>
        conn = clsocket.cls_connect @descriptor, host, port, family or 2
        if conn == 1 then error 'error connect'           

    bind: (host, port) =>
        bind = clsocket.cls_bind @descriptor, host, port
        if bind == 1 then error 'error bind'

    listen: (backlog) =>
        listen = clsocket.cls_listen @descriptor, backlog
        if listen == 1 then error 'error listen'

    accept: =>
        sck = clsocket.cls_accept!
        if sck == 1 then error 'error accept'
        return sck

    send: (message) =>
        send = clsocket.cls_send @descriptor, message
        if send == 1 then error 'error send'

    receive: (len) =>
        buff = ffi.new 'char[?]', len
        recv = clsocket.cls_receive @descriptor, buff, len
        if recv == 1 then error 'error receive'
        return ffi.string(buff)

    avaliable: =>
        av = clsocket.cls_avaliable @descriptor
        if av == -1 then error 'error avaliable'
        return av

    close: =>
        clsocket.cls_close @descriptor

    select: (sck, timeout) ->
        if type sck ~= 'number' then sck = sck.socket
        selc = clsocket.cls_select sck, timeout
        if selc == 1 then error 'error select'
        return selc == 0

{ :Socket, :AsyncTcpServer }