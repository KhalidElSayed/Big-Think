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
@class FeaturedViewController;
@class CatagoriesViewController;
@class SearchViewController;

@interface BTTabBarController : UIViewController <JMTabViewDelegate>
{
    UIView*     _containerView;
    NSUInteger  _currentTab;
    JMTabView*   _tabBarView;
}
@property (strong,nonatomic) FeaturedViewController* tab1;
@property (strong,nonatomic) ExploreViewController* tab2;
@property (strong,nonatomic) SpeakerViewController* tab3;
@property (strong, nonatomic) CatagoriesViewController* tab4;
@property (strong, nonatomic) SearchViewController* tab5;
@property (copy,nonatomic) NSArray* viewControllers;

-(void)addTabWithViewController:(UIViewController *)viewController;

@end
