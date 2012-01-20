//
//  RKMatrixCell.h
//  Major grid
//
//  Created by Richard Kirk on 1/10/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKMatrixView.h"

@interface RKMatrixViewCell : UIView 
{

    UIView*         _contentView;
    RK2DLocation    _location;
    
    
}
@property (strong, nonatomic)UIView* contentView;
@property (nonatomic)RK2DLocation location;
@property (nonatomic)RKGridViewLayoutType currentLayout;

-(void)prepareForReuse;
-(id)init;

@end
