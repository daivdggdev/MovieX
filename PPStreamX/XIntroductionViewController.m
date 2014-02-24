//
//  XIntroductionViewController.m
//  PPStreamX
//
//  Created by 王大伟 on 13-12-26.
//  Copyright (c) 2013年 pps. All rights reserved.
//

#import "XIntroductionViewController.h"

@interface XIntroductionViewController ()
{
    UILabel *titleLabel;
    UILabel *yearLabel;
    UILabel *regionLabel;
    UILabel *typeLabel;
    UILabel *dirtLabel;
    UILabel *actorLabel;
    UILabel *intonLabel;
}

@end

@implementation XIntroductionViewController

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
}

- (void)viewLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat labelSpaceing = 20;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:titleLabel];
    y += titleLabel.bounds.size.height + labelSpaceing;
    
    yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 15)];
    yearLabel.text = @"年份：";
    yearLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:yearLabel];
    y += yearLabel.bounds.size.height + labelSpaceing;
    
    regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 15)];
    regionLabel.text = @"地区：";
    regionLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:regionLabel];
    y += regionLabel.bounds.size.height + labelSpaceing;
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 15)];
    typeLabel.text = @"类型：";
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:typeLabel];
    y += typeLabel.bounds.size.height + labelSpaceing;
    
    dirtLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 15)];
    dirtLabel.text = @"导演：";
    dirtLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:dirtLabel];
    y += dirtLabel.bounds.size.height + labelSpaceing;
    
    actorLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 15)];
    actorLabel.text = @"主演：";
    actorLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:actorLabel];
    y += actorLabel.bounds.size.height + labelSpaceing;
    
    intonLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 100)];
    NSLog(@"intonLabel rect = %@", NSStringFromCGRect(intonLabel.frame));
    intonLabel.text = @"简介：";
    intonLabel.numberOfLines = 0;
    intonLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:intonLabel];
    y += intonLabel.bounds.size.height;
    
    NSLog(@"frame height = %f, size height = %f", SCREEN_HEIGHT - 150 - 44, y - 10);
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 150 - 44 - 44);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, y + 30);
}

- (void)parseIntroductionContent:(NSDictionary*)detailDic
{
    if (detailDic == nil)
        return;
    
    [self viewLayout];
    
    NSDictionary *subDic = [detailDic objectForKey:@"Sub"];
    if (subDic != nil)
    {
        NSString *strYear = [[subDic objectForKey:@"pubtime"] objectForKey:@"text"];
        yearLabel.text = [NSString stringWithFormat:@"年份：%@", strYear];
        
        NSString *strRegion = [[subDic objectForKey:@"region"] objectForKey:@"text"];
        regionLabel.text = [NSString stringWithFormat:@"地区：%@", strRegion];
        
        NSString *strType = [[subDic objectForKey:@"type"] objectForKey:@"text"];
        typeLabel.text = [NSString stringWithFormat:@"类型：%@", strType];
        
        NSString *strDirt = [[subDic objectForKey:@"dirt"] objectForKey:@"text"];
        dirtLabel.text = [NSString stringWithFormat:@"导演：%@", strDirt];
        
        NSString *strActor = [[subDic objectForKey:@"actor"] objectForKey:@"text"];
        actorLabel.text = [NSString stringWithFormat:@"主演：%@", strActor];
        
        NSString *strInton = [[subDic objectForKey:@"inton"] objectForKey:@"text"];
        intonLabel.text = [NSString stringWithFormat:@"简介：%@", strInton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
