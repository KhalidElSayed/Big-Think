//
//  SpeakerTableViewCell.h
//  Big Think
//
//  Created by Richard Kirk on 2/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTSpeaker;
@class BTVideo;

@protocol SpeakerTableViewCellDelegate;

@interface SpeakerTableViewCell : UITableViewCell
{
    
    id              delegate;
    BTSpeaker*      _speaker;
}
@property (nonatomic,assign) id<SpeakerTableViewCellDelegate>delegate;     // default nil. weak reference
@property (strong,nonatomic) BTSpeaker* speaker;
@property (strong, nonatomic) IBOutlet UIView *videoLinksView;
@property (strong, nonatomic) IBOutlet UIImageView *speakerPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

-(void)linkSelected:(UIButton *)link;

@end



@protocol SpeakerTableViewCellDelegate<NSObject>
@optional
-(void)speakerCell:(SpeakerTableViewCell*)speakerCell didSelectVideo:(BTVideo *)video;
@end


