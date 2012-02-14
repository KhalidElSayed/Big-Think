//
//  BTTabBarController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BTTabBarController.h"
#import "ExploreViewController.h"
#import "SpeakerViewController.h"
#import "FeaturedViewController.h"
#import "CatagoriesViewController.h"
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
@synthesize tab3 = _tab3;
@synthesize tab4 = _tab4;
@synthesize tab5 = _tab5;

@synthesize viewControllers;

-(id)init
{
    self = [super init];
    if(self){
        _currentTab = 0;  
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _tab1 = [[FeaturedViewController alloc]initWithNibName:@"FeaturedViewController" bundle:nil];
            _tab2 = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController_iPad" bundle:nil];
            _tab3 = [[SpeakerViewController alloc] initWithNibName:@"SpeakerViewController_iPad" bundle:nil];
            _tab4 = [[CatagoriesViewController alloc]initWithNibName:@"CatagoriesViewController" bundle:nil];
           
            self.viewControllers = [NSArray arrayWithObjects:_tab1,_tab2, _tab3, _tab4, _tab5 ,nil];
            
            
        } else {
            _tab2 = [[ExploreViewController alloc] initWithNibName:@"ExploreViewController_iPhone" bundle:nil];
            _tab3 = [[SpeakerViewController alloc] initWithNibName:@"SpeakerViewController_iPhone" bundle:nil];
            self.viewControllers = [NSArray arrayWithObjects:_tab2,_tab3 ,nil];

        }
        
    }
    return self;
}


-(void)setupTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.)];
    tabView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    [tabView setDelegate:self];
        
    UIImage * worldIcon = [UIImage imageNamed:@"world.png"];
    UIImage * gamesIcon = [UIImage imageNamed:@"games.png"];
    UIImage * fireIcon = [UIImage imageNamed:@"fire.png"];
    UIImage * catagoriesIcon = [UIImage imageNamed:@"46-movie-2.png"];

    
    UIImage * worldIconSelected = [UIImage imageNamed:@"worldSelected.png"];
    UIImage * gamesIconSelected = [UIImage imageNamed:@"gamesSelected.png"];
    UIImage * fireIconSelected = [UIImage imageNamed:@"fireSelected.png"];
    UIImage * catagoriesIconSelected = [UIImage imageNamed:@"46-movie-2Selected.png"];
    
    
    BTTabBarItem * tabItem1 = [[BTTabBarItem alloc]initWithTitle:@"Featured" icon:fireIcon alternateIcon:fireIconSelected];
    BTTabBarItem * tabItem2 = [[BTTabBarItem alloc]initWithTitle:@"Explore" icon:worldIcon alternateIcon:worldIconSelected];
    BTTabBarItem * tabItem3 = [[BTTabBarItem alloc]initWithTitle:@"Speakers" icon:gamesIcon alternateIcon:gamesIconSelected];
    BTTabBarItem * tabItem4 = [[BTTabBarItem alloc]initWithTitle:@"Topics" icon:catagoriesIcon alternateIcon:catagoriesIconSelected];

    
    
    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
    [tabView addTabItem:tabItem3];
    [tabView addTabItem:tabItem4];
  
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:10.0f];
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
    [self addChildViewController:_tab1];
    [self addChildViewController:_tab2];

    
    UIViewController *viewController = (UIViewController*)[viewControllers objectAtIndex:0]; 
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, 10 + self.view.frame.size.height - _tabBarSize.height);
    [self.view insertSubview:viewController.view belowSubview:_tabBarView];
    
    //_-----------------_----_--_--__-------
    [self tabView:nil didSelectTabAtIndex:1];
    //_-----------------_----_--_--__-------    
    
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{    
    NSLog(@"Selected Tab Index: %d", itemIndex);

    if (itemIndex == _currentTab)
        return;

    UIViewController* currentViewController = [viewControllers objectAtIndex:_currentTab];
    [currentViewController.view removeFromSuperview];
        
    UIViewController* selectedViewController = [viewControllers objectAtIndex:itemIndex];
    selectedViewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 10 + self.view.bounds.size.height - _tabBarSize.height);

    [self.view insertSubview:selectedViewController.view belowSubview:_tabBarView];
    _currentTab = itemIndex;
    
    
}


-(void)viewWillLayoutSubviews
{
    _tabBarView.frame = CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.);
    for (BTTabBarItem* item in _tabBarView.tabItems) {
        item.fixedWidth = floorf( self.view.bounds.size.width / [_tabBarView.tabItems count]);
    }
}


-(void)addTabWithViewController:(UIViewController *)viewController
{
    
    [self addChildViewController:viewController];

}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    
    
    return YES;
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

@end
