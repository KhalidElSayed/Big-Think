//
//  SpeakersTableViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailTableDelegate;
@interface DetailTableViewController : UITableViewController
{
    id                      delegate;

    NSArray*    _values;
}
@property(strong, nonatomic)NSArray* values;
@property (nonatomic,assign) id<DetailTableDelegate> delegate;     // default nil. weak reference
@end


@protocol DetailTableDelegate <NSObject>

-(void)didSelectObject:(id)obj;
-(void)didDeselectObject:(id)obj;

@end