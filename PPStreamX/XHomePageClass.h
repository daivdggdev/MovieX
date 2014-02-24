//
//  XHomePageClass.h
//  PPStreamX
//
//  Created by dwwang on 12/19/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHomePageClass : NSObject

@property (nonatomic, strong) NSDictionary *classDic;
@property (nonatomic, strong) NSArray *classArray;

@property (nonatomic, strong) NSDictionary *topSliderDic;
@property (nonatomic, strong) NSArray *topSliderArray;

- (void)requestClassDataWithSuccess:(void(^)(NSData *data))success
                       failure:(void(^)(NSError *error))failure;

- (void)requestTopSliderWithSuccess:(void(^)(NSData *data))success
                            failure:(void(^)(NSError *error))failure;

@end
