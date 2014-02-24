//
//  XChannelClass.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-23.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XChannelClass.h"
#import "XDownloadEngine.h"
#import "ZipArchive.h"
#import <XMLReader.h>

@implementation XChannelClass

@synthesize strSubID = _strSubID;
@synthesize channelDic = _channelDic;
@synthesize channelArray = _channelArray;

- (void)requestChannelDataWithSuccess:(void(^)(NSData *data))success
                            failure:(void(^)(NSError *error))failure;
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *zipSavePath = [docDir stringByAppendingFormat:@"/%@.xml.zip", self.strSubID];
    NSString *xmlPath = [docDir stringByAppendingFormat:@"/%@.xml", self.strSubID];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@.xml.zip", SUB_MOVIE_LIST_URL, self.strSubID];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    XDownloadEngine *downloadEngine = [[XDownloadEngine alloc] initWithUrl:request];
    downloadEngine.savepath = zipSavePath;
    [downloadEngine setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // unzip
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:zipSavePath toPath:docDir])
        {
            NSData *data = [NSData dataWithContentsOfFile:xmlPath];
            [self parserChannelXML:data];
            success(data);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    // start
    [downloadEngine start];
}

- (BOOL)parserChannelXML:(NSData*)data
{
    NSError *error;
    self.channelDic = [XMLReader dictionaryForXMLData:data error:&error];
    if (error == nil)
    {
        NSDictionary *subsDic = [self.channelDic objectForKey:@"subs"];
        if (subsDic != nil)
        {
            self.channelArray = [subsDic objectForKey:@"sub"];
        }
    }
    
    return (error == nil) ? YES : NO;
}

@end
