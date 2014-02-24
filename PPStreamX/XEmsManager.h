//
//  XEmsManager.h
//  PPStreamX
//
//  Created by 王大伟 on 14-1-5.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XEmsManagerVodBufferingEventNotification;
extern NSString * const XEmsManagerVodBufferDoneEventNotification;

@interface XEmsManager : NSObject

// block
+ (void)setEmsVodBufferingBlock:(void (^)(NSNotification *note))block;

+ (void)startEmsServer;

+ (int)startEmsTask:(NSString*)url withUserID:(NSString*)userID;

@end
