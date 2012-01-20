//
//  RKMatrixCell.m
//  Major grid
//
//  Created by Richard Kirk on 1/10/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMatrixViewCell.h"

@interface RKMatrixViewCell()
{
    
}
-(void)myInit;

@end

@implementation RKMatrixViewCell
@synthesize contentView = _contentView;
@synthesize location;
@synthesize currentLayout;


-(void)myInit
{

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
    UIViewAutoresizingFlexibleHeight        |   
    UIViewAutoresizingFlexibleBottomMargin  | 
    UIViewAutoresizingFlexibleLeftMargin    | 
    UIViewAutoresizingFlexibleRightMargin   | 
    UIViewAutoresizingFlexibleTopMargin; 


    
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self myInit];
           }
    return self;
}

-(id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        [self myInit];        
    }
    return self;

}

-(void)setContentView:(UIView *)contentView
{
    if (self.contentView) 
    {
        [self.contentView removeFromSuperview];
    }
    
    CGRect frame = self.frame;
    frame.size = contentView.bounds.size;
    [super setFrame:frame];
    
    _contentView = contentView;        
    [self addSubview:_contentView];
}


-(void)setFrame:(CGRect)aFrame
{
    
    [super setFrame:aFrame];
    if(self.contentView)
        _contentView.frame = self.bounds;

}



-(void)prepareForReuse
{
    _location.row = -1;
    _location.column = -1;
    [self removeFromSuperview];
    
}


@end
