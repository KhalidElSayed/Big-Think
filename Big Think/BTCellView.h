//
//  BTCellView.h
//  Big Think
//
//  Created by Richard Kirk on 1/29/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXLabel;
@interface BTCellView : UIView
{
    FXLabel*    _label;
}


-(void)setSelected:(BOOL)selected;
-(void)setText:(NSString*)string;

@end
