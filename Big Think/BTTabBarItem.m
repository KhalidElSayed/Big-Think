//
//  BTTabBarItem.m
//  Big Think
//
//  Created by Richard Kirk on 1/24/12.
//  Copyright (c) 2012 Home. All rights reserved.
//
//#define kTabDemoVerticalItemPaddingSize CGSizeMake(18., 5.)
#define kTabDemoVerticalItemFont [UIFont boldSystemFontOfSize:11.]

#import "BTTabBarItem.h"

@implementation BTTabBarItem
@synthesize alternateIcon, itemWidth;


-(id)initWithTitle:(NSString *)title icon:(UIImage *)icon alternateIcon:(UIImage *)altIcon
{
    self = [super initWithTitle:title icon:icon];
    if(self)
    {
        self.alternateIcon = altIcon;
        self.fixedWidth = 200.0f;
    }
    return self;
}

- (CGSize) sizeThatFits:(CGSize)size;
{
    CGSize titleSize = [self.title sizeWithFont:kTabDemoVerticalItemFont];
    
    
    if(self.fixedWidth == 0){
        CGFloat titleWidth = titleSize.width;
        CGFloat iconWidth = [self.icon size].width;
        CGFloat width = (iconWidth > titleWidth) ? iconWidth : titleWidth;
        width += (18 * 6);
    }
    
    
    CGFloat height = 56.;
    return CGSizeMake(self.fixedWidth, height);
}

- (void)drawRect:(CGRect)rect;
{
    CGRect bounds = rect;
    CGFloat yOffset = 15;
    
    UIImage * iconImage = (self.highlighted || [self isSelectedTabItem]) ? self.alternateIcon : self.icon;
    
    // calculate icon position
    CGFloat iconWidth = [iconImage size].width;
    CGFloat iconMarginWidth = (bounds.size.width - iconWidth) / 2;
    
    [iconImage drawAtPoint:CGPointMake(iconMarginWidth, yOffset)];
    
    // calculate title position
    CGFloat titleWidth = [self.title sizeWithFont:kTabDemoVerticalItemFont].width;
    CGFloat titleMarginWidth = (bounds.size.width - titleWidth) / 2;
    
    UIColor * textColor = self.highlighted ? [UIColor lightGrayColor] : [UIColor whiteColor];
    [textColor set];
    [self.title drawAtPoint:CGPointMake(titleMarginWidth, yOffset + 22.) withFont:kTabDemoVerticalItemFont];
}



@end
