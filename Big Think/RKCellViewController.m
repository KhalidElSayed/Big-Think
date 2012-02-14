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

@interface RKCellViewController () 

-(void)mediaPlayerDidChangeState;
@end


@implementation RKCellViewController
@synthesize backroundImageView;
@synthesize buttonCaseImageView;
@synthesize location, currentLayout = _currentLayout;
@synthesize testLabel;
@synthesize speakerLabel;
@synthesize videoImageView;
@synthesize videoDescriptionLabel;

@synthesize caseButtons;
@synthesize videoPlaceHolderView;
@synthesize videoViewInsideMainView;
@synthesize playButton;
@synthesize largeButtonsView;
@synthesize shareBig;
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
    
    
    _player = [[MPMoviePlayerController alloc]init];
    [_player setFullscreen:NO];
    _player.view.frame = self.videoViewInsideMainView.bounds;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.videoViewInsideMainView addSubview:_player.view];
    
    //[_player.backgroundView addSubview:self.videoPlaceHolderView];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayerDidChangeState) name:@"MPMoviePlayerPlaybackStateDidChangeNotification" object:_player];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_video)
    {
        //self.speakerLabel.text = _video.speaker.name;
        self.speakerLabel.text = [NSString stringWithFormat:@"{%i,%i}", location.row, location.column];
        self.videoDescriptionLabel.text = _video.title;
        self.videoImageView.image = _video.image;
        _player.contentURL = _video.url;
        
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
    [self setVideoPlaceHolderView:nil];
    [self setVideoViewInsideMainView:nil];
    [self setPlayButton:nil];
    [self setLargeButtonsView:nil];
    [self setShareBig:nil];
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
    self.videoDescriptionLabel.text = newVideo.title;
    self.videoImageView.image = newVideo.image;
    _player.contentURL = _video.url;
    
    
    _video = newVideo;
}


-(void)prepareForReuse
{   
    _location.row = -1;
    _location.column = -1;
    [_player stop];
    self.video = nil;
    [self.view removeFromSuperview];
    
}



-(void)setCurrentLayout:(RKGridViewLayoutType)layout
{
    if(layout == _currentLayout)
        return;
    
    if (layout == RKGridViewLayoutLarge) 
    {
        self.speakerLabel.font = [UIFont fontWithName:[self.speakerLabel.font fontName] size:50.0f]; 
        self.videoDescriptionLabel.font = [UIFont fontWithName:[self.videoDescriptionLabel.font fontName] size:115.0f]; 
        
        self.videoDescriptionLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        self.videoDescriptionLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
        self.videoDescriptionLabel.shadowBlur = 5.0f;
        
        self.largeButtonsView.alpha = 1.0f;
        self.playButton.alpha = 1.0f;
        self.shareBig.alpha = 0.0f;
    }
    else if (layout == RKGridViewLayoutMedium) 
    {
        self.speakerLabel.font = [UIFont fontWithName:[self.speakerLabel.font fontName] size:25.0f]; 
        self.videoDescriptionLabel.font = [UIFont fontWithName:[self.videoDescriptionLabel.font fontName] size:50.0f]; 
        self.videoDescriptionLabel.innerShadowOffset = CGSizeMake(0.0f ,0.0f);
        self.videoDescriptionLabel.shadowBlur = 0.0f;
        
        self.largeButtonsView.alpha = 0.0f;
        self.playButton.alpha = 0.0f;
        self.shareBig.alpha = 1.0f;
    }
    else if (layout == RKGridViewLayoutSmall) 
    {   
        self.speakerLabel.font = [UIFont fontWithName:[self.speakerLabel.font fontName] size:25.0f]; 
        self.videoDescriptionLabel.font = [UIFont fontWithName:[self.videoDescriptionLabel.font fontName] size:25.0f]; 
        self.videoDescriptionLabel.innerShadowOffset = CGSizeMake(0.0f ,0.0f);
        self.videoDescriptionLabel.shadowBlur = 0.0f;
        
        self.largeButtonsView.alpha = 0.0f;
        self.playButton.alpha = 0.0f;
        self.shareBig.alpha = 1.0f;
    }
    
    _currentLayout = layout;
    //[self.view setNeedsLayout];
    
}

- (IBAction)playButtonSelected:(id)sender 
{
    self.videoPlaceHolderView.alpha = 0;
    
    [_player play];
}

- (IBAction)saveButtonSelected:(id)sender 
{
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));    
    NSLog(@"%@",NSStringFromCGRect(self.videoViewInsideMainView.frame));
    
    NSLog(@"%@",NSStringFromCGRect(_player.view.frame));
    NSLog(@"%@",NSStringFromCGRect(_player.backgroundView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.videoPlaceHolderView.frame));
    
}


-(void)mediaPlayerDidChangeState
{
    
    MPMoviePlaybackState state = _player.playbackState;
    
    if (state == MPMoviePlaybackStatePaused || state == MPMoviePlaybackStateStopped) 
    {
        self.playButton.alpha = 1.0f;
    }
    else   
        self.playButton.alpha = 0;
    
}

@end
