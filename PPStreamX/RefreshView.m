//
//  RefreshView.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-23.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "RefreshView.h"



///////////////////////////////////////////////////////////////////////////////////////////////
// Refresh View
//
@interface RefreshView ()

@end

@implementation RefreshView

@synthesize title = _title;
@synthesize activityIndicator = _activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _title = [[UILabel alloc] initWithFrame:self.bounds];
    [_title setTextAlignment:NSTextAlignmentCenter];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, self.bounds.size.height)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self addSubview:_title];
    [self addSubview:_activityIndicator];
}

@end

