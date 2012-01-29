//
//  RKTagsView.m
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKTagsView.h"

@implementation RKTagsView
@synthesize tags = _tags;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"TabBarHeader.png"]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 CGContextRef context = UIGraphicsGetCurrentContext();
 UIColor * shadowColor = [UIColor blackColor];
 CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 1.0f, [shadowColor CGColor]);
 CGContextSaveGState(context);   
 
 if (self.highlighted)
 {
 CGRect bounds = CGRectInset(rect, 2., 2.);
 CGFloat radius = 0.5f * CGRectGetHeight(bounds);
 UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius];
 [[UIColor colorWithWhite:1. alpha:0.3] set];
 path.lineWidth = 2.;
 [path stroke];
 }
 
 CGFloat xOffset = kTabItemPadding.width;
 
 if (self.icon)
 {
 [self.icon drawAtPoint:CGPointMake(xOffset, kTabItemPadding.height)];
 xOffset += [self.icon size].width + kTabItemIconMargin;
 }
 
 [kTabItemTextColor set];
 
 CGFloat heightTitle = [self.title sizeWithFont:kTabItemFont].height;
 CGFloat titleYOffset = (self.bounds.size.height - heightTitle) / 2;
 [self.title drawAtPoint:CGPointMake(xOffset, titleYOffset) withFont:kTabItemFont];
 
 CGContextRestoreGState(context);
}
*/

-(void)setTags:(NSArray *)tags
{
    _tags = [[NSMutableArray alloc]initWithArray:tags];
    [self setNeedsLayout];
}

-(void)addTag:(NSString*)tagText
{
    
    
    
}

-(void)layoutSubviews
{
    
    if ([_tags count] != 0) 
    {
    
        
        
    }
    
}

@end
