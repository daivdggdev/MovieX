//
//  XDetailClass.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-24.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XDetailClass.h"
#import "XDownloadEngine.h"
#import "ZipArchive.h"
#import <XMLReader.h>

@implementation XDetailClass
@synthesize detailDic = _detailDic;

- (void)requestDetailDataWithSuccess:(void(^)(NSData *data))success
                              failure:(void(^)(NSError *error))failure
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *zipSavePath = [docDir stringByAppendingFormat:@"/%@.xml.zip", self.strDetailID];
    NSString *xmlPath = [docDir stringByAppendingFormat:@"/%@.xml", self.strDetailID];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@.xml.zip", MOVIE_DETAIL_URL, self.strDetailID];
    NSLog(@"requestUrl = %@", requestUrl);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    XDownloadEngine *downloadEngine = [[XDownloadEngine alloc] initWithUrl:request];
    downloadEngine.savepath = zipSavePath;
    [downloadEngine setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // unzip
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:zipSavePath toPath:docDir])
        {
            NSData *data = [NSData dataWithContentsOfFile:xmlPath];
            [self parserDetailXML:data];
            success(data);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    // start
    [downloadEngine start];
}

- (BOOL)parserDetailXML:(NSData*)data
{
    NSError *error;
    self.detailDic = [XMLReader dictionaryForXMLData:data error:&error];
    NSLog(@"detailDic = %@", self.detailDic);
    if (error == nil)
    {
        NSDictionary *subsDic = [self.detailDic objectForKey:@"Sub"];
    }
    
    return (error == nil) ? YES : NO;
}

@end
