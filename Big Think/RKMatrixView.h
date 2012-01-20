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
    NSMutableSet*           _resusableCells;
    NSMutableDictionary*           _visableCells;
    
    
    int                     _numberOfCells;
    RKGridViewLayoutType    _layout;
    NSMutableDictionary*    _cells;
    BOOL                    _landscape;
    UIView*                 _firstCell;

    NSMutableDictionary*         _testPages;
    
    
    
}

@property (nonatomic,assign) id<RKMatrixViewDelegate> delegate;                       // default nil. weak reference
@property (nonatomic,assign) id<RKMatrixViewDatasource> datasource;                       // default nil. weak reference
@property (nonatomic) RK2DLocation currentLocation;
@property (nonatomic) RKGridViewLayoutType layout;
@property (nonatomic) int numberOfCells;

-(void)demoo;
-(void)willRotate:(NSNotification *)notification;
-(RKMatrixViewCell *)dequeResuableCell;
@end



@protocol RKMatrixViewDatasource<NSObject>
-(RKMatrixViewCell*) matrixView:(RKMatrixView *)matrixView cellForLocation:(RK2DLocation)location;
-(int)numberOfCellsInMatrix:(RKMatrixView *)matrix;

@optional 
-(UIView *) matrixView:(RKMatrixView *)matrixView viewForLocation:(RK2DLocation)location withFrame:(CGRect)frame;
@end



@protocol RKMatrixViewDelegate<NSObject>
@optional
@end