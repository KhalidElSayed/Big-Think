//
//  AppDelegate.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "AppDelegate.h"

#import "ExploreViewController.h"
#import "SpeakerViewController.h"
#import "JMTabViewController.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ExploreViewController *tab1;
    SpeakerViewController *tab2;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        tab1 = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController_iPad" bundle:nil];
        tab2 = [[SpeakerViewController alloc] initWithNibName:@"SpeakerViewController_iPad" bundle:nil];
    } else {
        tab1 = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController_iPhone" bundle:nil];
        tab2 = [[SpeakerViewController alloc] initWithNibName:@"SpeakerViewController_iPhone" bundle:nil];
    }
    tab1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Explore" image:[UIImage imageNamed:@"world.png"] tag:0];
    tab2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Speakers" image:[UIImage imageNamed:@"games.png"] tag:1];
    
    
    
    self.tabBarController = [[JMTabViewController alloc]init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:tab1, tab2, nil];

    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
