print 'Iniciando servidor...'
sck = Socket 2, 1, 6
sck\bind '127.0.0.1', 5000
sck\listen 128

client = sck\accept!
print 'Conexao aceita!'

while true
	av = client\avaliable!
	if av > 0
		print av..' bytes disponiveis...'
		print 'Recebeu: '..client\receive av
		break
client\close!

sck\close!
sck = nil
print 'Servidor encerrado!'