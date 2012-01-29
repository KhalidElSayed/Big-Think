//
//  DataBank.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "DataBank.h"



static DataBank *sharedMyManager = nil;

@implementation DataBank
@synthesize filterCategories = _filterCategories;

+(DataBank* )sharedManager {
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {

        _filterCategories = [[NSMutableDictionary alloc]init];
        [self setupFilterCategories];
        
    }
    return self;
}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


-(void)setupFilterCategories
{
    
    
    NSArray *speakers = [[NSArray alloc]initWithObjects:@"Penn Jillete", @"Rod Stewart", @"Zvi Bodie", @"Mark Cheney", @"Jaan Tallinn", @"George Steel", @"Lynda Weinman", @"Keli Carender", nil];

        [_filterCategories setObject:speakers forKey:@"speakers"];

    
    NSArray* topics = [[NSArray alloc]initWithObjects:@"Arts & Culture", @"Belief", @"Enviroment", @"Future", @"History", @"Identity", @"Life & death" @"Politics & policy", @"World", nil];
    [_filterCategories setObject:topics forKey:@"topics"];

    NSArray* popularity = [[NSArray alloc]initWithObjects:@"Very Popluar", @"Hot", @"Dead Middle", @"\"Working My Way Up\"", @"Not so Popular", nil];
    [_filterCategories setObject:popularity forKey:@"popularity"];
    
    NSArray* age = [[NSArray alloc]initWithObjects:@"< 10 days", @"< 50 days", @"< 160 days", @"< 400 days", nil];
    [_filterCategories setObject:age forKey:@"age"];
    
    
}



@end
