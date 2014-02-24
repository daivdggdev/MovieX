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

- (IIViewDeckController*)topViewDeckController;

@end


@implementation XMenuViewController

- (IIViewDeckController*)topViewDeckController
{
    return self.viewDeckController.viewDeckController;
}

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
        button.backgroundColor = [UIColor redColor];
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
    switch (button.tag - 10000)
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
}

- (void)navigateToSearch
{
    NSLog(@"navigateToSearch");
    
    XSearchViewController *searchViewController = [[XSearchViewController alloc] init];
    [self.viewDeckController.centerController presentViewController:searchViewController animated:NO completion:nil];
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
