//
//  XHomeToolsViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 14-2-25.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import "XHomeToolsViewController.h"

@interface XHomeToolsViewController ()

@end

@implementation XHomeToolsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    [scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    scanButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scanButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
