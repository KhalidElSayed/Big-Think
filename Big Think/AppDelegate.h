//
//  AppDelegate.h
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BTTabBarController *tabBarController;

@end
