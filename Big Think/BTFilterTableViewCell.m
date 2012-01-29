//
//  BTFilterTableViewCell.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "BTFilterTableViewCell.h"

@implementation BTFilterTableViewCell
@synthesize myLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
        
  //  [self setNeedsLayout];
}


@end
