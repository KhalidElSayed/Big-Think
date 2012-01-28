//
//  FilterTableViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController
{
    NSArray*    _tableValues;
}
@property (strong, nonatomic) NSArray *tableValues;
@end
