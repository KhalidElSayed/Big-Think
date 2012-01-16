//
//  RKLargeCellView.m
//  Big Think
//
//  Created by Richard Kirk on 1/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKLargeCellView_BACKUP.h"

@interface RKLargeCellView_BACKUP () 
{
    CGRect      _additionalInfoFrame;
    CGSize      _headerSize;
    CGFloat     _headerFontSize;
    CGFloat     _titleFontSize;
    CGRect      _videoPaddingFrame;
    CGRect      _imgViewFrame;
    CGRect      _titleFrame;
}
-(void)initForDevice:(UIUserInterfaceIdiom)idiom;
@end

@implementation RKLargeCellView_BACKUP
@synthesize header = _header;
@synthesize title = _title;

-(void)initForDevice:(UIUserInterfaceIdiom)idiom
{
    if (idiom == UIUserInterfaceIdiomPad) 
    {
        
        _headerSize = CGSizeMake(self.frame.size.width, 90.0f);
        _headerFontSize = 118.0f;
        _titleFontSize = 80.0f;
        _videoPaddingFrame = CGRectMake(0, 90.0f, self.frame.size.width, 500.0f);
        _imgViewFrame = CGRectMake(10, 25, _videoPaddingFrame.size.width - 20, _videoPaddingFrame.size.height - 50);        
        _additionalInfoFrame = CGRectMake(10, 600, 648, 250);
        _titleFrame = CGRectMake(60, 25, 540, 450);
        
    }
    else 
    {
        _headerSize = CGSizeMake(self.frame.size.width, 50.0f);
        _titleFontSize = 30.0f;
        _headerFontSize = 60.0f;
        _videoPaddingFrame = CGRectMake(0, 60.0f, self.frame.size.width, 240.0f);
        _imgViewFrame = CGRectMake(6, 12, _videoPaddingFrame.size.width - 12, _videoPaddingFrame.size.height - 24);        
        _additionalInfoFrame = CGRectMake(7, 300, 280, 80);
        _titleFrame = _videoPaddingFrame;
    }
    
    
    
    
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleTopMargin;
    

    
    
    CGRect headerFrame;
    headerFrame.origin = CGPointZero;
    headerFrame.size = _headerSize;
    
    _header = [[UILabel alloc]initWithFrame:headerFrame];
    _header.autoresizingMask = UIViewAutoresizingFlexibleWidth    |
    UIViewAutoresizingFlexibleBottomMargin;
    
    
    _header.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:_headerFontSize];
    _header.backgroundColor = [UIColor clearColor];
    _header.textAlignment = UITextAlignmentCenter;
    _header.textColor = [UIColor whiteColor];
    _header.adjustsFontSizeToFitWidth = YES;
    _header.minimumFontSize = 30;
    
    [self addSubview:_header];
    
    UIView *videoPadding = [[UIView alloc]initWithFrame:_videoPaddingFrame];
    videoPadding.backgroundColor = [UIColor blackColor];
    videoPadding.autoresizingMask =  UIViewAutoresizingFlexibleWidth;    
    
    _imgView = [[UIImageView alloc]initWithFrame:_imgViewFrame];
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    
    UIView *imageOverlay = [[UIView alloc]initWithFrame:videoPadding.bounds];
    imageOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.64f];
    imageOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    
    
    
    
    _title = [[UILabel alloc]initWithFrame:_titleFrame];
    
    _title.font = [UIFont fontWithName:@"ChaparralPro-Regular" size:_titleFontSize]; 
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor rgbColorWithRed:232.0f green:84.0f blue:34.0f alpha:1.0f];
    _title.textAlignment = UITextAlignmentCenter;
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumFontSize = 5;
    _title.numberOfLines = 0;
    _title.lineBreakMode = UILineBreakModeWordWrap;
    _title.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
    UIViewAutoresizingFlexibleHeight        | 
    UIViewAutoresizingFlexibleBottomMargin  | 
    UIViewAutoresizingFlexibleLeftMargin    | 
    UIViewAutoresizingFlexibleRightMargin   | 
    UIViewAutoresizingFlexibleTopMargin;
    
    
    [imageOverlay addSubview:_title];
    
    [videoPadding addSubview:_imgView];
    [videoPadding addSubview:imageOverlay];
    [self addSubview:videoPadding];
    
    
    
    
    _additionalInfoView = [[UIView alloc]initWithFrame:_additionalInfoFrame];
    _additionalInfoView.backgroundColor = [UIColor blackColor];
    
    UILabel *info = [[UILabel alloc]initWithFrame:[_additionalInfoView bounds]];
    info.backgroundColor = [UIColor clearColor];
    info.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    info.textColor = [UIColor whiteColor];
    info.textAlignment = UITextAlignmentCenter;
    info.text = @"Possible area for additional info in portrait mode";
    info.numberOfLines = 0;
    [_additionalInfoView addSubview:info];
    
    if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice]orientation]))
    {
        [self addSubview:_additionalInfoView];
    }
    
    //---------------------Testing------------------------
    _imgView.image = [UIImage imageNamed:@"shot.jpg"]; 
    _title.text = @"Why Tolerance is Condescending";
    _header.text = @"PENN JILLETE";
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotate:) name:UIApplicationWillChangeStatusBarOrientationNotification  object:nil];
    
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initForDevice:[[UIDevice currentDevice] userInterfaceIdiom]];
        
    }
    
    return self;
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification  object:nil];
}

-(void)willRotate:(NSNotification *)notification
{
    
    NSNumber *num = [notification.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"];
    
    switch ([num intValue]) 
    {
        case 1:
        case 2:
            NSLog(@"Orientation Changed to Portrait");
            /*
             NSLog(@"self.frame : %f, %f, %f , %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
             NSLog(@"_scrollView.frame : %f, %f, %f , %f", _scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);        
             NSLog(@"_firstCell.frame : %f, %f, %f , %f", _firstCell.frame.origin.x, _firstCell.frame.origin.y, _firstCell.frame.size.width, _firstCell.frame.size.height);        
             */ 
            
            [self addSubview:_additionalInfoView];
            break;
        case 3:
        case 4:
            NSLog(@"Orientation Changed to Landscape");
            /*
             NSLog(@"self.frame : %f, %f, %f , %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
             NSLog(@"_scrollView.frame : %f, %f, %f , %f", _scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);        
             NSLog(@"_firstCell.frame : %f, %f, %f , %f", _firstCell.frame.origin.x, _firstCell.frame.origin.y, _firstCell.frame.size.width, _firstCell.frame.size.height);        
             */
            [_additionalInfoView removeFromSuperview];
            
            break;
        default:
            break;
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
