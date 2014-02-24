//
//  XChannelClass.h
//  PPStreamX
//
//  Created by 王大伟 on 13-12-23.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XChannelClass : NSObject

@property (nonatomic, strong) NSDictionary *channelDic;
@property (nonatomic, strong) NSArray *channelArray;

@property (nonatomic, copy) NSString *strSubID;

- (void)requestChannelDataWithSuccess:(void(^)(NSData *data))success
                            failure:(void(^)(NSError *error))failure;

@end
