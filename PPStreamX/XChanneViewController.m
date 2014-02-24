//
//  XChanneViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-20.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XChanneViewController.h"
#import "XChannelClass.h"
#import "RefreshView.h"
#import <SVProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import "XDetailViewController.h"

@interface XChanneViewController ()
{
    XChannelClass *channelClass;
    NSUInteger cellLoadmoreCount;
}

@end

@implementation XChanneViewController

@synthesize strSubID = _strSubID;

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
    
    [self initializeX];
}

- (void)initializeX
{
    // default is 1
    cellLoadmoreCount = 1;
    channelClass = nil;
    
    // custom table view
    [self tableViewCustom];
    
    // get home page data
    [self requestChannelDataWithSuccess:^{
        [self.tableView reloadData];
    } failure:^{
    } useHUD:YES];
}

- (void)requestChannelDataWithSuccess:(void(^)())success
                              failure:(void(^)())failure
                               useHUD:(BOOL)useHUD
{
    if (useHUD) [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeNone];
    
    if (channelClass == nil) channelClass = [[XChannelClass alloc] init];
    channelClass.strSubID = self.strSubID;
    [channelClass requestChannelDataWithSuccess:^(NSData *data) {
        if (useHUD) [SVProgressHUD dismiss];
        success();
    } failure:^(NSError *error) {
        if (useHUD) [SVProgressHUD dismiss];
        failure();
        NSLog(@"HomePage request data error = %@", error);
    }];
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
    [self performSelector:@selector(OnRefresh) withObject:nil afterDelay:0.5];
    
    return YES;
}

- (void)OnRefresh
{
    [self requestChannelDataWithSuccess:^{
        [self refreshCompleted];
    } failure:^{
    } useHUD:NO];
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
    [self performSelector:@selector(OnLoadMore) withObject:nil afterDelay:0.5];
    
    return YES;
}

- (void)OnLoadMore
{
    cellLoadmoreCount ++;
    [self.tableView reloadData];
    [self loadMoreCompleted];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(channelClass.channelArray.count, cellLoadmoreCount * TABLE_VIEW_MAX_SHOW_CELL_ONCE) ;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ChannelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (channelClass && channelClass.channelArray && channelClass.channelArray.count > indexPath.row)
    {
        NSDictionary *channelDic = [channelClass.channelArray objectAtIndex:indexPath.row];
        
        // image
        NSString *imageUrl = [channelDic objectForKey:@"img"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ipad_recommand_default.png"]];
        
        // title
        NSString *className = [channelDic objectForKey:@"name"];
        cell.textLabel.text = className;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *channelArray = [channelClass.channelArray objectAtIndex:indexPath.row];
    if ([[channelArray objectForKey:@"nt"] intValue] == 1)
    {
        XChanneViewController *channelViewController = [[XChanneViewController alloc] init];
        channelViewController.strSubID = [channelArray objectForKey:@"id"];
        [self.navigationController pushViewController:channelViewController animated:YES];
    }
    else
    {
        XDetailViewController *detailViewController = [[XDetailViewController alloc] init];
        detailViewController.strDetailID = [channelArray objectForKey:@"id"];
        self.navigationController.delegate = (id)detailViewController;
        [self.navigationController pushViewController:detailViewController animated:YES];
        //self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
