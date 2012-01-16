//
//  ViewController.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ViewController.h"
#import "RKMatrixViewCell.h"
#import "RKMediumCellView.h"
#import "RKLargeCellView.h"

@implementation ViewController
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
   
    [_matrixView demoo];



}

- (void)viewDidUnload
{
    [self setMatrixView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - RKMatrixViewDatasource Functions

-(UIView *) matrixView:(RKMatrixView *)matrixView viewForLocation:(RK2DLocation)location withFrame:(CGRect)frame
{
    RKLargeCellView *cell = [[RKLargeCellView alloc]initWithFrame:frame];
    //RKMediumCellView  *cell = [[RKMediumCellView alloc]initWithFrame:frame];
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

        return YES;

}

@end
