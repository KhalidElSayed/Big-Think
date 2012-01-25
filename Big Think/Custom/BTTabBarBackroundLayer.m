
#import "BTTabBarBackroundLayer.h"


@implementation BTTabBarBackroundLayer

-(id)init
{
    self = [super init];
    if (self)
    {
        CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init];
        UIColor * startColor = [UIColor rgbColorWithRed:65.0f green:75.0f blue:65.0f alpha:1.0f];
        UIColor * midColor = [UIColor rgbColorWithRed:40.0f green:41.0f blue:40.0f alpha:1.0f];
        UIColor * endColor = [UIColor rgbColorWithRed:65.0f green:75.0f blue:65.0f alpha:1.0f];
        gradientLayer.frame = CGRectMake(0, 8., 1024, 60);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[midColor CGColor], (id)[endColor CGColor], nil];
        [self insertSublayer:gradientLayer atIndex:0];
        
    }
    return self;
}

@end
