//
//  TopicsGridViewCell.m
//  Big Think
//
//  Created by Richard Kirk on 2/16/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "TopicsGridViewCell.h"

@implementation TopicsGridViewCell
@synthesize dummyView, debugLabel;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
   if ((self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]))
   {
       self.dummyView = [[UIView alloc]initWithFrame:frame];
       [self.dummyView setBackgroundColor:[UIColor randomColor]];
       [self.contentView addSubview:dummyView];
       
       self.debugLabel = [[UILabel alloc]initWithFrame:frame];

       self.debugLabel.textAlignment = UITextAlignmentCenter;
       self.debugLabel.backgroundColor = [UIColor clearColor];
       [self.dummyView addSubview:self.debugLabel];
       
   }
    return self;
}



@end
