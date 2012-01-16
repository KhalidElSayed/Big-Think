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



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight        ;
 
        
    }
    
    return self;
    
    
}

-(void)setContentView:(UIView *)contentView
{
    if (self.contentView) 
    {
        [self.contentView removeFromSuperview];
    }
    
    
    contentView.frame = self.bounds;
    _contentView = contentView;        
    [self addSubview:_contentView];
}



@end
