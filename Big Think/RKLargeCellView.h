//
//  RKLargeCellView.h
//  Big Think
//
//  Created by Richard Kirk on 1/16/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKLargeCellView : UIView
{
   // UIImageView*    _imgView;
   // UILabel*        _header;
   // UILabel*        _title;
    //UIView*         _additionalInfoView;
}
@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *additionalInformationPane;


@end
