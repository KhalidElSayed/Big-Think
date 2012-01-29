//
//  BTCellView.m
//  Big Think
//
//  Created by Richard Kirk on 1/29/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BTCellView.h"
#import "FXLabel.h"
#import "UIView+JMNoise.h"

@implementation BTCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        
        _label = [[FXLabel alloc]initWithFrame:CGRectInset(frame, 5, 2)];
                _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:44.0f];
        [_label setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:_label];
        [self applyNoiseWithOpacity:0.3f];
        [self setSelected:NO];
    }
    return self;
}

-(void)setText:(NSString*)string
{
    _label.text = string;
}


-(void)setSelected:(BOOL)selected;
{
        if (selected)
    {
        self.backgroundColor = [UIColor rgbColorWithRed:216 green:79 blue:32 alpha:1.0f];
        
        _label.shadowColor = nil;
        _label.shadowOffset = CGSizeMake(0.0f, 2.0f);
        _label.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        _label.shadowBlur = 5.0f;
        
    }
    else
    {
        self.backgroundColor = [UIColor darkGrayColor];
        _label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        _label.shadowOffset = CGSizeMake(1.0f, 2.0f);
        _label.shadowBlur = 1.0f;
        _label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        _label.innerShadowOffset = CGSizeMake(1.0f, 2.0f);

    }
    
    [self setNeedsLayout];
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
