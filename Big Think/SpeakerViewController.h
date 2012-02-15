//
//  SpeakerViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/23/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakerTableViewCell.h"
@class BTSpeaker;
@interface SpeakerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SpeakerTableViewCellDelegate>
{
    UITableView*        _tableView;
    UITableViewCell*    _speakerCell;
    BTSpeaker*          _speaker;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;





@end
