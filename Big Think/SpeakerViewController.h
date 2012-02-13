//
//  SpeakerViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/23/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView*        _tableView;
    UITableViewCell*    _speakerCell;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *speakerCell;




@end
