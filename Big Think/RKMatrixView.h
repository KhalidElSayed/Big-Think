//
//  RKGrid.h
//  
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.

#import <UIKit/UIKit.h>

@class RKMatrixViewCell;

struct RK2DLocation{
    NSUInteger row;
    NSUInteger column;
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
    id                      delegate;
    id                      datasource;
    UIScrollView*           _scrollView;
    RK2DLocation            _currentPage;
    NSMutableSet*           _resusableCells;
    NSUInteger              _numberOfCells;
    RKGridViewLayoutType    _layout;    
}
@property (nonatomic,assign) id<RKMatrixViewDelegate> delegate;                       // default nil. weak reference
@property (nonatomic,assign) id<RKMatrixViewDatasource> datasource;                       // default nil. weak reference
@property (nonatomic) RK2DLocation currentPage;
@property (nonatomic) RKGridViewLayoutType layout;
@property (nonatomic) NSUInteger numberOfCells;
@property (nonatomic) NSUInteger maxColumns;
@property (nonatomic) NSUInteger maxRows;

-(RKMatrixViewCell *)dequeResuableCell;
-(void)unloadUneccesaryCells:(int)level;
-(void)scrollToPageAtRow:(NSUInteger)row Column:(NSUInteger)column Animated:(BOOL)animate;

-(void)demoo;
@end

@protocol RKMatrixViewDatasource<NSObject>
-(RKMatrixViewCell*) matrixView:(RKMatrixView *)matrixView cellForLocation:(RK2DLocation)location;
-(int)numberOfCellsInMatrix:(RKMatrixView *)matrix;
@optional 
-(UIView *) matrixView:(RKMatrixView *)matrixView viewForLocation:(RK2DLocation)location withFrame:(CGRect)frame;
-(NSUInteger)maximumRowsInMatrixView:(RKMatrixView *)matrix;
-(NSUInteger)maximumColumnsInMatrixView:(RKMatrixView *)matrix;
@end

@protocol RKMatrixViewDelegate<NSObject>
@optional
@end