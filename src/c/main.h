#ifndef __MAIN_H__
#define __MAIN_H__

#include <windows.h>

/*  To use this exported function of dll, include this header
 *  in your project.
 */

#ifdef BUILD_DLL
    #define DLL_EXPORT __declspec(dllexport)
#else
    #define DLL_EXPORT __declspec(dllimport)
#endif


#ifdef __cplusplus
extern "C"
{
#endif

int DLL_EXPORT cls_socket(int af, int type, int proto);
int DLL_EXPORT cls_connect(SOCKET s, const char * host, int port, int family);
int DLL_EXPORT cls_bind(SOCKET s, const char * host, int port);
int DLL_EXPORT cls_listen(SOCKET s, int backlog);
int DLL_EXPORT cls_select(SOCKET s, int tmout);
SOCKET DLL_EXPORT cls_accept(SOCKET s);
int DLL_EXPORT cls_send(SOCKET s, const char * message);
int DLL_EXPORT cls_avaliable(SOCKET s);
int DLL_EXPORT cls_receive(SOCKET s, char * buffer, int len);
int DLL_EXPORT cls_close(SOCKET s);

#ifdef __cplusplus
}
#endif

#endif // __MAIN_H__
