//
//  SpeakerViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/23/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SpeakerViewController.h"
#import "SpeakerTableViewCell.h"
#import "RKCellViewController.h"
#import "DataBank.h"



@implementation SpeakerViewController
@synthesize tableView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _speaker = [DataBank speakerWithName:@"Penny Jilette"];
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
    
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {return nil;};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"BTSpeakerTableViewCell";
    
    SpeakerTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpeakerTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
   
    cell.speaker = _speaker;
    cell.delegate = self;
    
    return cell;
}


-(void)speakerCell:(SpeakerTableViewCell*)speakerCell didSelectVideo:(BTVideo *)video
{
   
    MPMoviePlayerViewController *cont = [[MPMoviePlayerViewController alloc]initWithContentURL:video.url];

    [self presentMoviePlayerViewControllerAnimated:cont];
    
    /*
    RKCellViewController *modalView = [[RKCellViewController alloc]initWithNibName:@"RKCellViewController" bundle:nil];
    [modalView setVideo:video];
   // modalView.view.frame = CGRectMake(100, 100, 924, 660);
    
    
    
    [modalView setModalPresentationStyle:UIModalPresentationPageSheet];
    [modalView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    
    [self presentModalViewController:modalView animated:YES];

    modalView.view.superview.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleBottomMargin;    
    
    modalView.view.superview.frame = CGRectMake(
                                                     50,
                                                     50,
                                                     900.0f,
                                                     600.0f);
    */
    
}

@end
