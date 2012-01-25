//  Created by Jason Morrissey

#import "CustomSelectionView.h"



#define kTriangleHeight 8.

@implementation CustomSelectionView

- (void)drawRect:(CGRect)rect
{
   // [[UIColor rgbColorWithRed:205.0f green:199.0f blue:44.0f alpha:1.0f] set]; // BigThinkOrange
    [[UIColor rgbColorWithRed:37.0f green:37.0f blue:37.0f alpha:1.0f] set]; // dark
    CGRect squareRect = CGRectOffset(rect, 0, kTriangleHeight);
    squareRect.size.height -= kTriangleHeight;
    UIBezierPath * squarePath = [UIBezierPath bezierPathWithRoundedRect:squareRect cornerRadius:4.];
    [squarePath fill];
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(rect.size.width / 2 - kTriangleHeight, kTriangleHeight)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2, 0.)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width / 2 + kTriangleHeight, kTriangleHeight)];
    [trianglePath closePath];
    [trianglePath fill];
}

+ (CustomSelectionView *) createSelectionView;
{
    CustomSelectionView * selectionView = [[CustomSelectionView alloc] initWithFrame:CGRectZero];
    return selectionView;
}

@end
