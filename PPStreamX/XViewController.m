//
//  XViewController.m
//  PPStreamX
//
//  Created by dwwang on 12/12/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import "XViewController.h"
#import <AFNetworking.h>
#import <UIActivityIndicatorView+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import "XHomePageClass.h"
#import "XChanneViewController.h"
#import "RefreshView.h"
#import "XDetailViewController.h"
#import "XSearchViewController.h"
#import "XHomeToolsViewController.h"
#import "FPPopoverController.h"


///////////////////////////////////////////////////////////////////////////////////////////////
// XViewController
//
@interface XViewController () <NSXMLParserDelegate, UIScrollViewDelegate>
{
    UIScrollView *topScrollView;
    UIPageControl *pageControl;
}

//@property (nonatomic, strong) NSArray *classArray;
@property (nonatomic, strong) XHomePageClass *homePageClass;

@end

@implementation XViewController

//@synthesize classArray = _classArray;
@synthesize homePageClass = _homePageClass;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    self.title = @"PPSX";
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    [self initializeX];
}

- (void)initializeX
{
    // more menu
#if 0
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ipad_detail_menum_list_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(doShowMoreMenu:)];
    barButton.width = 44;
    self.navigationItem.rightBarButtonItem = barButton;
#else
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"ipad_detail_menum_list_icon"] forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [self.navigationController.navigationBar addSubview:button];
#endif
    
    // custom table view
    [self tableViewCustom];
    
    [self topSliderViewLayout];
    
    // get home page data
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeNone];
    self.homePageClass = [[XHomePageClass alloc] init];
    [self.homePageClass requestClassDataWithSuccess:^(NSData *data) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"HomePage request data error = %@", error);
    }];
    
    // get top slider data
    [self.homePageClass requestTopSliderWithSuccess:^(NSData *data) {
        [self loadTopSlider];
    } failure:^(NSError *error) {
        NSLog(@"top slider data error = %@", error);
    }];

}

- (void)topSliderViewLayout
{
    // init top scroll view
    topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.showsVerticalScrollIndicator = NO;
    topScrollView.bounces = NO;
    topScrollView.delegate = self;
    self.tableView.tableHeaderView = topScrollView;
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [topScrollView addGestureRecognizer:sigleTapRecognizer];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 130, 20, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)changePage:(id)sender
{
    // update the scroll view to the appropriate page
    CGRect frame = topScrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [topScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - More Menu
- (void)doShowMoreMenu:(id)sender
{
    XHomeToolsViewController *toolViewController = [[XHomeToolsViewController alloc] init];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:toolViewController];
    popover.contentSize = CGSizeMake(88, 44);
    popover.border = NO;
    popover.tint = FPPopoverWhiteTint;
    [popover presentPopoverFromPoint:CGPointMake(SCREEN_WIDTH - 44, 30)];
}

#pragma mark - Top Slider 

- (void)loadTopSlider
{
    pageControl.numberOfPages = self.homePageClass.topSliderArray.count;
    
    CGFloat width = SCREEN_WIDTH * self.homePageClass.topSliderArray.count;
    CGFloat height = topScrollView.bounds.size.height;
    topScrollView.contentSize = CGSizeMake(width, height);
    
    CGFloat    x = 0;
    NSUInteger i = 0;
    for (NSDictionary *dic in self.homePageClass.topSliderArray)
    {
        x = (i++) * SCREEN_WIDTH;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, height)];
        //NSLog(@"image url = %@", [dic objectForKey:@"poster"]);
        [imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"poster"]]];
        [topScrollView addSubview:imageView];
    }
    
    [topScrollView addSubview:pageControl];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)tapRecognizer
{
    int tapCount = tapRecognizer.numberOfTapsRequired;
    // 先取消任何操作???????这句话存在的意义？？？
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSDictionary *dic = [self.homePageClass.topSliderArray objectAtIndex:pageControl.currentPage];
    NSString *strDetailID = [dic objectForKey:@"id"];
    
    switch (tapCount)
    {
        case 1:
            [self navigateToDetailView:strDetailID];
            break;
    }
}

- (void)navigateToDetailView:(NSString*)strDetailID;
{
    XDetailViewController *detailViewController = [[XDetailViewController alloc] init];
    detailViewController.strDetailID = strDetailID;
    self.navigationController.delegate = (id)detailViewController;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == topScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
    }
    else if (scrollView == self.tableView)
    {
#if 0
        CGFloat y = 150;
        NSLog(@"y = %f, scrollViewDidScroll contentOffset.y = %f", y, scrollView.contentOffset.y);
        CGRect frame = pageControl.frame;
        frame.origin.y -= scrollView.contentOffset.y;
        pageControl.frame = frame;
#endif
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == topScrollView)
    {
        [self changePage:scrollView];
    }
}

#pragma mark - Table View Custom

- (void)tableViewCustom
{
    self.tableView.rowHeight = 60;
    
    self.headerView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    self.footerView = [[RefreshView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NavigationBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
}

- (void)pinHeaderView
{
    [super pinHeaderView];
    
    RefreshView *hv = (RefreshView*)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"Loading...";
}

- (void)unpinHeaderView
{
    [super unpinHeaderView];
    
    RefreshView *hv = (RefreshView*)self.headerView;
    [hv.activityIndicator stopAnimating];
}

- (void)headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    RefreshView *hv = (RefreshView*)self.headerView;
    if (willRefreshOnRelease)
    {
        hv.title.text = @"Release to refresh...";
    }
    else
    {
        hv.title.text = @"Pull down to refresh...";
    }
}

- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    // Do your async call here
    // This is just a dummy data loader:
    //[self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:2.0];
    // See -addItemsOnTop for more info on how to finish loading
    [self refreshCompleted];
    
    return YES;
}

- (void) willBeginLoadingMore
{
    RefreshView *fv = (RefreshView *)self.footerView;
    [fv.activityIndicator startAnimating];
}

- (void) loadMoreCompleted
{
    [super loadMoreCompleted];
    
    RefreshView *fv = (RefreshView *)self.footerView;
    [fv.activityIndicator stopAnimating];
    
    if (!self.canLoadMore) {
        // Do something if there are no more items to load
        
        // We can hide the footerView by: [self setFooterViewVisibility:NO];
        
        // Just show a textual info that there are no more items to load
        //fv.infoLabel.hidden = NO;
    }
}

- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    // Do your async loading here
    //[self performSelector:@selector(addItemsOnBottom) withObject:nil afterDelay:2.0];
    // See -addItemsOnBottom for more info on what to do after loading more items
    [self loadMoreCompleted];
    
    return YES;
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homePageClass.classArray.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ClassCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *classDic = [self.homePageClass.classArray objectAtIndex:indexPath.row];
    
    // image
    NSString *imageUrl = [classDic objectForKey:@"rec_image"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ipad_recommand_default.png"]];
    
    // title
    NSString *className = [classDic objectForKey:@"name"];
    //NSLog(@"className = %@", className);
    cell.textLabel.text = className;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *classDic = [self.homePageClass.classArray objectAtIndex:indexPath.row];
    NSString *strSubID = [classDic objectForKey:@"id"];
    
    XChanneViewController *channelViewController = [[XChanneViewController alloc] init];
    channelViewController.strSubID = strSubID;
    [self.navigationController pushViewController:channelViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
