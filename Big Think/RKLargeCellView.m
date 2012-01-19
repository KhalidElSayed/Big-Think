//
//  RKLargeCellView.m
//  Big Think
//
//  Created by Richard Kirk on 1/16/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKLargeCellView.h"

@implementation RKLargeCellView
@synthesize header;
@synthesize title;
@synthesize additionalInformationPane;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RKLargeCellView" owner:self options:nil] lastObject];
    
        if (self) 
        {
            self.frame = frame;
            
            self.title.font = [UIFont fontWithName:@"ChaparralPro-Regular" size:50.0f];
            
            if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice]orientation]))
            {
                [additionalInformationPane removeFromSuperview];
            }
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotate:) name:UIApplicationWillChangeStatusBarOrientationNotification  object:nil];
            
        }


    
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"RKLargeCellViewiPhone" owner:self options:nil] lastObject];
        if (self) 
        {
            self.frame = frame;
            self.title.font = [UIFont fontWithName:@"ChaparralPro-Regular" size:50.0f];
        }
        

    }
    else
        NSLog(@"No View associated with this device");
    
        return self;    
       
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification  object:nil];
}











-(void)willRotate:(NSNotification *)notification
{
    
    NSNumber *num = [notification.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"];
    
    switch ([num intValue]) 
    {
        case 1:
        case 2:
       //     NSLog(@"Orientation Changed to Portrait");
            [self addSubview:additionalInformationPane];
            break;
        case 3:
        case 4:
         //   NSLog(@"Orientation Changed to Landscape");
            [additionalInformationPane removeFromSuperview];
            
            break;
        default:
            break;
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
