//  Created by Jason Morrissey
#import "BarBackgroundLayer.h"
@implementation BarBackgroundLayer

-(id)init;
{
    self = [super init];
    if (self)
    {
        CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
        UIColor * startColor = [UIColor rgbColorWithRed:40.0f green:41.0f blue:40.0f alpha:1.0f];
        UIColor * endColor = [UIColor rgbColorWithRed:75.0f green:74.0f blue:75.0f alpha:1.0f];
        gradientLayer.frame = CGRectMake(0, 0, 1024, 60);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
        [self insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

@end
