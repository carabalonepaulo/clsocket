# clsocket
Uma biblioteca simples que se restringe as funções básicas para comunicação por sockets.
* Simplicidade
* Portabilidade
* Velocidade

Por ser uma implementação minimalista da winsock, clsocket é extremamente portátil e fácil de utilizar, contém exemplos de implementações da biblioteca em [Moonscript](http://moonscript.org/).

### Instalação
Para utilizar a biblioteca basta baixar a [dll](https://github.com/paulo-soreto/clsocket/tree/master/bin) e cola na pasta principal do programa. Após isso você, caso você utilize Moonscript, Lua ou Ruby pode baixar as implementações dessas linguagens da pasta [src](https://github.com/paulo-soreto/clsocket/tree/master/src).

### O que falta?
- Portar o sistema para outras plataformas
- Disponibilizar implementações em outras linguagens

### Métodos
```c
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
int cls_gethostbyname(const char * addrname, char * buff);
```

### Licença
MIT
