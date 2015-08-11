ffi = require 'ffi'

ffi.cdef [[
    typedef long SOCKET;
    int cls_socket(int af, int type, int proto);
    int cls_connect(SOCKET s, const char * host, int port, int family);
    int cls_bind(SOCKET s, const char * host, int port);
    int cls_listen(SOCKET s, int backlog);
    int cls_pending(SOCKET s, int tmout);
    SOCKET cls_accept(SOCKET s);
    int cls_send(SOCKET s, const char * message);
    int cls_avaliable(SOCKET s);
    int cls_receive(SOCKET s, char * buffer, int len);
    int cls_close(SOCKET s);
]]

clsocket = ffi.load 'clsocket.dll'

class Socket
    new: (af, ty, family) =>
    	if af ~= nil and ty == nil and family == nil
    		@descriptor = af
    	else
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
        sck = clsocket.cls_accept @descriptor
        if sck == 1 then error 'error accept'
        return Socket sck, nil, nil

    send: (message) =>
        send = clsocket.cls_send @descriptor, message
        if send == 1 then error 'error send'

    receive: (len) =>
        buff = ffi.new 'char[?]', len
        recv = clsocket.cls_receive @descriptor, buff, len
        if recv == 1 then error 'error receive'
        return ffi.string(buff)\sub 0, len

    avaliable: =>
        av = clsocket.cls_avaliable @descriptor
        if av == -1 then error 'error avaliable'
        return av

    close: =>
        clsocket.cls_close @descriptor

    pending: (timeout) =>
        selc = clsocket.cls_pending @descriptor, timeout
        if selc == 1 then error 'error select'
        return selc == 0

{ :Socket }