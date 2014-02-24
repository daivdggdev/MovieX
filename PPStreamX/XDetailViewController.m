//
//  XDetailViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-23.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XDetailViewController.h"
#import "XDetailClass.h"
#import "UIButton+imageAndTitle.h"
#import "XIntroductionViewController.h"
#import "XEpisodesViewController.h"
#import "XCommentViewController.h"
#import "XRecommendViewController.h"
#import "XOutTakeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MHTabBarController.h>
#import "XEmsManager.h"
#import <AVFoundation/AVAudioSession.h>
#import <SVProgressHUD.h>

@interface XDetailViewController () <UINavigationControllerDelegate, MHTabBarControllerDelegate>
{
    MPMoviePlayerController *player;
    
    XIntroductionViewController *introductionViewController;
    XEpisodesViewController *episodesViewController;
    XCommentViewController *commentViewController;
    XRecommendViewController *recommendViewController;
    XOutTakeViewController *outtakeViewController;
    
    UIView *playerView;
    UIButton *gobackButton;
    UIButton *fullscreenButton;
    
    UIView *toolsView;
    UIButton *downloadButton;
    UIButton *collectButton;
    UIButton *shareButton;
    
    XDetailClass *detailClass;
    
    NSString *currentPlayUrl;
}
@end

@implementation XDetailViewController
@synthesize strDetailID = _strDetailID;

#if 0
- (void)loadView
{
    [super loadView];
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    //self.view.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
    
    [self initializeX];
}

- (void)initializeX
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [self registerNotification];
    
    //[self startEmsTask:@"pps://plsgkogqec3t2x2s2aqdzu6sgdica.pps/iqiyi/h/h27jxllysqipd4fraabfxrao2pgctett.pfv?fid=H27JXLLYSQIPD4FRAABFXRAO2PGCTETT&qa=http://cache.video.qiyi.com/vd/218943300/97b6663fac1900db569ad867bc990f30/" withUserID:nil];
    
    [self viewLayout];

    [self requestDetailDataWithSuccess:^{
        [self loadSubViewControllerContent];
    } failure:^{
        
    } useHUD:YES];
}

- (void)requestDetailDataWithSuccess:(void(^)())success
                              failure:(void(^)())failure
                               useHUD:(BOOL)useHUD
{
    if (useHUD) [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeNone];
    
    if (detailClass == nil) detailClass = [[XDetailClass alloc] init];
    detailClass.strDetailID = self.strDetailID;
    [detailClass requestDetailDataWithSuccess:^(NSData *data) {
        if (useHUD) [SVProgressHUD dismiss];
        success();
    } failure:^(NSError *error) {
        if (useHUD) [SVProgressHUD dismiss];
        failure();
    }];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ems_buffering" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSNumber *precent = [note.object lastObject];
        NSLog(@"EMSBUFFERING = %d", [precent intValue]);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ems_buffered" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"player start play!");
        [self playMovie];
    }];
}

- (void)startEmsTask:(NSString*)url withUserID:(NSString*)userID
{
    [XEmsManager startEmsTask:url withUserID:userID];
}

- (void)viewLayout
{
    //self.view.backgroundColor = [UIColor redColor];
    [self playerViewLayout];
    [self contentViewLayout];
    [self toolsViewLayout];
}

- (void)playerViewLayout
{
#if 0
//    NSString* movieFile =[ NSString stringWithFormat:@"%@/Documents/01.mp4",NSHomeDirectory()];
//    NSLog(@"movieFile = %@", movieFile);
//    NSURL *url = [NSURL fileURLWithPath:movieFile];
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/fake_vod_url.pfv.m3u8"];
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.movieSourceType = MPMovieSourceTypeStreaming;
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    [self.view addSubview:player.view];
    //[moviePlayerViewController play];
#else
    playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [self.view addSubview:playerView];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/fake_vod_url.pfv.m3u8"];
    //NSURL *url = [NSURL URLWithString:@"http://10.1.13.27/4f49b41af0e749db7581ddcd569716236f975850.mp4"];
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.shouldAutoplay = NO;
    player.movieSourceType = MPMovieSourceTypeStreaming;
    //player.controlStyle = MPMovieControlStyleNone;
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    [playerView addSubview:player.view];

    // go back button
    gobackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [gobackButton addTarget:self action:@selector(onGoBack) forControlEvents:UIControlEventTouchUpInside];
    [gobackButton setImage:[UIImage imageNamed:@"Iph_detail_back_icon.png"] forState:UIControlStateNormal];
    gobackButton.imageView.contentMode = UIViewContentModeCenter;
    [playerView addSubview:gobackButton];
    
    // full screen button
    fullscreenButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44)];
    [fullscreenButton setImage:[UIImage imageNamed:@"ipad_detail_full_screen.png"] forState:UIControlStateNormal];
    fullscreenButton.imageView.contentMode = UIViewContentModeCenter;
    [playerView addSubview:fullscreenButton];
#endif
}

- (void)contentViewLayout
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 150 - 44)];
    [self.view addSubview:contentView];
    
    introductionViewController = [[XIntroductionViewController alloc] init];
    introductionViewController.title = @"详情";
    
    episodesViewController = [[XEpisodesViewController alloc] init];
    episodesViewController.title = @"剧集";
    
    commentViewController = [[XCommentViewController alloc] init];
    commentViewController.title = @"评论";
    
    recommendViewController = [[XRecommendViewController alloc] init];
    recommendViewController.title = @"推荐";
    
    outtakeViewController = [[XOutTakeViewController alloc] init];
    outtakeViewController.title = @"花絮";
    
    NSArray *viewControllers = @[introductionViewController, episodesViewController, commentViewController, recommendViewController, outtakeViewController];
    MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = viewControllers;
    [self addChildViewController:tabBarController];
    [contentView addSubview:tabBarController.view];
}

- (void)toolsViewLayout
{
    toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 44)];
    toolsView.backgroundColor = [UIColor redColor];
    [self.view addSubview:toolsView];
    
    // download button
    downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [downloadButton setImage:[UIImage imageNamed:@"detail_download.png"] withTitle:@"下载" forState:UIControlStateNormal];
    [toolsView addSubview:downloadButton];
    
    // collect Button
    collectButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 88, 0, 44, 44)];
    [collectButton setImage:[UIImage imageNamed:@"detail_collect.png"] withTitle:@"收藏" forState:UIControlStateNormal];
    [toolsView addSubview:collectButton];
    
    // shared Button
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
    [shareButton setImage:[UIImage imageNamed:@"detail_follower"] withTitle:@"分享" forState:UIControlStateNormal];
    [toolsView addSubview:shareButton];
}

- (void)loadSubViewControllerContent
{
    if (introductionViewController)
        [introductionViewController parseIntroductionContent:detailClass.detailDic];
    
    if (episodesViewController)
        [episodesViewController parseEpisodesContent:detailClass.detailDic];
    
    if (recommendViewController)
        [recommendViewController parseRecommendContent:detailClass.detailDic];
}

#pragma mark - Player Event

- (void)playMovie
{
    [player play];
}

#pragma mark - GoBack Action

- (void)onGoBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (player.playbackState != MPMoviePlaybackStateStopped)
    {
        stop_ems_task([currentPlayUrl UTF8String]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController");
    if (viewController == self)
    {
        [navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO];
        navigationController.delegate = nil;
    }
    
#if 0
    // 如果进入的是当前视图控制器
    if (viewController == self) {
        // 背景设置为黑色
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
        // 透明度设置为0.3
        self.navigationController.navigationBar.alpha = 0.300;
        // 设置为半透明
        self.navigationController.navigationBar.translucent = YES;
    } else {
        // 进入其他视图控制器
        self.navigationController.navigationBar.alpha = 1;
        // 背景颜色设置为系统默认颜色
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
}

@end
