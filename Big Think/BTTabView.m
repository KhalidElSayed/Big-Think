//
//  BTTabView.m
//  Big Think
//
//  Created by Richard Kirk on 1/24/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BTTabView.h"
#import "UIView+Positioning.h"
#define ITEM_INSET_PADDING 5.0f

@interface BTTabView ()
-(CGRect)frameForViewAtIndex:(NSUInteger)index;
@end

@implementation BTTabView
@synthesize leftView = _leftView, middleView = _middleView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
    }
    return self;
}


-(CGRect)frameForViewAtIndex:(NSUInteger)index
{
    CGRect frame;
    if(index == 0)
    {
        frame = _leftView.frame;
        frame.origin.x = 0 + ITEM_INSET_PADDING;
        frame.origin.y = floorf((self.bounds.size.height - frame.size.height) / 2);
    }
    if(index == 1)
    {
        frame = self.middleView.frame;
        
    }
    
    
    if (index == 2)
    {   
        frame = self.tabContainer.frame;
        frame.origin.x = (self.bounds.size.width - frame.size.width) - ITEM_INSET_PADDING; 
        frame.origin.y = floorf((self.bounds.size.height - frame.size.height) / 2);
        
    }
    return frame;
}

-(void)setLeftView:(UIView *)leftView
{
    if(_leftView)
    {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    _leftView = leftView;
    leftView.frame = [self frameForViewAtIndex:0];
    [self addSubview:leftView];

    [self setNeedsLayout];
}


-(void)setMiddleView:(UIView *)middleView
{
    if(_middleView)
    {
        [_middleView removeFromSuperview];
        _middleView = nil;
    }
    _middleView = middleView;
    middleView.frame = [self frameForViewAtIndex:1];
    [self addSubview:middleView];
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    
    if (_leftView) 
        _leftView.frame = [self frameForViewAtIndex:0];
    if (_middleView)
        [_middleView centerInRect:self.bounds];
    
    self.tabContainer.frame = [self frameForViewAtIndex:2];
}



@end
