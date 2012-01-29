//
//  RKTagButton.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKTagButton.h"
#import "FXLabel.h"

@implementation RKTagButton
@synthesize tagString = _tagString;

-(id)initWithTag:(NSString*)newTag
{
    CGRect frame;
    frame.origin = CGPointMake(0, 0);
    frame.size = [newTag sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    frame.size.height = 24.0f;
    if((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        UIImage* strechyImage = [[UIImage imageNamed:@"tagImage.png"] stretchableImageWithLeftCapWidth:22.0f topCapHeight:0.0f];
        _backroundImage = [[UIImageView alloc]initWithImage:strechyImage];
        
        
        _backroundImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_backroundImage];        
        _tagLabel = [[FXLabel alloc]init];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
        _tagLabel.textColor = [UIColor darkGrayColor];
        _tagLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        _tagLabel.shadowOffset = CGSizeMake(0.5f, 1.0f);
        _tagLabel.shadowBlur = 1.0f;
        _tagLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        _tagLabel.innerShadowOffset = CGSizeMake(0.5f, 1.0f);
    
        [self addSubview:_tagLabel];
        self.tagString = newTag;        
        
    }
    return  self;
}

-(void)setTagString:(NSString *)tagString
{
    
    CGSize textSize = [tagString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    CGRect labelFrame = _tagLabel.frame;
    labelFrame.size = textSize;
    _tagLabel.frame = labelFrame;
    _tagLabel.text = tagString;
}

-(NSString*)tagString
{
    return _tagLabel.text;
}

-(void)layoutSubviews
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 45 + _tagLabel.frame.size.width , 24);
    _backroundImage.frame = self.bounds;
    _tagLabel.frame = CGRectMake(22.0f, 0.0f, _tagLabel.frame.size.width, _tagLabel.frame.size.height);
}


@end
