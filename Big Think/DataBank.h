//
//  DataBank.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBank : NSObject
{
    NSMutableDictionary*    _filterCategories;
}
@property (strong, nonatomic) NSMutableDictionary *filterCategories;
-(void)setupFilterCategories;
+(DataBank*)sharedManager;


@end
