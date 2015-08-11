local ffi = require('ffi')
ffi.cdef([[    typedef long SOCKET;
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
]])
local clsocket = ffi.load('clsocket.dll')
local Socket
do
  local _base_0 = {
    connect = function(self, host, port, family)
      if family == nil then
        family = nil
      end
      local conn = clsocket.cls_connect(self.descriptor, host, port, family or 2)
      if conn == 1 then
        return error('error connect')
      end
    end,
    bind = function(self, host, port)
      local bind = clsocket.cls_bind(self.descriptor, host, port)
      if bind == 1 then
        return error('error bind')
      end
    end,
    listen = function(self, backlog)
      local listen = clsocket.cls_listen(self.descriptor, backlog)
      if listen == 1 then
        return error('error listen')
      end
    end,
    accept = function(self)
      local sck = clsocket.cls_accept(self.descriptor)
      if sck == 1 then
        error('error accept')
      end
      return Socket(sck, nil, nil)
    end,
    send = function(self, message)
      local send = clsocket.cls_send(self.descriptor, message)
      if send == 1 then
        return error('error send')
      end
    end,
    receive = function(self, len)
      local buff = ffi.new('char[?]', len)
      local recv = clsocket.cls_receive(self.descriptor, buff, len)
      if recv == 1 then
        error('error receive')
      end
      return ffi.string(buff):sub(0, len)
    end,
    avaliable = function(self)
      local av = clsocket.cls_avaliable(self.descriptor)
      if av == -1 then
        error('error avaliable')
      end
      return av
    end,
    close = function(self)
      return clsocket.cls_close(self.descriptor)
    end,
    pending = function(sck, timeout)
      if type(sck ~= 'number') then
        sck = sck.socket
      end
      local selc = clsocket.cls_pending(sck, timeout)
      if selc == 1 then
        error('error select')
      end
      return selc == 0
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, af, ty, family)
      if af ~= nil and ty == nil and family == nil then
        self.descriptor = af
      else
        self.descriptor = clsocket.cls_socket(af, ty, family)
      end
      if self.descriptor == 1 then
        return error('error socket')
      end
    end,
    __base = _base_0,
    __name = "Socket"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Socket = _class_0
end
return {
  Socket = Socket
}
