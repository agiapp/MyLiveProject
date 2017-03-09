//
//  APIConfig.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/21.
//  Copyright © 2017年 RENB. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

//信息类服务器地址
#define SERVER_HOST @"http://service.inke.com" // http://service.ingkee.com

//图片服务器地址
#define IMAGE_HOST @"http://img2.inke.cn/"

//banner
#define API_Feed @"api/feed/gather" //?uid=391980701&sid=20KnpRG0X7hiB3Lck8yUYWVnXsp4ux9MoLzi2phoQOAjyuSU5Ms

//广告地址
#define API_Advertise @"advertise/get"

//关注
#define API_Focus @"api/live/homepage" //?uid=391980701&hfv=1.1&type=1

//热门
#define API_HotLive @"api/live/gettop" //?uid=391980701

//附近
#define API_NearLive @"api/live/near_flow_old" //?&uid=391980701&latitude=30.281094&longitude=120.140750

//欢哥直播地址
#define Live_Dahuan @"rtmp://live.hkstv.hk.lxdns.com:1935/live/dahuan"


#endif /* APIConfig_h */
