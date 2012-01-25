//
//  BTTabView.h
//  Big Think
//
//  Created by Richard Kirk on 1/24/12.
//  Copyright (c) 2012 Home. All rights reserved.
//  Subview of JMTabView with three views. 

#import "JMTabView.h"

@interface BTTabView : JMTabView
{
    UIView*         _leftView;
    UIView*         _middleView;
}
@property (strong, nonatomic) UIView* leftView;
@property (strong, nonatomic) UIView* middleView;

@end
