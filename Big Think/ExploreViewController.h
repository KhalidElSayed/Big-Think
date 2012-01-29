//
//  ViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMatrixView.h"
#import "BTTabView.h"
#import "DetailTableViewController.h"
@interface ExploreViewController : UIViewController <RKMatrixViewDelegate, RKMatrixViewDatasource, JMTabViewDelegate, DetailTableDelegate>
{
    RKMatrixView*       _matrixView;
    BTTabView*          _tabView;
    NSMutableArray*     _chosenFilters;
}
@property (strong, nonatomic) IBOutlet RKMatrixView *matrixView;
@property (strong, nonatomic) IBOutlet UINavigationController *filterNavController;

-(void)filterButtonPressed;

@end
