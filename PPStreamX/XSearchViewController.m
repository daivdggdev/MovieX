//
//  XSearchViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 14-2-24.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import "XSearchViewController.h"
#import "UIButton+imageAndTitle.h"

@interface XSearchViewController ()

@end

@implementation XSearchViewController

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
    
    self.title = @"找片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self searchViewLayout];
    [self socializeViewLayout];
}

- (void)searchViewLayout
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.placeholder = @"搜索视频，导演，演员...";
    [self.view addSubview:searchBar];
}

- (void)socializeViewLayout
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 100)];
    [self.view addSubview:view];
    
    UIButton *shakeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 80, 80)];
    shakeButton.backgroundColor = [UIColor redColor];
    [shakeButton setImage:[UIImage imageNamed:@"rc_shake_btn"] withTitle:@"摇一摇" forState:UIControlStateNormal];
    [view addSubview:shakeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
