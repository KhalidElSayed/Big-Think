//
//  ViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMatrixView.h"
#import "JMTabView.h"

@interface ExploreViewController : UIViewController <RKMatrixViewDelegate, RKMatrixViewDatasource, JMTabViewDelegate>
{
    RKMatrixView*   _matrixView;
    JMTabView*      _tabView;
}

@property (strong, nonatomic) IBOutlet RKMatrixView *matrixView;

- (IBAction)sliderChanged:(UISlider *)sender;
- (IBAction)layoutSegmentChanged:(UISegmentedControl *)sender;

@end
