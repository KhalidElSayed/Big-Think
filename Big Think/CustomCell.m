//
//  BTFilterTableViewCell.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CustomCell.h"
#import "BTCellView.h"

@implementation CustomCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 70 );
        _cellView = [[BTCellView alloc ]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:_cellView];        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
 
    }
    return self;
}
/*
-(UIView*)backgroundView
{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = [UIColor rgbColorWithRed:216 green:79 blue:32 alpha:1.0f];
    [view applyNoise];
    return view;
}
-(void)layoutSubviews
{
    self.myLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackround.png"]];
    myLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    myLabel.shadowBlur = 5.0f;
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [_cellView setSelected:selected];
}


-(void)setLabelText:(NSString *)string
{
    [_cellView setText:string];
}


@end
