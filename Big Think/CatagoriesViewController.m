//
//  CatagoriesViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/30/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CatagoriesViewController.h"
#import "TopicTableViewCell.h"
#import "TopicsGridViewCell.h"

@implementation CatagoriesViewController
@synthesize tableView = _tableView;
@synthesize gridView = _gridView;
@synthesize topicsTableViewCell;
@synthesize topics = _topics;
@synthesize navBar = _navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _topics = [[NSArray alloc]initWithObjects:@"Arts & Culture", @"Belief", @"Business & Economics", 
                        @"Environment", @"Future", @"Health & Medicine", @"History", @"Identity", @"Inspiration & Wisdom", 
                       @"Life & Death", @"Love, Sex, and Happiness", @"Media & Internet", @"Politics & Policy", @"Science & Tech", @"Truth & Justice",@"World", nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"topicCell"];
    _navBar.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarHeader.png"]];
    _tableShowing = YES;
    UIView* testV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _gridView.frame.size.width, 100)];
    UIView* testM = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _gridView.frame.size.width, 100)];
    testV.backgroundColor = [UIColor randomColor];
        testM.backgroundColor = [UIColor randomColor];
    _gridView.gridHeaderView = testV;
    _gridView.gridFooterView = testM;
    
    [_gridView setSeparatorStyle:AQGridViewCellSeparatorStyleEmptySpace];
    [_gridView setUsesPagedHorizontalScrolling:YES];
    [_gridView setPagingEnabled:YES];
    [_gridView setDirectionalLockEnabled:NO];
    [_gridView reloadData ];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTopicsTableViewCell:nil];
    [self setNavBar:nil];
    [self setGridView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"topicCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    // Configure cell
   // ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"topicsCellBackround.png"];
       cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topicsCellBackround.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topicsCellBackroundSelected.png"]];
    (((TopicTableViewCell*)cell).label).text = [_topics objectAtIndex:indexPath.row];
    (((TopicTableViewCell*)cell).iconImageView).image = [UIImage imageNamed:@"piggy.png"];
  
    return cell;
}


#pragma mark - UITableView Delegate Functions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(!_tableShowing)
    {
    UITableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = cell.frame;
        cellFrame.origin.x = 234.0f;
       
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            cell.frame = cellFrame;
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.5 delay:1.0f options:UIViewAnimationCurveLinear animations:^{
                
                CGRect originalCellFrame = cell.frame;
                originalCellFrame.origin.x = 0.0f;
                cell.frame = originalCellFrame;
                
            } completion:^(BOOL finished){}];
            
            
            
        
        }];
    }
}

#pragma mark - AQGridView Datasource Functions
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return 40;
}


- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString* gridCellIdentifier = @"topicsGridCell";
    
    TopicsGridViewCell* cell = (TopicsGridViewCell*)[_gridView dequeueReusableCellWithIdentifier:gridCellIdentifier];    
    if(cell == nil)
    {
        cell = [[TopicsGridViewCell alloc]initWithFrame:CGRectMake(0, 0, 277, 200) reuseIdentifier:gridCellIdentifier];
    }

    cell.debugLabel.text = [NSString stringWithFormat:@"%i", index];

    
       
    return cell;
}

-(CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    return CGSizeMake(277, 200);
}

- (IBAction)toggleTableButtonSelected:(UIBarButtonItem*)sender
{
    CGRect tableFrame = _tableView.frame;
    CGRect gridFrame = _gridView.frame;
    
    if (_tableShowing)
    {
        tableFrame.origin.x = -235.0f;
        gridFrame.origin.x = 85.0f;
        gridFrame.size.width = self.view.bounds.size.width - 85.0f;
        sender.title = @"Show";
    
    }
    else
    {
        tableFrame.origin.x  = 0;
        gridFrame.origin.x   = tableFrame.size.width;
        gridFrame.size.width = self.view.bounds.size.width - 320;
        sender.title = @"Hide";
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _tableView.frame = tableFrame;
        _gridView.frame = gridFrame;
    } completion:^(BOOL finished){
    if(finished) _tableShowing = !_tableShowing;
    }];
    


}
@end
