//
//  RKMatrixCell.m
//  Major grid
//
//  Created by Richard Kirk on 1/10/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMatrixViewCell.h"

@implementation RKMatrixViewCell
@synthesize contentView = _contentView;
@synthesize location;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
        UIViewAutoresizingFlexibleHeight        | 
        UIViewAutoresizingFlexibleBottomMargin  | 
        UIViewAutoresizingFlexibleLeftMargin    | 
        UIViewAutoresizingFlexibleRightMargin   | 
        UIViewAutoresizingFlexibleTopMargin; 
        
    }
    
    return self;
    
    
}

-(id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
        UIViewAutoresizingFlexibleHeight        | 
        UIViewAutoresizingFlexibleBottomMargin  | 
        UIViewAutoresizingFlexibleLeftMargin    | 
        UIViewAutoresizingFlexibleRightMargin   | 
        UIViewAutoresizingFlexibleTopMargin; 
        
    }
    return self;

}

-(void)setContentView:(UIView *)contentView
{
    if (self.contentView) 
    {
        [self.contentView removeFromSuperview];
    }
    
    
    self.frame = contentView.bounds;
    _contentView = contentView;        
    [self addSubview:_contentView];
}


-(void)setFrame:(CGRect)frame
{
    if(self.contentView)
        _contentView.frame = frame;
    
}



-(void)prepareForReuse
{
    _location.row = -1;
    _location.column = -1;
    [self removeFromSuperview];
    
}


@end
