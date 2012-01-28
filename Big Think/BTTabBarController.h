//
//  BTTabBarController.h
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//  Tabbar Controller. Utilizes the JMTabView created by Jason Morrissey
//  His Repo can be found here : https://github.com/jasonmorrissey/JMTabView

#import <Foundation/Foundation.h>
#import "JMTabView.h"

@class ExploreViewController;
@class SpeakerViewController;

@interface BTTabBarController : UIViewController <JMTabViewDelegate>
{
    UIView*     _containerView;
    NSUInteger  _currentTab;
    JMTabView*   _tabBarView;
}
@property (strong,nonatomic) ExploreViewController* tab1;
@property (strong,nonatomic) SpeakerViewController* tab2;
@property (copy,nonatomic) NSArray* viewControllers;

-(void)addTabWithViewController:(UIViewController *)viewController;

@end
