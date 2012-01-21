//
//  ViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMatrixView.h"

@interface ViewController : UIViewController <RKMatrixViewDelegate, RKMatrixViewDatasource>
{
    RKMatrixView*   _matrixView;
}

@property (strong, nonatomic) IBOutlet RKMatrixView *matrixView;

- (IBAction)sliderChanged:(UISlider *)sender;

@end
