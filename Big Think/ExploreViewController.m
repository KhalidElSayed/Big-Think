//
//  ViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ExploreViewController.h"
#import "RKMatrixViewCell.h"
#import "RKMediumCellView.h"
#import "RKLargeCellView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"

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
    [_matrixView demoo];
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
    JMTabView * tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60.)];
    
    [tabView setDelegate:self];
    
    [tabView addTabItemWithTitle:@"One" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
    tabView.clipsToBounds = NO;    
    //    You can run blocks by specifiying an executeBlock: paremeter
    //    #if NS_BLOCKS_AVAILABLE
    //    [tabView addTabItemWithTitle:@"One" icon:nil executeBlock:^{NSLog(@"abc");}];
    //    #endif
    
    [tabView setBackgroundLayer:nil];
    tabView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarHeader.png"]];
    
   // [tabView setBackgroundLayer:[[CustomBackgroundLayer alloc] initWithType:1]];
    [tabView setSelectedIndex:0];
    [tabView alignRight];
    _tabView = tabView;
    [self.view addSubview:tabView];

    
}

#pragma mark - RKMatrixViewDatasource Functions

-(UIView *) matrixView:(RKMatrixView *)matrixView viewForLocation:(RK2DLocation)location withFrame:(CGRect)frame
{
        RKLargeCellView *cell = [[RKLargeCellView alloc]initWithFrame:frame];
             return cell;
}


-(RKMatrixViewCell *)matrixView:(RKMatrixView *)matrixView cellForLocation:(RK2DLocation)location
{
    
    RKMatrixViewCell *cell = [_matrixView dequeResuableCell];    
    if(!cell)
    {
        cell = [[RKMatrixViewCell alloc]init];
       
    }
    RKLargeCellView *view = [[RKLargeCellView alloc]initWithFrame:CGRectZero];
    //UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    //label.text = [NSString stringWithFormat:@"{%i,%i}",location.row, location.column];
    //[view addSubview:label];
    //label.backgroundColor = [UIColor clearColor];
    //view.backgroundColor = [UIColor randomColor];

   view.header.text = [NSString stringWithFormat:@"{%i,%i}",location.row, location.column];
    cell.contentView = view;

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

- (IBAction)sliderChanged:(UISlider *)sender 
{
   
   
}

- (IBAction)layoutSegmentChanged:(UISegmentedControl *)sender 
{
    [self.matrixView setLayout:sender.selectedSegmentIndex];
}

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex
{
        [self.matrixView setLayout:itemIndex];
}

@end
