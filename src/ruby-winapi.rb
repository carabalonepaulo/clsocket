class Socket
	cls_socket = Win32API.new 'clsocket.dll', 'cls_socket', 'iii', 'i'
	cls_connect = Win32API.new 'clsocket.dll', 'cls_connect', 'lpii', 'i'
	cls_bind = Win32API.new 'clsocket.dll', 'cls_bind', 'lpi', 'i'
	cls_listen = Win32API.new 'clsocket.dll', 'cls_listen', 'li', 'i'
	cls_pending = Win32API.new 'clsocket.dll', 'cls_pending', 'li', 'i'
	cls_accept = Win32API.new 'clsocket.dll', 'cls_accept', 'l', 'l'
	cls_send = Win32API.new 'clsocket.dll', 'cls_send', 'lp', 'i'
	cls_avaliable = Win32API.new 'clsocket.dll', 'cls_avaliable', 'l', 'i'
	cls_receive = Win32API.new 'clsocket.dll', 'cls_receive', 'lpi', 'i'
	cls_close = Win32API.new 'clsocket.dll', 'cls_close', 'l', 'i'

	def initialize(af, type, proto)
		 if af != nil && type == nil && proto == nil
		 	@descriptor = af
		 else
		 	@descriptor = cls_socket.call af, type, proto
		 end
		 raise 'socket error' if @descriptor == 1
	end

	def connect(host, port, family = 2)
		conn = cls_connect.call @descriptor, host, port, family
		raise 'connect error' if conn == 1
	end

	def bind(host, port)
		bind = cls_bind.call @descriptor, host, port
		raise 'bind error' if bind == 1
	end

	def listen(backlog)
		listen = cls_listen.call @descriptor, backlog
		raise 'listen error' if listen == 1
	end

	def pending(timeout)
		selc = cls_pending.call @descriptor, timeout
		raise 'pending error' if selc == 1
		return selc == 0
	end

	def accept
		sck = cls_accept.call @descriptor
		raise 'accept error' if sck == 1
		return Socket.new sck, nil, nil
	end

	def send(data)
		send = cls_send.call @descriptor, data
		raise 'send error' if send == 1
	end

	def receive(len)
		buff = "\0" * len
		recv = cls_receive.call @descriptor, buff, len
		raise 'receive error' if recv == 1
		return buff[0, len]
	end

	def avaliable
		av = cls_avaliable.call @descriptor
		raise 'avaliable error' if av == -1
		return av
	end

	def close
		cls_close.call @descriptor
	end
end

class TcpSocket < Socket
	def initialize(host, port)
		super 2, 1, 6
		connect host, port
	end
end