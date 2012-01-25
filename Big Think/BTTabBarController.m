//
//  BTTabBarController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BTTabBarController.h"
#import "CustomSelectionView.h"
#import "BTTabBarBackroundLayer.h"
#import "BTTabBarItem.h"
#import "UIView+Positioning.h"

@interface BTTabBarController()
{
    CGSize _tabBarSize;

}
-(void)setupTabView;
@end

@implementation BTTabBarController
@synthesize tab1 = _tab1;
@synthesize tab2 = _tab2;
@synthesize viewControllers;

-(id)init
{
    self = [super init];
    if(self){
        _currentTab = 0;  

    }
    return self;
}


-(void)setupTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.)];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [tabView setDelegate:self];
        
    UIImage * worldIcon = [UIImage imageNamed:@"world.png"];
    UIImage * gamesIcon = [UIImage imageNamed:@"games.png"];
    UIImage * worldIconSelected = [UIImage imageNamed:@"worldSelected.png"];
    UIImage * gamesIconSelected = [UIImage imageNamed:@"gamesSelected.png"];
    
    BTTabBarItem * tabItem1 = [[BTTabBarItem alloc]initWithTitle:@"Explore" icon:worldIcon alternateIcon:worldIconSelected];
    BTTabBarItem * tabItem2 = [[BTTabBarItem alloc]initWithTitle:@"Speakers" icon:gamesIcon alternateIcon:gamesIconSelected];
    
    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
  
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:50.0f];
    [tabView setBackgroundLayer:[[BTTabBarBackroundLayer alloc]init] ];
    [tabView setSelectedIndex:_currentTab];
    [self.view addSubview:tabView];
    _tabBarView = tabView;
    _tabBarSize = tabView.frame.size;
}

                            
-(void)viewDidLoad
{  
    [self setupTabView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIViewController *viewController = (UIViewController*)[viewControllers objectAtIndex:0]; 
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, 10 + self.view.frame.size.height - _tabBarSize.height);
    [self.view insertSubview:viewController.view belowSubview:_tabBarView];
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{    
    NSLog(@"Selected Tab Index: %d", itemIndex);

    if (itemIndex == _currentTab)
        return;

    UIViewController* currentViewController = [viewControllers objectAtIndex:_currentTab];
    [currentViewController.view removeFromSuperview];
        
    UIViewController* selectedViewController = [viewControllers objectAtIndex:itemIndex];
    selectedViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, 10 + self.view.frame.size.height - _tabBarSize.height);

    [self.view insertSubview:selectedViewController.view belowSubview:_tabBarView];
    _currentTab = itemIndex;
    
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
