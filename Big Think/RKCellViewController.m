//
//  RKCellViewController.m
//  Big Think
//
//  Created by Richard Kirk on 2/13/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKCellViewController.h"
#import "FXLabel.h"
#import "BTVideo.h"

@implementation RKCellViewController
@synthesize backroundImageView;
@synthesize buttonCaseImageView;
@synthesize location;
@synthesize testLabel;
@synthesize speakerLabel;
@synthesize videoImageView;
@synthesize videoDescriptionLabel;

@synthesize caseButtons;
@synthesize video;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIImage* strechyBackroundImage = [[UIImage imageNamed:@"ExploreCellBackround.png"]stretchableImageWithLeftCapWidth:16 topCapHeight:65];
    [self.backroundImageView setImage:strechyBackroundImage];
   
    UIImage* strechyButtonCaseImage = [[UIImage imageNamed:@"buttonCase.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:11];
    self.buttonCaseImageView.image = strechyButtonCaseImage;
    
    UIImage* strechyButtonImage = [[UIImage imageNamed:@"greyButtonBackroundImage.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:4];
    UIImage* strechyButtonImageSelected = [[UIImage imageNamed:@"greyButtonBackroundImageSelected.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:3];
    
    for (UIButton* button in self.caseButtons) {
        [button setBackgroundImage:strechyButtonImage forState:UIControlStateNormal];
        [button setBackgroundImage:strechyButtonImageSelected forState:UIControlStateSelected];
                [button setBackgroundImage:strechyButtonImageSelected forState:UIControlStateHighlighted];
    }

    
    speakerLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    speakerLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75];
    speakerLabel.shadowBlur = 5.0f;
    
    videoDescriptionLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    videoDescriptionLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    videoDescriptionLabel.shadowBlur = 5.0f;
    if(_video)
    {
        self.speakerLabel.text = _video.speaker.name;
        self.videoDescriptionLabel.text = _video.title;
        self.videoImageView.image = _video.image;
    }
    
}

- (void)viewDidUnload
{
    [self setBackroundImageView:nil];
    [self setTestLabel:nil];
    [self setSpeakerLabel:nil];
    [self setVideoImageView:nil];
    [self setVideoDescriptionLabel:nil];
    [self setButtonCaseImageView:nil];

    [self setCaseButtons:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)setVideo:(BTVideo *)newVideo
{
    self.speakerLabel.text = newVideo.speaker.name;
    self.videoDescriptionLabel.text = newVideo.description;
    self.videoImageView.image = newVideo.image;
    _video = newVideo;
}


-(void)prepareForReuse
{   
    _location.row = -1;
    _location.column = -1;
    [self.view removeFromSuperview];
    
}

- (IBAction)playButtonSelected:(id)sender {
}
@end
