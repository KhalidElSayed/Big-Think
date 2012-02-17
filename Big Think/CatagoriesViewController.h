//
//  CatagoriesViewController.h
//  Big Think
//
//  Created by Richard Kirk on 1/30/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface CatagoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AQGridViewDelegate, AQGridViewDataSource>
{
    UITableView*        _tableView;
    AQGridView*         _gridView;
    NSArray*            _topics;
    UINavigationBar*    _navBar;
    BOOL                _tableShowing;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AQGridView *gridView;
@property (strong, nonatomic) IBOutlet UITableViewCell *topicsTableViewCell;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSArray* topics;

- (IBAction)toggleTableButtonSelected:(UIBarButtonItem*)sender;
@end
