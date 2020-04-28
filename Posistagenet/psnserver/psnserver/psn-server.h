//
//  psn-server.h
//  psnserver
//
//  Created by 阿部拳太郎 on 2020/04/28.
//  Copyright © 2020 Kentaro Abe. All rights reserved.
//

#ifndef psn_server_h
#define psn_server_h

#include "psn_lib.hpp"
#include "Socket2.h"
#include <cmath>
#include <iostream>
#include <list>
#include <string>

class psnserver{
    public:
        
        psnserver();
        
        void InitServer();
        void UpdateTrackers();
        void sendData();
        void sendInfo();
        void draw();
        
        //::psn::psn_encoder psn_encoder ;
         
     
    private:
        
        Socket2 socket_server ;
        ::psn::psn_encoder psn_encoder ;
        ::psn::tracker_map trackers ;
        float orbits[10] = { 1.0f , 88.0f , 224.7f , 365.2f , 687.0f , 4332.0f , 10760.0f , 30700.0f , 60200.0f , 90600.0f } ;
        float dist_from_sun[10] = { 0.0f , 0.58f , 1.08f , 1.50f , 2.28f , 7.78f , 14.29f , 28.71f , 45.04f , 59.13f } ;
        uint64_t timestamp ;
    
};


#endif /* psn_server_h */
