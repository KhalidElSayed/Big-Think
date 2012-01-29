//
//  RKTagBankView.m
//  Big Think
//
//  Created by Richard Kirk on 1/29/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKTagBankView.h"
#import "RKTagButton.h"


@implementation RKTagBankView
@synthesize tags = _tags;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        _tags = [[NSMutableArray alloc]init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews;
{
    CGFloat xOffset = 0.;
    CGFloat yOffset = 0.;
    CGFloat tagHeight = 0.;
    
    for (RKTagButton* tag in _tags)
    {
        
        [tag setFrame:CGRectMake(xOffset, yOffset, tag.frame.size.width, tag.frame.size.height)];
        
        xOffset += tag.frame.size.width;
        
        if (tag != [_tags lastObject])
        {
            xOffset += 5.0f; // tag space
        }
        
        tagHeight = tag.frame.size.height;
    }
    _scrollView.contentSize = CGSizeMake(xOffset, 1);
    
}




-(NSArray*)tags
{
    return _tags;
}

-(void)setTags:(NSArray *)tags
{
    _tags = [tags mutableCopy];
}


-(void)addTagWithString:(NSString*)tagString
{
    RKTagButton *newTag = [[RKTagButton alloc]initWithTag:tagString];
    [self addRKTag:newTag];
}
-(void)addRKTag:(RKTagButton*)tagButton
{
    [_tags addObject:tagButton];
    [_scrollView addSubview:tagButton];
    [self setNeedsLayout];
}


-(void)removeTagWithString:(NSString*)tagString
{
    [_tags enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL* stop){
        if([tagString isEqualToString:[(RKTagButton*)obj tagString]])     
        {
            *stop = YES;
            [self removeRKTag:obj];
        }
    }
     ];
}


-(void)removeRKTag:(RKTagButton*)tagButton
{
    [tagButton removeFromSuperview];
    [_tags removeObject:tagButton];
    [self setNeedsLayout];
    
}





@end
