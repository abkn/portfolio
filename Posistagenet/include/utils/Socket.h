//
//  Socket2.hpp
//  psnserver
//
//  Created by 阿部拳太郎 on 2020/04/24.
//  Copyright © 2020 Kentaro Abe. All rights reserved.
//

#ifndef Socket_h
#define Socket_h

// platform detection

#define PLATFORM_WINDOWS  1
#define PLATFORM_MAC      2
#define PLATFORM_UNIX     3

#if defined(_WIN32)
    #define PLATFORM PLATFORM_WINDOWS
#elif defined(__APPLE__)
    #define PLATFORM PLATFORM_MAC
#else
    #define PLATFORM PLATFORM_UNIX
#endif

#if PLATFORM == PLATFORM_WINDOWS

    #include <winsock2.h>

#elif PLATFORM == PLATFORM_MAC || PLATFORM == PLATFORM_UNIX

    #include <sys/socket.h>
    #include <sys/types.h>
    #include <netinet/in.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <arpa/inet.h>

#endif

#if PLATFORM == PLATFORM_WINDOWS
    #pragma comment( lib, "wsock32.lib" )
#endif

#include <stdio.h>
#include <string>


//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#if PLATFORM == WINDOWS
class wsa_session
{
  public :

    wsa_session()
    {
        WSAStartup( MAKEWORD( 2 , 2 ) , &data_ ) ;
    }
    ~wsa_session()
    {
        WSACleanup() ;
    }


  private :

    WSAData data_ ;
} ;
#endif

class Socket
{
  public :

    Socket( void )
    {
        // UDP socket
        socket_ = socket( AF_INET , SOCK_DGRAM , IPPROTO_UDP ) ;

        // non blocking socket
        //u_long arg = 1 ;
        
    }

    ~Socket( void )
    {
        #if PLATFORM == PLATFORM_MAC || PLATFORM == PLATFORM_UNIX
        close( this->socket_ );
        #elif PLATFORM == PLATFORM_WINDOWS
        closesocket( this->socket_ );
        #endif
    }

    bool send_message( const std::string & address , unsigned short port , const ::std::string & message )
    {
        sockaddr_in add ;
        add.sin_family = AF_INET ;
        add.sin_addr.s_addr = inet_addr( address.c_str() ) ;
        //InetPton( AF_INET , address.c_str() , &add.sin_addr.s_addr ) ;
        add.sin_port = htons( port ) ;
        
        if ( sendto( socket_ , message.c_str() , (int)message.length() , 0 , (sockaddr*)&add , sizeof( add ) ) > 0 )
            //printf( "sucsess to send message\n" );
            return true ;
        
        printf( "failed to send message\n" );
        return false ;
    }

    bool receive_message( ::std::string & message , int max_size = 1500 )
    {
        
        if ( max_size <= 0 )
            return false ;

        char * buffer = (char *)malloc( max_size ) ;

        int byte_recv = recv( socket_ , buffer , max_size , 0 ) ;

        if ( byte_recv > 0 )
            message = ::std::string( buffer , byte_recv ) ;

        free( buffer ) ;

        return ( byte_recv > 0 ) ;
    }

    bool bind( unsigned short port )
    {
        sockaddr_in add ;
        add.sin_family = AF_INET ;
        add.sin_addr.s_addr = htonl( INADDR_ANY ) ;
        add.sin_port = htons( port ) ;

        if ( ::bind( socket_ , (const sockaddr*) &add, sizeof( add ) ) >= 0 )
            printf( "create socket\n" );
            return true ;

        return false ;
        
        #if PLATFORM == PLATFORM_MAC || PLATFORM == PLATFORM_UNIX

        int nonBlocking = 1;
        if ( fcntl( this->socket_,
                    F_SETFL,
                    O_NONBLOCK,
                    nonBlocking ) == -1 )
        {
            printf( "failed to set non-blocking\n" );
            return false;
        }
        printf( "set non-blocking\n" );

        #elif PLATFORM == PLATFORM_WINDOWS

        DWORD nonBlocking = 1;
        if ( ioctlsocket( socket_,
                          FIONBIO,
                          &nonBlocking ) != 0 )
        {
            printf( "failed to set non-blocking\n" );
            return false;
        }

        #endif
    }

    bool enable_send_message_multicast( void )
    {
        struct in_addr add ;
        add.s_addr = INADDR_ANY ;

        int result = setsockopt( socket_ ,
                           IPPROTO_IP ,
                           IP_MULTICAST_IF ,
                           (const char*)&add ,
                           sizeof( add ) ) ;
        return ( result != -1 ) ;
    }

    bool join_multicast_group( const ::std::string & ip_group )
    {
        struct ip_mreq imr;
        imr.imr_multiaddr.s_addr = inet_addr( ip_group.c_str() ) ;
        //InetPton( AF_INET , ip_group.c_str() , &imr.imr_multiaddr.s_addr ) ;
        imr.imr_interface.s_addr = INADDR_ANY ;

        int result = setsockopt( socket_ ,
                           IPPROTO_IP ,
                           IP_ADD_MEMBERSHIP ,
                           (char*) &imr ,
                           sizeof(struct ip_mreq) ) ;
        return ( result != -1 ) ;
    }

    bool leave_multicast_group( const ::std::string & ip_group )
    {
        struct ip_mreq imr;
        imr.imr_multiaddr.s_addr = inet_addr( ip_group.c_str() ) ;
        //InetPton( AF_INET , ip_group.c_str() , &imr.imr_multiaddr.s_addr ) ;
        imr.imr_interface.s_addr = INADDR_ANY ;

        int result = setsockopt( socket_ ,
                           IPPROTO_IP ,
                           IP_DROP_MEMBERSHIP ,
                           (char*) &imr ,
                           sizeof(struct ip_mreq) ) ;
        return ( result != -1 ) ;
    }

  private :

    unsigned int socket_ ;
} ;

#endif
