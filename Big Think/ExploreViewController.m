//
//  ViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ExploreViewController.h"
#import "FilterTableViewController.h"
#import "RKMatrixViewCell.h"
#import "RKMediumCellView.h"
#import "RKLargeCellView.h"
#import "BTTabView.h"
#import "FXLabel.h"
#import "RKTagButton.h"
#import "DataBank.h"
#define TAB_VIEW_HEIGHT 60.0f

@interface ExploreViewController()
{
    BOOL _showingFilter;
    UINavigationController* filterTable;
}
-(void)setupTabView;
-(void)animateTagTableIfNecessary;
@end
@implementation ExploreViewController
@synthesize matrixView = _matrixView;
@synthesize filterNavController = _filterNavController;

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
    
    [self addChildViewController:_filterNavController];
    [self.view addSubview:_filterNavController.view];
    
    _chosenFilters = [[NSMutableArray alloc]init];
    
    
    //_tagTable = [[RKTagBankView alloc] initWithFrame:CGRectMake(50.0f, -48.0f, self.view.bounds.size.width - 100, 48.0f)];
    //_tagTable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //_tagTable.backgroundColor = [UIColor orangeColor];
    
   // [self.view insertSubview:_tagTable belowSubview:_tabView];
    
    [_matrixView demoo];
}

- (void)viewDidUnload
{
    [self setMatrixView:nil];
    [self setFilterNavController:nil];
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

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex
{
        [self.matrixView setLayout:itemIndex];
}



-(void)filterButtonPressed
{
    CGRect filterFrame = _filterNavController.view.frame;
    CGRect matrixFrame = _matrixView.frame;
    if (_showingFilter)
    {
        filterFrame.origin.x = -filterFrame.size.width;
        matrixFrame.origin.x = 0;
        
    }
    else 
    {
        filterFrame.origin.x = 0;
        matrixFrame.origin.x = filterFrame.size.width;
    }
    
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
        _filterNavController.view.frame = filterFrame;
        _matrixView.frame = matrixFrame;
    } completion:^(BOOL finished){
    
        _showingFilter = !_showingFilter;
    } ];
    
    
    
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect filterFrame = self.view.bounds;
    filterFrame.origin.y = TAB_VIEW_HEIGHT;
    filterFrame.size.height -= TAB_VIEW_HEIGHT;
    filterFrame.size.width = 320.0f;
    if (!_showingFilter)
        filterFrame.origin.x = -320.f;
    
    _filterNavController.view.frame = filterFrame;
    
     
    
}

#pragma mark - DetailTableDelegate
-(void)didSelectObject:(id)obj
{
    RKTagButton *button = [[RKTagButton alloc]initWithTag:(NSString*)obj];
    [button addTarget:self action:@selector(removeTagButton:) forControlEvents:UIControlEventTouchUpInside];
    
   // [_tagTable addRKTag:button];
   // [self animateTagTableIfNecessary];
}


-(void)didDeselectObject:(id)obj
{
   
    //[_tagTable removeTagWithString:(NSString*)obj];
    //[self animateTagTableIfNecessary];
}


-(void)removeTagButton:(id)sender
{
   
    //[_tagTable removeRKTag:(RKTagButton*)sender];
    //[self animateTagTableIfNecessary];
}

-(void)animateTagTableIfNecessary
{
    
    if([_tagTable.tags count] > 0 && _tagTable.frame.origin.y < 0) // First tag chosen, animate tagtable into view;
    {
        CGRect tagTableFrame = _tagTable.frame;
        tagTableFrame.origin.y = 60.0f;
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
            _tagTable.frame = tagTableFrame;
        } completion:^(BOOL finished){  }];
    }
    else if([_tagTable.tags count] == 0)
    {
        CGRect tagTableFrame = _tagTable.frame;
        tagTableFrame.origin.y = -tagTableFrame.size.height;
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
            _tagTable.frame = tagTableFrame;
        } completion:^(BOOL finished){  }];

    }

}



@end
