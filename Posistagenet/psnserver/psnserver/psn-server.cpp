//
//  main.cpp
//  psnserver
//
//  Created by 阿部拳太郎 on 2020/04/23.
//  Copyright © 2020 Kentaro Abe. All rights reserved.
//

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 VYV Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
**/
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#include "psn_lib.hpp"
#include "Socket.h"
#include <cmath>
#include <iostream>
#include <list>
#include <string>



int main( void )
{
    #if PLATFORM == PLATFORM_WINDOWS
    wsa_session session ;
    #endif

    //====================================================
    // Init server
    Socket socket_server ;
    socket_server.enable_send_message_multicast() ;

   
    ::psn::psn_encoder psn_encoder( "Test PSN Server" ) ;
    


    ::psn::tracker_map trackers ;
    int i = 0 ;
    trackers[ i ] = ::psn::tracker( i++ , "Sun" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Mercury" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Venus" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Earth" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Mars" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Jupiter" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Saturn" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Uranus" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Neptune" ) ;
    trackers[ i ] = ::psn::tracker( i++ , "Pluto" ) ;

    // Planets orbit in days
    float orbits[ 10 ] = { 1.0f , 88.0f , 224.7f , 365.2f , 687.0f , 4332.0f , 10760.0f , 30700.0f , 60200.0f , 90600.0f } ;
    // Planets distance from sun in million km x 100
    float dist_from_sun[ 10 ] = { 0.0f , 0.58f , 1.08f , 1.50f , 2.28f , 7.78f , 14.29f , 28.71f , 45.04f , 59.13f } ;
    
    uint64_t timestamp = 0 ;

    //====================================================
    // Main loop
    while ( true )
    {
        // Update trackers
        for ( int i = 1 ; i < 10 ; ++i ) // do not update the sun
        {
            float a = 1.0f / orbits[ i ] ;
            float b = dist_from_sun[ i ] ;
            float x = (float)timestamp ;
            float cb = ::std::cosf( a * x ) * b ;
            float sb = ::std::sinf( a * x ) * b ;
            
            trackers[ i ].set_pos( ::psn::float3( sb , 0 , cb ) ) ;
            trackers[ i ].set_speed( ::psn::float3( a * cb , 0 , -a * sb )  ) ;
            trackers[ i ].set_ori( ::psn::float3( 0 , x / 1000.0f , 0 ) ) ;
            trackers[ i ].set_accel( ::psn::float3( ::psn::float3( -a * a * sb , 0 , -a * a * cb )  ) ) ;
            trackers[ i ].set_target_pos( ::psn::float3( 3 , 14 , 16 ) ) ;
            trackers[ i ].set_status( i / 10.0f ) ;
            trackers[ i ].set_timestamp( timestamp ) ;
        }

        // Send data
        if ( timestamp % 16 == 0 ) // transmit data at 60 Hz approx.
        {
            ::std::list< ::std::string > data_packets = psn_encoder.encode_data( trackers , timestamp ) ;

            ::std::cout << "--------------------PSN SERVER-----------------" << ::std::endl ;
            ::std::cout << "Sending PSN_DATA_PACKET : "
                        << "Frame Id = " << (int)psn_encoder.get_last_data_frame_id()
                        << " , Packet Count = " << data_packets.size() << ::std::endl ;

            for ( auto it = data_packets.begin() ; it != data_packets.end() ; ++it )
            {
                // Uncomment these lines if you want to simulate a packet drop now and then
                /*static uint64_t packet_drop = 0 ;
                if ( packet_drop++ % 100 != 0 )*/
                    socket_server.send_message( ::psn::DEFAULT_UDP_MULTICAST_ADDR , ::psn::DEFAULT_UDP_PORT , *it ) ;
                if(socket_server.send_message( ::psn::DEFAULT_UDP_MULTICAST_ADDR , ::psn::DEFAULT_UDP_PORT , *it )){
                    printf( "sucsess to send data\n" );
                }
                
            }

            ::std::cout << "-----------------------------------------------" << ::std::endl ;
        }

        // Send Info
        if ( timestamp % 1000 == 0 ) // transmit info at 1 Hz approx.
        {
            ::std::list< ::std::string > info_packets = psn_encoder.encode_info( trackers , timestamp ) ;

            ::std::cout << "--------------------PSN SERVER-----------------" << ::std::endl ;
            ::std::cout << "Sending PSN_INFO_PACKET : "
                        << "Frame Id = " << (int)psn_encoder.get_last_info_frame_id()
                        << " , Packet Count = " << info_packets.size() << ::std::endl ;
   
            for ( auto it = info_packets.begin() ; it != info_packets.end() ; ++it )
            {
                socket_server.send_message( ::psn::DEFAULT_UDP_MULTICAST_ADDR , ::psn::DEFAULT_UDP_PORT , *it ) ;
                if(socket_server.send_message( ::psn::DEFAULT_UDP_MULTICAST_ADDR ,::psn::DEFAULT_UDP_PORT , *it )){
                printf( "sucsess to send info\n" );
                }
            }
                

            ::std::cout << "-----------------------------------------------" << ::std::endl ;
        }

        sleep( 1 ) ;
        timestamp++ ;
    }
}
