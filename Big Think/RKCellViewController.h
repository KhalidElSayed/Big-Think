//
//  RKCellViewController.h
//  Big Think
//
//  Created by Richard Kirk on 2/13/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMatrixView.h"
@class BTVideo;
@class FXLabel;

@interface RKCellViewController : UIViewController
{
    RK2DLocation    _location;
    BTVideo*          _video;
}
@property (strong, nonatomic) BTVideo* video;
@property (nonatomic)RK2DLocation location;
@property (strong, nonatomic) IBOutlet UIImageView *backroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *buttonCaseImageView;
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet FXLabel *speakerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet FXLabel *videoDescriptionLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *caseButtons;

-(void)prepareForReuse;
- (IBAction)playButtonSelected:(id)sender;

@end
