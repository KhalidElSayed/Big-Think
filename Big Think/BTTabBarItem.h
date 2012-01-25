//
//  BTTabBarItem.h
//  Big Think
//
//  Created by Richard Kirk on 1/24/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "JMTabItem.h"

@interface BTTabBarItem : JMTabItem


@property (nonatomic,retain) UIImage * alternateIcon;
@property (nonatomic)CGFloat itemWidth;

-(id)initWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)altIcon;


@end
