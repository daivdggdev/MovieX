//
//  XEpisodesViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-26.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XEpisodesViewController.h"
#import "MMGridView.h"
#import "MMGridViewDefaultCell.h"

@interface XEpisodesViewController () <MMGridViewDataSource, MMGridViewDelegate>
{
    NSMutableDictionary *episodesDic;
    
    UIView *rateSwitchView;
    MMGridView *episodesGridView;
    
    NSUInteger currentPage;
    NSArray *currentEpisodesArray;
}

@end

@implementation XEpisodesViewController

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
    
    currentPage = 0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)parseEpisodesContent:(NSDictionary*)detailDic
{
    NSArray *channel = [[[detailDic objectForKey:@"Sub"] objectForKey:@"Channels"] objectForKey:@"Channel"];
    //NSLog(@"channel = %@", channel);
    
    episodesDic = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dic in channel)
    {
        NSString *tag = [dic objectForKey:@"tag"];
        NSString *text = [dic objectForKey:@"text"];
        if (tag == nil || text == nil)
            continue;
        
        NSMutableArray *array = [episodesDic objectForKey:tag];
        if (array == nil) array = [[NSMutableArray alloc] init];
        [array addObject:text];
        [episodesDic setObject:array forKey:tag];
    }

    NSArray *array = [episodesDic allKeys];
    [self rateSwitchViewLayout:array];
    
    [self episodesGridViewLayout:[episodesDic objectForKey:[array objectAtIndex:currentPage]]];
}

- (void)rateSwitchViewLayout:(NSArray*)rateArray
{
    CGFloat cellWidth = SCREEN_WIDTH / 4;
    CGFloat cellHeight = 44;
    
    CGFloat viewHeight = (floor((rateArray.count - 1) / 4) + 1) * cellHeight;
    rateSwitchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight)];
    [self.view addSubview:rateSwitchView];
    
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < rateArray.count; i++)
    {
        if (i > 0 && (i % 4) == 0) y += cellHeight;
        x = i * cellWidth;
        
        NSString *tag = [rateArray objectAtIndex:i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        button.tag = 10000 + i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setTitle:tag forState:UIControlStateNormal];
        [button addTarget:self action:@selector(switchTag:) forControlEvents:UIControlEventTouchUpInside];
        [rateSwitchView addSubview:button];
    }
}

- (void)switchTag:(id)sender
{
    UIButton *button = (UIButton*)sender;
    currentPage = button.tag - 10000;
    
    NSArray *array = [episodesDic objectForKey:[[episodesDic allKeys] objectAtIndex:currentPage]];
    currentEpisodesArray = [array sortedArrayUsingSelector:@selector(compare:)];
    [episodesGridView reloadData];
}

- (void)episodesGridViewLayout:(NSArray*)episodesArray
{
    CGFloat cellHeight = 30;
    CGFloat numberOfRows = floor((episodesArray.count - 1) / 4) + 1;
    episodesGridView = [[MMGridView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 150 - 44 - 44)];
    episodesGridView.borderSpacing = 10;
    episodesGridView.cellSpacing = 12;
    episodesGridView.verticalCellMargin = 5;
    episodesGridView.horizontalCellMargin = 5;
    episodesGridView.numberOfColumns = 5;
    episodesGridView.layoutStyle = VerticalLayout;
    episodesGridView.dataSource = self;
    episodesGridView.delegate = self;
    [self.view addSubview:episodesGridView];
    
    currentEpisodesArray = [episodesArray sortedArrayUsingSelector:@selector(compare:)];
}

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return currentEpisodesArray.count;
}

- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[MMGridViewDefaultCell alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [currentEpisodesArray objectAtIndex:index]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-image.png"]];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
}

@end
