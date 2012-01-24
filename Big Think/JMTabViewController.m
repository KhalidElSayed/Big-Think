//  Created by Jason Morrissey

#import "JMTabViewController.h"
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"

#import "UIView+Positioning.h"

@interface JMTabViewController()
{
    CGSize _tabBarSize;
}
-(void)addStandardTabView;
-(void)addCustomTabView;
@end

@implementation JMTabViewController
@synthesize tab1 = _tab1;
@synthesize tab2 = _tab2;
@synthesize viewControllers;

-(id)init
{
    self = [super init];
    if(self){
       }
    return self;
}

-(void)addStandardTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60.)];
    
    [tabView setDelegate:self];
    
    [tabView addTabItemWithTitle:@"One" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
   
    //    You can run blocks by specifiying an executeBlock: paremeter
    //    #if NS_BLOCKS_AVAILABLE
    //    [tabView addTabItemWithTitle:@"One" icon:nil executeBlock:^{NSLog(@"abc");}];
    //    #endif
    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
    

    
}

-(void)addCustomTabView;
{
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.)];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [tabView setDelegate:self];
        
    UIImage * worldIcon = [UIImage imageNamed:@"world.png"];
    UIImage * gamesIcon = [UIImage imageNamed:@"games.png"];
    
    CustomTabItem * tabItem1 = [CustomTabItem tabItemWithTitle:@"One" icon:worldIcon alternateIcon:worldIcon];
    CustomTabItem * tabItem2 = [CustomTabItem tabItemWithTitle:@"Two" icon:gamesIcon alternateIcon:gamesIcon];
    
    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
  
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:10.0f];
    [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] initWithType:0]];
    [tabView setSelectedIndex:_currentTab];
    [self.view addSubview:tabView];
}

-(void)loadView;
{
    
}
                            
-(void)viewDidLoad
{
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _tabBarSize = CGSizeMake(self.view.bounds.size.width, 60.0f);
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - _tabBarSize.height)];

    _currentTab = 0;    
    [self.view addSubview:_containerView];
    
    
    UIView *view = [(UIViewController*)[viewControllers objectAtIndex:0] view]; 
    [_containerView addSubview:view];
    [self addCustomTabView];
    //[self addStandardTabView];
    
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);

    if (itemIndex == _currentTab)
        return;

    UIViewController* currentViewController = [viewControllers objectAtIndex:_currentTab];
    [currentViewController.view removeFromSuperview];
        
    UIViewController* selectedViewController = [viewControllers objectAtIndex:itemIndex];
    [_containerView addSubview:selectedViewController.view];
    
    _currentTab = itemIndex;
    
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
