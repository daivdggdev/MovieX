//
//  XRecommendViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-26.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XRecommendViewController.h"
#import "MMGridView.h"
#import "MMGridViewDefaultCell.h"
#import <UIImageView+AFNetworking.h>
#import "XDetailViewController.h"

@interface XRecommendViewController () <MMGridViewDataSource, MMGridViewDelegate>
{
    MMGridView *recommendGridView;
    NSArray *recommendArray;
}
@end

@implementation XRecommendViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)parseRecommendContent:(NSDictionary*)detailDic
{
    if (detailDic == nil)
        return;
    
    recommendArray = [[[[detailDic objectForKey:@"Sub"] objectForKey:@"Subs"] objectForKey:@"Sub"] copy];
    NSLog(@"recommend = %@", recommendArray);
    
    recommendGridView = [[MMGridView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 150 - 44 - 44)];
    recommendGridView.borderSpacing = 10;
    recommendGridView.cellSpacing = 15;
    recommendGridView.verticalCellMargin = 5;
    recommendGridView.horizontalCellMargin = 5;
    recommendGridView.numberOfColumns = 3;
    recommendGridView.layoutStyle = VerticalLayout;
    recommendGridView.dataSource = self;
    recommendGridView.delegate = self;
    [self.view addSubview:recommendGridView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return recommendArray.count;
}

- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    NSDictionary *dic = [recommendArray objectAtIndex:index];
    
    MMGridViewDefaultCell *cell = [[MMGridViewDefaultCell alloc] initWithFrame:CGRectMake(0, 0, 90, 120)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    
    // image
    NSString *imageUrl = [dic objectForKey:@"img"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ipad_recommand_default.png"]];
    
    //cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-image.png"]];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    NSDictionary *dic = [recommendArray objectAtIndex:index];
    
    XDetailViewController *detailViewController = [[XDetailViewController alloc] init];
    detailViewController.strDetailID = [dic objectForKey:@"id"];
    UIViewController *rootController = self.parentViewController.parentViewController;
    rootController.navigationController.delegate = (id)detailViewController;
    [rootController.navigationController pushViewController:detailViewController animated:YES];
}

@end
