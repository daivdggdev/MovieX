//
//  XDetailClass.h
//  PPStreamX
//
//  Created by 王大伟 on 13-12-24.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDetailClass : NSObject

@property (nonatomic, strong) NSDictionary *detailDic;

@property (nonatomic, copy) NSString *strDetailID;

- (void)requestDetailDataWithSuccess:(void(^)(NSData *data))success
                              failure:(void(^)(NSError *error))failure;

@end
