//
//  RKGrid.h
//  
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

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
    UIScrollView*           _scrollView;
    RK2DLocation            _currentPage;
    id                      delegate;
    id                      datasource;
    NSMutableSet*           _resusableCells;
    NSMutableDictionary*    _visableCells;
    int                     _numberOfCells;
    RKGridViewLayoutType    _layout;
    NSMutableDictionary*    _cells;
    BOOL                    _landscape;
    UIView*                 _firstCell;

    
    
    
}
@property (nonatomic,assign) id<RKMatrixViewDelegate> delegate;                       // default nil. weak reference
@property (nonatomic,assign) id<RKMatrixViewDatasource> datasource;                       // default nil. weak reference
@property (nonatomic) RK2DLocation currentPage;
@property (nonatomic) RKGridViewLayoutType layout;
@property (nonatomic) int numberOfCells;
@property (nonatomic) NSUInteger maxColumns;
@property (nonatomic) NSUInteger maxRows;

-(void)demoo;

-(RKMatrixViewCell *)dequeResuableCell;
-(void)unloadUneccesaryCells:(int)level;
-(void)scrollToPageAtRow:(NSUInteger)row Column:(NSUInteger)column Animated:(BOOL)animate;

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