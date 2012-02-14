//
//  RKCellViewController.h
//  Big Think
//
//  Created by Richard Kirk on 2/13/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RKMatrixView.h"

@class BTVideo;
@class FXLabel;

@interface RKCellViewController : UIViewController 
{
    RK2DLocation                _location;
    RKGridViewLayoutType        _currentLayout;
    BTVideo*                    _video;
    MPMoviePlayerController*    _player;
    
}
@property (strong, nonatomic) BTVideo* video;
@property (nonatomic)RK2DLocation location;
@property (nonatomic)RKGridViewLayoutType currentLayout;


@property (strong, nonatomic) IBOutlet UIImageView *backroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *buttonCaseImageView;
@property (strong, nonatomic) IBOutlet UILabel *testLabel;
@property (strong, nonatomic) IBOutlet FXLabel *speakerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet FXLabel *videoDescriptionLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *caseButtons;
@property (strong, nonatomic) IBOutlet UIView *videoPlaceHolderView;
@property (strong, nonatomic) IBOutlet UIView *videoViewInsideMainView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIView *largeButtonsView;
@property (strong, nonatomic) IBOutlet UIButton *shareBig;

-(void)prepareForReuse;
- (IBAction)playButtonSelected:(id)sender;
- (IBAction)saveButtonSelected:(id)sender;

@end
