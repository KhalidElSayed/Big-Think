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
    [self setClipsToBounds:YES];
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
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
   
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
    [_contentView removeFromSuperview];
    self.contentView = nil;
    [self removeFromSuperview];
    
}

-(NSString*)description
{
    return [[super description] stringByAppendingFormat:@"{%i,%i}",location.row, location.column];
}

@end
