//
//  XHomePageClass.m
//  PPStreamX
//
//  Created by dwwang on 12/19/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import "XHomePageClass.h"
#import "XDownloadEngine+ActivityIndicator.h"
#import "ZipArchive.h"
#import <XMLReader.h>

@implementation XHomePageClass

@synthesize classDic = _classDic;
@synthesize classArray = _classArray;
@synthesize topSliderDic = _topSliderDic;
@synthesize topSliderArray = _topSliderArray;

- (void)requestClassDataWithSuccess:(void(^)(NSData *data))success
                       failure:(void(^)(NSError *error))failure;
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *zipSavePath = [docDir stringByAppendingString:@"/root.xml.zip"];
    NSString *xmlPath = [docDir stringByAppendingString:@"/root.xml"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ROOT_LIST_ZIP] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    XDownloadEngine *downloadEngine = [[XDownloadEngine alloc] initWithUrl:request];
    downloadEngine.savepath = zipSavePath;
    [downloadEngine setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        // unzip
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:zipSavePath toPath:docDir])
        {
            NSData *data = [NSData dataWithContentsOfFile:xmlPath];
            [self parserClassXML:data];
            success(data);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    // start
    [downloadEngine start];
}

- (BOOL)parserClassXML:(NSData*)data
{
    NSError *error;
    self.classDic = [XMLReader dictionaryForXMLData:data error:&error];
    if (error == nil)
    {
        NSDictionary *gensDic = [self.classDic objectForKey:@"gens"];
        if (gensDic != nil)
        {
            self.classArray = [gensDic objectForKey:@"gen"];
        }
    }
    
    return (error == nil) ? YES : NO;
}

- (void)requestTopSliderWithSuccess:(void(^)(NSData *data))success
                            failure:(void(^)(NSError *error))failure
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *zipSavePath = [docDir stringByAppendingString:@"/reindex.xml.zip"];
    NSString *xmlPath = [docDir stringByAppendingString:@"/reindex.xml"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:MAIN_MOVIE_PAGE_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    XDownloadEngine *downloadEngine = [[XDownloadEngine alloc] initWithUrl:request];
    downloadEngine.savepath = zipSavePath;
    [downloadEngine setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // unzip
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:zipSavePath toPath:docDir])
        {
            NSData *data = [NSData dataWithContentsOfFile:xmlPath];
            [self parserTopSliderXML:data];
            success(data);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    // start
    [downloadEngine start];
}

- (BOOL)parserTopSliderXML:(NSData*)data
{
    NSError *error;
    self.topSliderDic = [XMLReader dictionaryForXMLData:data error:&error];
    //NSLog(@"topSliderDic = %@", self.topSliderDic);
    if (error == nil)
    {
        NSDictionary *ppsClassDic = [self.topSliderDic objectForKey:@"PPSClasses"];
        if (ppsClassDic != nil)
        {
            for (NSDictionary *dic in [ppsClassDic objectForKey:@"Class"])
            {
                if ([((NSString*)[dic objectForKey:@"name"]) isEqualToString:@"顶部推荐"])
                {
                    self.topSliderArray = [dic objectForKey:@"Sub"];
                    NSLog(@"self.topSliderArray = %@", self.topSliderArray);
                }
            }
        }
    }
    
    return (error == nil) ? YES : NO;
}

@end
