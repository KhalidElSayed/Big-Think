//
//  UIImage+RKImage.m
//  Big Think
//
//  Created by Richard Kirk on 1/25/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "UIImage+RKImage.h"

@implementation UIImage (RKImage)

// Thanks Brad Larson!
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
