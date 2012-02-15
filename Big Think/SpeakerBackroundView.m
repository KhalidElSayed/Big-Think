//
//  SpeakerBackroundView.m
//  Big Think
//
//  Created by Richard Kirk on 2/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SpeakerBackroundView.h"

@implementation SpeakerBackroundView
@synthesize leftImageView;
@synthesize rightImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
              
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{   
    if(leftImageView.image == nil)
    leftImageView.image = [[UIImage imageNamed:@"speakerImageBackround.png"] stretchableImageWithLeftCapWidth:26 topCapHeight:11];
    
    if(rightImageView.image  == nil)
    rightImageView.image = [[UIImage imageNamed:@"speakerBackround.png"] stretchableImageWithLeftCapWidth:125 topCapHeight:18];

}
@end
