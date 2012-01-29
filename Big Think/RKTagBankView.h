//
//  RKTagBankView.h
//  Big Think
//
//  Created by Richard Kirk on 1/29/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RKTagButton;

@interface RKTagBankView : UIView
{
    UIScrollView*       _scrollView;    // Backed By UI ScrollView
    NSMutableArray*     _tags;
    
}
@property (strong, nonatomic) NSArray* tags;

-(void)addTagWithString:(NSString*)tagString;
-(void)addRKTag:(RKTagButton*)tagButton;

-(void)removeTagWithString:(NSString*)tagString;
-(void)removeRKTag:(RKTagButton*)tagButton;

@end
