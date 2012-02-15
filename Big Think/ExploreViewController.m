//
//  ViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ExploreViewController.h"
#import "RKCellViewController.h"
#import "BTTabView.h"
#import "FXLabel.h"
#import "DataBank.h"


#define TAB_VIEW_HEIGHT 60.0f

@interface ExploreViewController()
-(void)setupTabView;

@end
@implementation ExploreViewController
@synthesize matrixView = _matrixView;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _matrixView.datasource = self;
    _matrixView.delegate = self;
    [self setupTabView];
    
 
}

- (void)viewDidUnload
{
    [self setMatrixView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setupTabView
{
    BTTabView * tabView = [[BTTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TAB_VIEW_HEIGHT)];
    [tabView setDelegate:self];
    
    [tabView addTabItemWithTitle:@"One" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
    tabView.clipsToBounds = YES;    
    
    [tabView setBackgroundLayer:nil];
    
    
    tabView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarHeader.png"]];
    
    FXLabel *bigThinkLabel = [[FXLabel alloc]initWithFrame:CGRectMake(0, 0, 400, TAB_VIEW_HEIGHT)];
    
    bigThinkLabel.shadowColor = nil;
    bigThinkLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    bigThinkLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    bigThinkLabel.shadowBlur = 5.0f;
    bigThinkLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:50.0f];
    bigThinkLabel.text = @"BIG THINK";
    bigThinkLabel.textColor = [UIColor whiteColor];
    bigThinkLabel.backgroundColor = [UIColor clearColor];
    bigThinkLabel.userInteractionEnabled = YES;
    // UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterButtonPressed)];
    //[touch setNumberOfTapsRequired:2];
    //[bigThinkLabel addGestureRecognizer:touch];
    
    tabView.middleView = bigThinkLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.titleLabel.text = @"Filter";
    
    [button addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    tabView.leftView = button;
    
    [tabView setSelectedIndex:0];
    
    _tabView = tabView;
    [self.view addSubview:tabView];
    
    
}

#pragma mark - RKMatrixViewDatasource Functions

-(RKCellViewController *)matrixView:(RKMatrixView *)matrixView cellForLocation:(RK2DLocation)location
{
    RKCellViewController *cell = [_matrixView dequeResuableCell];    
    if(!cell)
    {
        cell = [[RKCellViewController alloc]initWithNibName:@"RKCellViewController" bundle:nil];
    } 
    [cell setVideo:[DataBank videoWithId:0]];

    return cell;
}



-(int)numberOfCellsInMatrix:(RKMatrixView *)matrix
{
    return 25;  // **** need to get to this ****
    // The amount of cells needs to be a perfect square
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex
{
    [self.matrixView setLayout:itemIndex];
}





@end
