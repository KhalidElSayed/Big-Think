//
//  SpeakerTableViewCell.m
//  Big Think
//
//  Created by Richard Kirk on 2/15/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "SpeakerTableViewCell.h"
#import "BTSpeaker.h"
#import "BTVideo.h"
#import "UIUnderlinedButton.h"

@interface SpeakerTableViewCell () 
-(void)setupLinksView;
@end

@implementation SpeakerTableViewCell
@synthesize speaker = _speaker;
@synthesize videoLinksView = _videoLinksView;
@synthesize speakerPhotoImageView = _speakerPhotoImageView;
@synthesize nameLabel = _nameLabel;
@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}



-(void)setSpeaker:(BTSpeaker *)newSpeaker
{
   
    _speakerPhotoImageView.image = newSpeaker.photo;
    _nameLabel.text = newSpeaker.name;

    _speaker = newSpeaker;
    
}

-(void)layoutSubviews
{   
    [super layoutSubviews];
        [self setupLinksView];
}


-(void)setupLinksView
{
    UIFont* fontForLinks = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    CGSize availableSpace = _videoLinksView.frame.size;
    CGFloat fontHeight = [fontForLinks lineHeight];
    
    CGRect linkFrame = CGRectMake(0, 0, availableSpace.width / 2, fontHeight);    
    
    for (BTVideo* video in [_speaker videos]) // add sort ability 
    {
        UIUnderlinedButton *link = [UIUnderlinedButton underlinedButton];
        [link addTarget:self action:@selector(linkSelected:) forControlEvents:UIControlEventTouchUpInside];
        link.backgroundColor = [UIColor clearColor];
        [link setTitle:video.title forState:UIControlStateNormal];
        [link setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [link setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        link.titleLabel.font = fontForLinks;
        link.titleLabel.textAlignment = UITextAlignmentLeft;
        
        
        link.frame = linkFrame;
        linkFrame.origin.y += fontHeight + 5;
        
        if (linkFrame.origin.y >= availableSpace.height)
        {   
            
            if(linkFrame.origin.x > 0)
            {
             // add more button   
            }
            else
            {
                linkFrame.origin.y = 0;
                linkFrame.origin.x = linkFrame.size.width;
            }
            
            
        }
        [_videoLinksView addSubview:link];
        
    }
    
    
    
    
}


-(void)linkSelected:(UIButton *)link
{
    BTVideo* video = [[_speaker.videos objectsPassingTest:^BOOL(id obj, BOOL *stop){
       return [[(BTVideo*)obj title] isEqualToString:link.titleLabel.text];
    }] anyObject];
    
    [self.delegate speakerCell:self didSelectVideo:video];
}

-(void)prepareForReuse
{
    
    [super prepareForReuse];
}






@end
