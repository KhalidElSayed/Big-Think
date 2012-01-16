//
//  RKGrid.h
//  Major grid
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKMatrixViewCell;

struct RK2DLocation{
    NSInteger row;
    NSInteger column;
};
typedef struct RK2DLocation RK2DLocation;

enum {
    RKGridViewLayoutLarge,
    RKGridViewLayoutMedium,
    RKGridViewLayoutSmall
};
typedef NSUInteger RKGridViewLayoutType;

@protocol RKMatrixViewDelegate;
@protocol RKMatrixViewDatasource;


@interface RKMatrixView : UIView <UIScrollViewDelegate>
{
    UIScrollView*           _scrollView;
    RK2DLocation            _currentLocation;
    id                      delegate;
    id                      datasource;
    RKGridViewLayoutType    _layout;
    NSMutableDictionary*    _cells;
    BOOL                    _landscape;
    UIView*                 _firstCell;
    NSMutableArray*         _testCells;
    
    
}

@property (nonatomic,assign) id<RKMatrixViewDelegate> delegate;                       // default nil. weak reference
@property (nonatomic,assign) id<RKMatrixViewDatasource> datasource;                       // default nil. weak reference
@property (nonatomic) RK2DLocation currentLocation;
@property (nonatomic) RKGridViewLayoutType layout;

-(void)demoo;
-(void)willRotate:(NSNotification *)notification;
@end



@protocol RKMatrixViewDatasource<NSObject>
-(UIView *) matrixView:(RKMatrixView *)matrixView viewForLocation:(RK2DLocation)location withFrame:(CGRect)frame;
@optional 
-(RKMatrixViewCell*) matrixView:(RKMatrixView *)matrixView cellForLocation:(RK2DLocation)location;

@end



@protocol RKMatrixViewDelegate<NSObject>
@optional


@end