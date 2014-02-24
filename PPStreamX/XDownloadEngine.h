//
//  XDownloadEngine.h
//  PPStreamX
//
//  Created by dwwang on 12/19/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface XDownloadEngine : NSObject

@property (nonatomic, copy) NSString *savepath;

@property (nonatomic, copy) AFHTTPRequestOperation *operation;

- (id)initWithUrl:(NSURLRequest*)urlRequest;

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)start;

@end
