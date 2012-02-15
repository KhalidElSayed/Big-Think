//
//  Speaker.h
//  Big Think
//
//  Created by Richard Kirk on 2/13/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTSpeaker : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) UIImage* photo;
@property (strong, nonatomic) NSSet* videos;

@end
