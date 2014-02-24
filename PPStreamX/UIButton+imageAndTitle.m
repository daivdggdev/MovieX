//
//  UIButton+imageAndTitle.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-24.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "UIButton+imageAndTitle.h"

@implementation UIButton (imageAndTitle)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    // set image
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0, 0.0, 0.0, -titleSize.width)];
    [self setImage:image forState:stateType];
    
    // set title
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -image.size.width, 0.0, 0.0)];
    [self setTitle:title forState:stateType];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
}

@end
