print('Iniciando servidor...')
local sck = Socket(2, 1, 6)
sck:bind('127.0.0.1', 5000)
sck:listen(128)
local client = sck:accept()
print('Conexao aceita!')
while true do
  local av = client:avaliable()
  if av > 0 then
    print(av .. ' bytes disponiveis...')
    print('Recebeu: ' .. client:receive(av))
    break
  end
end
client:close()
sck:close()
sck = nil
return print('Servidor encerrado!')
