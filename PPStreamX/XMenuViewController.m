//
//  XMenuViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 14-2-24.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import "XMenuViewController.h"
#import <IIViewDeckController.h>
#import "XSearchViewController.h"

#define KHOMEBUTTONTAG         10001


@interface XMenuViewController () <IIViewDeckControllerDelegate>
{
    NSUInteger currentMenuSelected;
}

@end


@implementation XMenuViewController


+ (id)shareMenuViewController
{
    static XMenuViewController *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{menu = [[XMenuViewController alloc] init];});
    return menu;
}

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
    
    currentMenuSelected = 0;
    self.view.backgroundColor = [UIColor grayColor];
    
    NSArray *nameArray = @[@"首页", @"找片", @"爱频道", @"我的", @"下载", @"游戏"];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 44;
    CGFloat height = 50;
    for (int i = 0; i < nameArray.count; i++)
    {
        y = i * height;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.tag = 10000 + i;
        [self.view addSubview:button];
    }
}

- (void)menuSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (currentMenuSelected == button.tag - 10000)
        return;
    
    currentMenuSelected = button.tag - 10000;
    switch (currentMenuSelected)
    {
        // 首页
        case 0:
            [self navigateToHome];
            break;
            
        // 找片
        case 1:
            [self navigateToSearch];
            break;
            
        default:
            break;
    }
}

- (void)navigateToHome
{
    UINavigationController *navigate = (UINavigationController*)self.viewDeckController.centerController;
    [navigate popToRootViewControllerAnimated:NO];
}

- (void)navigateToSearch
{
    NSLog(@"navigateToSearch");
    
    XSearchViewController *searchViewController = [[XSearchViewController alloc] init];
    UINavigationController *navigate = (UINavigationController*)self.viewDeckController.centerController;
    [navigate pushViewController:searchViewController animated:NO];
}

- (void)navigateToIpd
{
}

- (void)navigateToVip
{
}

- (void)navigateToDownload
{
}

- (void)navigateToGame
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
