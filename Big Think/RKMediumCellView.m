//
//  RKMediumCellView.m
//  Big Think
//
//  Created by Richard Kirk on 1/16/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMediumCellView.h"

@implementation RKMediumCellView
@synthesize header;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       self = [[[NSBundle mainBundle] loadNibNamed:@"RKMediumCellView" owner:self options:nil] objectAtIndex:0];
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




@end
