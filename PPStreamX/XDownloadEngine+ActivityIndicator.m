//
//  XDownloadEngine+ActivityIndicator.m
//  PPStreamX
//
//  Created by dwwang on 12/19/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import "XDownloadEngine+ActivityIndicator.h"
#import <UIActivityIndicatorView+AFNetworking.h>

@implementation XDownloadEngine (ActivityIndicator)

- (void)startWithActivityIndicatorViewFromSuperView:(UIView*)superView
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 200, 44, 44)];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [superView addSubview:activityIndicatorView];
    
    [activityIndicatorView setAnimatingWithStateOfOperation:self.operation];
    [self.operation start];
}

@end
