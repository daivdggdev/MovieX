//
//  XEmsManager.m
//  PPStreamX
//
//  Created by 王大伟 on 14-1-5.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import "XEmsManager.h"
//#import "ems_server.h"
#import "pps.h"

NSString * const XEmsManagerVodBufferingEventNotification = @"ems_buffering";
NSString * const XEmsManagerVodBufferDoneEventNotification = @"XEmsManagerVodBufferDoneEventNotification";

@implementation XEmsManager

int32 ems_event_listenerx(int32 index, ems_event event)
{
    NSLog(@"event id = %d", event.event_id);
    switch (event.event_id) {
        case EPPS_BUFFERING:
            NSLog(@"EPPS_BUFFERING: %u", event.param);
            break;
            
        default:
            break;
    }
    
    return 0;
}

+ (XEmsManager*)shareEmsManager
{
    static XEmsManager *EManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{EManager = [[XEmsManager alloc] init];});
    return EManager;
}

+ (void)startEmsServer
{
    //start_ems_server("IOS", "iPad1G", "ppstream1", 8080);
    //ems_event_listener_func(ems_event_listenerx);
}

+ (void)setEmsVodBufferingBlock:(void (^)(NSNotification *note))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:XEmsManagerVodBufferingEventNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

+ (int)startEmsTask:(NSString*)url withUserID:(NSString*)userID
{
    if (url == nil)
        return -1;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //add_ems_url("pps://plsgkogqec3t2x2s2aqdzu6sgdica.pps/iqiyi/h/h27jxllysqipd4fraabfxrao2pgctett.pfv?fid=H27JXLLYSQIPD4FRAABFXRAO2PGCTETT&qa=http://cache.video.qiyi.com/vd/218943300/97b6663fac1900db569ad867bc990f30/", NULL);
        //add_ems_url([url UTF8String], [userID UTF8String]);
    });
    
    return 0;
}

@end
