//
//  BTFilterTableViewCell.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"
@class BTCellView;
@interface CustomCell : UITableViewCell
{
    BTCellView*     _cellView;
}

-(void)setLabelText:(NSString *)string;

@end
