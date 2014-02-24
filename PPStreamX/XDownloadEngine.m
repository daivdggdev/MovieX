//
//  XDownloadEngine.m
//  PPStreamX
//
//  Created by dwwang on 12/19/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import "XDownloadEngine.h"


@interface XDownloadEngine ()



@end


@implementation XDownloadEngine

@synthesize operation = _operation;
@synthesize savepath = _savepath;

- (id)initWithUrl:(NSURLRequest *)urlRequest
{
    if (self = [super init])
    {
        // init with request
        self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    }
    return self;
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.operation setCompletionBlockWithSuccess:success failure:failure];
}

- (void)start
{
    // save file ?
    if (self.savepath && self.savepath.length > 0)
    {
        self.operation.outputStream = [NSOutputStream outputStreamToFileAtPath:self.savepath append:NO];
    }
    
    // start
    [self.operation start];
}

@end
