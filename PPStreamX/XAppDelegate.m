//
//  XAppDelegate.m
//  PPStreamX
//
//  Created by dwwang on 12/12/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#import "XAppDelegate.h"
#import "XEmsManager.h"
#import "XViewController.h"
#import "XMenuViewController.h"
#import <IIViewDeckController.h>
#import <IISideController.h>

@implementation XAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[XEmsManager startEmsServer];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    XViewController *centerView = [[XViewController alloc] init];
    UINavigationController *navigate = [[UINavigationController alloc] initWithRootViewController:centerView];
    XMenuViewController *menu = [XMenuViewController shareMenuViewController];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:navigate leftViewController:[IISideController sideControllerWithViewController:menu constrained:44]];
    deckController.leftSize = SCREEN_WIDTH - 44;
    deckController.delegateMode = IIViewDeckDelegateAndSubControllers;
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
