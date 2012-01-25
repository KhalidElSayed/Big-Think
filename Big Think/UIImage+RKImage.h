//
//  UIImage+RKImage.h
//  Big Think
//
//  Created by Richard Kirk on 1/25/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RKImage)

+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
@end
