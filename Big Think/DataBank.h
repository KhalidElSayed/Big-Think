//
//  DataBank.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTSpeaker.h"
#import "BTVideo.h"
@class BTSpeaker;
@class BTVideo;
@interface DataBank : NSObject
{
    NSMutableDictionary*    _filterCategories;
}
@property (strong, nonatomic) NSMutableDictionary *filterCategories;
-(void)setupFilterCategories;
+(DataBank*)sharedManager;

+(BTSpeaker*)speakerWithName:(NSString*)name;
+(BTVideo*)videoWithId:(NSInteger)idNum;

@end
