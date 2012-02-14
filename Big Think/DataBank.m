//
//  DataBank.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "DataBank.h"
#import "BTSpeaker.h"
#import "BTVideo.h"
#import "UIImage+RKImage.h"

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


+(BTSpeaker*)speakerWithName:(NSString*)name
{
    BTSpeaker *speaker = [[BTSpeaker alloc]init];
    if([name isEqualToString:@"Penn Jilette"])
    {
        speaker.name = name;
        speaker.description  = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam gravida, odio a hendrerit hendrerit, felis purus accumsan sapien, quis malesuada arcu purus a lectus. Etiam sagittis cursus lorem, eu hendrerit mauris aliquet in. Praesent facilisis laoreet orci, vitae imperdiet arcu ultricies non. In sit amet tellus sit amet nisi dapibus bibendum vel in metus.";
        speaker.image = [UIImage imageNamed:@"shot.jpg"]; 
    }
    return speaker;
}

+(BTVideo*)videoWithId:(NSInteger)idNum
{
    BTVideo* video = [[BTVideo alloc]init];
    
    if (idNum == 0) {
        video.speaker = [self speakerWithName:@"Penn Jilette"];
        video.title = @"Why Tolerance Is Condesending";
        video.image = [[UIImage imageNamed:@"shot.jpg"] imageWithTint:[UIColor blackColor]];
        video.length = 2.05;
        video.dateAdded = [NSDate date];
        video.url = [[NSBundle mainBundle] URLForResource:@"WhyToleranceIsCondescending" withExtension:@"mp4"];
    }
    return video;
}


@end
