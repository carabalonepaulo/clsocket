#include <winsock2.h>
#include "main.h"

int DLL_EXPORT cls_socket(int af, int type, int proto) {
    WSADATA wsa;
    SOCKET s;

    if (WSAStartup(MAKEWORD(2,2), &wsa) != 0)
        return 1;

    s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(s == INVALID_SOCKET) {
        WSACleanup();
        return 1;
    }

    return s;
}

int DLL_EXPORT cls_connect(SOCKET s, const char * host, int port, int family) {
    struct sockaddr_in server;
    server.sin_addr.s_addr = inet_addr(host);
    server.sin_family = family;
    server.sin_port = htons(port);

    if (connect(s , (struct sockaddr *)&server , sizeof(server)) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }

    return 0;
}

int DLL_EXPORT cls_bind(SOCKET s, const char * host, int port) {
    struct sockaddr_in service;
    service.sin_family = AF_INET;
    service.sin_addr.s_addr = inet_addr(host);
    service.sin_port = htons(port);

    if (bind(s, (SOCKADDR *) &service, sizeof (service)) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }

    return 0;
}

int DLL_EXPORT cls_listen(SOCKET s, int backlog) {
    if (listen(s, backlog) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }
    return 0;
}

int DLL_EXPORT cls_select(SOCKET s, int tmout) {
    fd_set readfds;
    FD_ZERO(&readfds);
    FD_SET(s, &readfds);

    TIMEVAL timeout;
    timeout.tv_sec = tmout;
    timeout.tv_usec = 0;

    if (select(0, &readfds, NULL, NULL, &timeout) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }

    if (FD_ISSET(s, &readfds))
        return 0;
    else
        return -1;
}

SOCKET DLL_EXPORT cls_accept(SOCKET s) {
    SOCKET acp;
    acp = accept(s, NULL, NULL);
    if (acp == INVALID_SOCKET) {
        WSACleanup();
        return 1;
    }
}

int DLL_EXPORT cls_send(SOCKET s, const char * message) {
    if (send(s, message, strlen(message), 0) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }
    return 0;
}

int DLL_EXPORT cls_avaliable(SOCKET s) {
    u_long n = -1;
    if (ioctlsocket(s, FIONREAD, &n) < 0) {
        WSACleanup();
        return 1;
    }
    return n;
}

int DLL_EXPORT cls_receive(SOCKET s, char * buffer, int len) {
    if (recv(s, buffer, len, 0) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }
    return 0;
}

int DLL_EXPORT cls_close(SOCKET s) {
    if (closesocket(s) == SOCKET_ERROR)
        return 1;
    WSACleanup();
    return 0;
}
