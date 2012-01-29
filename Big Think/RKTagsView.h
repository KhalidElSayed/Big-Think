//
//  RKTagsView.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKTagsView : UIView
{
    NSMutableArray*     _tags;
}
@property (strong, nonatomic) NSArray *tags;
@end
