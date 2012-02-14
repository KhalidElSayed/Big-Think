//
//  Video.h
//  Big Think
//
//  Created by Richard Kirk on 2/13/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTSpeaker.h"
@interface BTVideo : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) BTSpeaker* speaker;
@property (nonatomic) NSUInteger length;
@property (strong, nonatomic) NSDate* dateAdded;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSURL* url;
@end
