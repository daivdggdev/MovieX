//
//  XSearchViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 14-2-24.
//  Copyright (c) 2014年 pps. All rights reserved.
//

#import "XSearchViewController.h"

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

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"找片";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchBar.placeholder = @"搜索视频，导演，演员...";
    [self.view addSubview:searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
