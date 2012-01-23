//
//  RKGrid.m
//  Major grid
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMatrixView.h"
#import "RKMatrixViewCell.h"

#define DEBUG_LAYOUT_SUBVIEWS NO
#define DEBUG_CELL_LOAD NO
#define DEBUG_DRAGGING NO  
#define DEBUG_DRAGGING_DIRECTION NO
#define DEBUG_CELL_FRAME NO
#define DEBUG_PAGE_LOAD NO

static inline RK2DLocation RK2DLocationMake(NSUInteger row, NSUInteger column)
{
    RK2DLocation location;
    location.row = row;
    location.column = column;
    return location;
}

static inline NSString* NSStringFromRK2DLocation(RK2DLocation location)
{
    return [NSString stringWithFormat:@"{%i,%i}",location.row, location.column];
}

static inline RK2DLocation RK2DLocationFromString(NSString *string)
{
    RK2DLocation location;
    location.row = [[string substringWithRange:NSMakeRange(1, 1)] integerValue];
    location.column = [[string substringWithRange:NSMakeRange(3, 1)] integerValue];   
    return location;
}

static inline bool RK2DLocationEqualToLocation(RK2DLocation loc1, RK2DLocation loc2)
{
    return loc1.row == loc2.row && loc1.column == loc2.column;
}


@interface RKMatrixView () 
{
    CGFloat         _cellMarginWidth;
    CGFloat         _cellMarginHeight;
    CGFloat         _pagePadding;
    CGPoint         _contentOffsetMarker;   // Used to determine the direction a user wants to scroll
    UIView*         _zoomingView;
    RK2DLocation    _visablePageBeforeRotation;
}
-(void)setup;
-(void)reloadData;

-(void)loadPageForLocation:(RK2DLocation)page;
-(void)unloadPageForLocation:(RK2DLocation)page;
-(RKMatrixViewCell *)cellForLocation:(RK2DLocation)location;
-(NSArray *)cellLocationsForPageAtLocation:(RK2DLocation)page withLayout:(RKGridViewLayoutType)layout;
-(CGRect)cellFrameForLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout;
-(RKMatrixViewCell *)loadCellForLocation:(RK2DLocation)location;
-(void)willRotate:(NSNotification *)notification;
-(NSSet*)cellsForPage:(RK2DLocation)page;
-(RK2DLocation)pageForCellLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout;
@end


@implementation RKMatrixView
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize currentPage = _currentPage;
@synthesize numberOfCells = _numberOfCells;
@synthesize layout = _layout;
@synthesize maxRows, maxColumns;

-(void)setup
{
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    if (idiom == UIUserInterfaceIdiomPad) 
    {
        _cellMarginWidth = 50.0f;
        _cellMarginHeight = 50.0f;
        _pagePadding = 50.0f;
    }
    else 
    {
        _cellMarginWidth = 15.0f;
        _cellMarginHeight = 15.0f;
        _pagePadding = 10.0f;        
    }
    
    CGRect frame = self.bounds;
    frame.origin.x -= _pagePadding;
    frame.origin.y -= _pagePadding;
    frame.size.width += (2 * _pagePadding);
    frame.size.height += (2 * _pagePadding);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"portraitBackround.png"]];
    _scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_scrollView];
    
    //_zoomingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //_zoomingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[_scrollView addSubview:_zoomingView];
    
    _layout = RKGridViewLayoutLarge;
    _resusableCells = [[NSMutableSet alloc]init];
                

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification  object:nil];
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification  object:nil];
    _resusableCells = nil;
    _scrollView = nil;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = _scrollView.bounds;
    _scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
    [self scrollToPageAtRow:_visablePageBeforeRotation.row Column:_visablePageBeforeRotation.column Animated:YES];
    
    if(DEBUG_LAYOUT_SUBVIEWS)
    {
            NSLog(@"Layout SubViews Called");
        UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
        if(UIDeviceOrientationIsLandscape(orientation))
        {

            CGRect correctSelfFrame = CGRectMake(0, 44, 1024, 704);
            if(!CGRectEqualToRect(correctSelfFrame, self.frame))
                NSLog(@"!ERROR!self.frame : %@", NSStringFromCGRect(self.frame));
            CGRect correctSelfBounds = CGRectMake(0, 0, 1024, 704);
            if(!CGRectEqualToRect(self.bounds, correctSelfBounds))
                NSLog(@"!ERROR!self.bounds : %@ \n",NSStringFromCGRect(self.bounds));  
            CGRect correctScrollViewBounds = CGRectMake(0, 0, 1024, 704);
            if(!CGRectEqualToRect(correctScrollViewBounds, _scrollView.bounds)){}
            //NSLog(@"!ERROR!_scrollView.bounds : %@", NSStringFromCGRect(_scrollView.bounds));
            CGRect correctScrollViewFrame = CGRectMake(-50, -50, 1124, 804);
            if(!CGRectEqualToRect(correctScrollViewFrame, _scrollView.frame))
                NSLog(@"!ERROR!scrollView.frame : %@", NSStringFromCGRect(_scrollView.frame));    
            
        }
        else if(UIDeviceOrientationIsPortrait(orientation))
        {
            CGRect correctSelfFrame = CGRectMake(0, 44, 768, 960);
            if(!CGRectEqualToRect(correctSelfFrame, self.frame))
                NSLog(@"!ERROR!self.frame : %@", NSStringFromCGRect(self.frame));
            CGRect correctSelfBounds = CGRectMake(0, 0, 768, 960);
            if(!CGRectEqualToRect(self.bounds, correctSelfBounds))
                NSLog(@"!ERROR!self.bounds : %@ \n",NSStringFromCGRect(self.bounds));  
            CGRect correctScrollViewFrame = CGRectMake(-50, -50, 868, 1060);
            if(!CGRectEqualToRect(correctScrollViewFrame, _scrollView.frame))
                NSLog(@"!ERROR!scrollView.frame : %@", NSStringFromCGRect(_scrollView.frame));    
            CGRect correctScrollViewBounds = CGRectMake(0, 0, 768, 960);
            if(!CGRectEqualToRect(correctScrollViewBounds, _scrollView.bounds)){}
            //NSLog(@"!ERROR!_scrollView.bounds : %@", NSStringFromCGRect(_scrollView.bounds));
        }
    }
}


#pragma mark - UIScrollViewDelegate Functions

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(DEBUG_DRAGGING)
        NSLog(@"_scrollView.contentOffset : %f, %f\n\n ", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
    _contentOffsetMarker = _scrollView.contentOffset;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    // Disable Diagonal Scrolling
    int pageWidth = _scrollView.bounds.size.width;
    int pageHeight = _scrollView.bounds.size.height;
    int subPage =round(_scrollView.contentOffset.y / pageHeight);
    if ((int)_scrollView.contentOffset.x % pageWidth != 0 && (int)_scrollView.contentOffset.y % pageHeight != 0) 
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, subPage * pageHeight)];
    } 

    if(DEBUG_DRAGGING)
    {
        RK2DLocation location = [self currentPage];
        NSLog(@"CurrentLocation row :%i, column :%i", location.row, location.column);
        NSLog(@"_scrollView.contentOffset : %f, %f\n\n ", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
        NSLog(@"_scrollView.bounds : %@", NSStringFromCGRect(_scrollView.bounds) );
    }
    
    NSString *direction;
    RK2DLocation locationUserIsMovingTo = self.currentPage;
    
    if (_contentOffsetMarker.x == _scrollView.contentOffset.x)   // scrolling Vertically
    {
        if(_contentOffsetMarker.y < _scrollView.contentOffset.y)    // pushing up
        {
            locationUserIsMovingTo.row += 1;
            direction = @"pushing up";
        }
        else if (_contentOffsetMarker.y > _scrollView.contentOffset.y) // pulling down
        {
            locationUserIsMovingTo.row -= 1;
            direction = @"pulling down";
        }
    }
    else if(_contentOffsetMarker.y == _scrollView.contentOffset.y) // scrolling Horizontally
    {
        if(_contentOffsetMarker.x < _scrollView.contentOffset.x)    //swiping left
        {
            locationUserIsMovingTo.column += 1;
            direction = @"swiping left";
        }
        else if(_contentOffsetMarker.x > _scrollView.contentOffset.x)   // swiping right
        {
            locationUserIsMovingTo.column -= 1;
            direction = @"swiping right";
        }
    }
    

    if(DEBUG_DRAGGING_DIRECTION)
        NSLog(@"%@",direction);
    
    [self loadPageForLocation:locationUserIsMovingTo];

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self unloadUneccesaryCells:1];
}


#pragma mark - Memory Management 

-(void)unloadUneccesaryCells:(int)level
{
    void(^cleanupBlock)(int level) = ^(int level){    
        
        NSMutableSet *cellsToKeep = [[NSMutableSet alloc]init];
        RK2DLocation currentLocation = [self currentPage];
        
        [cellsToKeep unionSet:[self cellsForPage:currentLocation]];
        // Determine which cells are within the level depth
        for (int i = level; i > 0; i--) 
        {
            if((int)currentLocation.column - level >=0) // Since Dealing with NSUInteger check if past 0
            {
                RK2DLocation left = RK2DLocationMake(currentLocation.row, currentLocation.column - level);
                [cellsToKeep unionSet:[self cellsForPage:left]];
            }
            if((int)currentLocation.row - level >=0)
            {
                RK2DLocation top = RK2DLocationMake(currentLocation.row - level, currentLocation.column);
                [cellsToKeep unionSet:[self cellsForPage:top]];
            }
            if((int)currentLocation.column + level <= self.maxColumns)  // Check if trying to save cells outside of matrix bounds
            {
                RK2DLocation bottom = RK2DLocationMake(currentLocation.row + level, currentLocation.column);
                [cellsToKeep unionSet:[self cellsForPage:bottom]];
            }
            if((int)currentLocation.column + level <= self.maxRows)
            {
                RK2DLocation right = RK2DLocationMake(currentLocation.row , currentLocation.column + level );
                [cellsToKeep unionSet:[self cellsForPage:right]];
            }
        }
        //  Get a set of all the cells which are currently a subview of _scrollView
        NSMutableSet* visableCells = [[NSMutableSet alloc]init ];
        for (UIView* view in [_scrollView subviews] ) 
        {
            if([view class] == [RKMatrixViewCell class])
                [visableCells addObject:(RKMatrixViewCell *)view];
        }
        // Subtract the cells we want to keep and unload the remaining cells
        [visableCells minusSet:cellsToKeep];
        for (RKMatrixViewCell *cellToUnload in visableCells)
        {
            if(DEBUG_CELL_LOAD)
                NSLog(@"UnLoaded Cell at Location : %@", NSStringFromRK2DLocation(cellToUnload.location));
            [cellToUnload prepareForReuse];
            [_resusableCells addObject:cellToUnload];
        }
    };
    cleanupBlock(level);    
}


-(NSSet*)cellsForPage:(RK2DLocation)page
{
    NSMutableSet *setOfCells = [[NSMutableSet alloc]initWithCapacity:6];
    for (NSString *locationString in [self cellLocationsForPageAtLocation:page withLayout:_layout])
    {
        RKMatrixViewCell* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
            [setOfCells addObject:cell];
        }
    }
    return ([setOfCells count] == 0) ? nil : [setOfCells copy];
}


-(RKMatrixViewCell *)dequeResuableCell
{
    RKMatrixViewCell *cell = [_resusableCells anyObject];
    if(cell)
    {
        [_resusableCells removeObject:cell]; 
        
    }
    return cell;
}


#pragma mark - Setters/Getters

-(RK2DLocation)currentPage
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    _currentPage.column = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    CGFloat pageHeight = _scrollView.bounds.size.height;
    _currentPage.row = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    return _currentPage;
}

-(void)setDatasource:(id<RKMatrixViewDatasource>)aDatasource
{
    _datasource = aDatasource;
    [self reloadData];
}

-(void)setNumberOfCells:(NSUInteger)newNumberOfCells
{
    _numberOfCells = newNumberOfCells;
    CGRect bounds = _scrollView.bounds;
    _scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
}

-(NSUInteger)maxRows
{
    if([self.datasource respondsToSelector:@selector(maximumRowsInMatrixView:)])       
       return [_datasource maximumRowsInMatrixView:self]; 
    else
        return NSUIntegerMax;
}


-(NSUInteger)maxColumns
{
    if([self.datasource respondsToSelector:@selector(maximumColumnsInMatrixView:)])       
        return [_datasource maximumColumnsInMatrixView:self]; 
    else
        return NSUIntegerMax;
}


-(void)reloadData
{
    if([_datasource respondsToSelector:@selector(numberOfCellsInMatrix:)])
        self.numberOfCells = [_datasource numberOfCellsInMatrix:self];
    else
        NSLog(@"Delegate Does not respond to numberOfCellsInMatrix:");
}


-(void)setLayout:(RKGridViewLayoutType)layout
{
    if (_layout == layout)  // Don't waste time if the layout isn't being changed
        return;
       
    if(_layout == RKGridViewLayoutMedium)
    {
        if(layout == RKGridViewLayoutLarge)
        {
            // Get top left most cell, expand,
            
        }
        else if(layout == RKGridViewLayoutSmall)
        {
            // find out cells to add to the left right , epand
        }
        
    }
    
    if(_layout == RKGridViewLayoutLarge)
    {
        RK2DLocation currentCell = [self currentPage];
        RK2DLocation newPage = [self pageForCellLocation:currentCell withLayout:layout];
        NSArray *neededCellLocations = [self cellLocationsForPageAtLocation:newPage withLayout:layout];
        NSMutableSet *neededCells = [[NSMutableSet alloc]initWithCapacity:6];
        
        for (NSString *location in neededCellLocations) 
        {
            RKMatrixViewCell *cell = [self loadCellForLocation:RK2DLocationFromString(location)];
            if (![cell superview]) 
                [_scrollView addSubview:cell];
            [neededCells addObject:cell];
        }
        
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
            for (RKMatrixViewCell *cell in neededCells) 
            {
                cell.frame = [self cellFrameForLocation:cell.location withLayout:layout];
               [self scrollToPageAtRow:newPage.row Column:newPage.column Animated:NO];
            }
            
        } completion:^(BOOL finished){
            if (finished) {
            _layout = layout;
                [self unloadUneccesaryCells:3];

            }
        }];

    }
    
    

}

#pragma mark - Data Management 


-(void)loadPageForLocation:(RK2DLocation)page
{
    if(DEBUG_PAGE_LOAD)
        NSLog(@"Loading Page : %@", NSStringFromRK2DLocation(page));
    
    //  Determine which cells should be on this page 
    for (NSString *locationString in [self cellLocationsForPageAtLocation:page withLayout:_layout])
    {
        RKMatrixViewCell* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
            cell.frame = [self cellFrameForLocation:RK2DLocationFromString(locationString) withLayout:_layout];
        }
        [self loadCellForLocation:RK2DLocationFromString(locationString)];
    }
}


-(void)unloadPageForLocation:(RK2DLocation)page
{
    NSArray *locationsForThisPage = [self cellLocationsForPageAtLocation:page withLayout:_layout];
    
    for (NSString *locationString in locationsForThisPage)
    {   
        RKMatrixViewCell* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
        if(DEBUG_CELL_LOAD)
            NSLog(@"UnLoaded Cell at Location : %@", NSStringFromRK2DLocation(cell.location));
        
            [cell prepareForReuse];
            [_resusableCells addObject:cell];
        }
    }
}



-(RKMatrixViewCell *)loadCellForLocation:(RK2DLocation)location
{
    RKMatrixViewCell *cell = [self cellForLocation:location];

    if(!cell)
    {
        CGRect cellFrame = [self cellFrameForLocation:location withLayout:_layout];
        
        if([self.datasource respondsToSelector:@selector(matrixView:cellForLocation:)])
        {
            cell = [self.datasource matrixView:self cellForLocation:location];
            cell.frame = cellFrame;
        }
        else if([self.datasource respondsToSelector:@selector(matrixView:viewForLocation:withFrame:)])
        {
            cell = [[RKMatrixViewCell alloc]init];
            CGRect contentFrame = cellFrame;
            cellFrame.origin = CGPointZero;
            cell.contentView = [self.datasource matrixView:self viewForLocation:location withFrame:contentFrame];
        }
        else
            NSLog(@"Does not respond to selector!!");
        
        cell.location = location;
        [_scrollView addSubview:cell];
        
      
        if (DEBUG_CELL_LOAD) 
        {
            NSLog(@"Loaded Cell at Location : %@", NSStringFromRK2DLocation(cell.location));
        }

    }
    return cell;
}


-(RKMatrixViewCell *)cellForLocation:(RK2DLocation)location
{
    __block RKMatrixViewCell *cell = nil;
    
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
    
        if ([obj class] == [RKMatrixViewCell class]) 
        {   
            if (RK2DLocationEqualToLocation([(RKMatrixViewCell*)obj location], location))
            {
                cell  = (RKMatrixViewCell*)obj;
                *stop = YES;
            }
        }
    }];
    
    return cell;
}

-(CGRect)cellFrameForLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout
{
    CGRect cellFrame;
    if(layout == RKGridViewLayoutLarge)
    {
        CGRect bounds = _scrollView.bounds;
        cellFrame = bounds;
        cellFrame.origin.x = (bounds.size.width * location.column) + _pagePadding + _cellMarginWidth;
        cellFrame.origin.y = (bounds.size.height * location.row) + _pagePadding + _cellMarginHeight;              
        cellFrame.size.width    -= (2 * (_pagePadding + _cellMarginWidth));
        cellFrame.size.height   -= (2 * (_pagePadding + _cellMarginWidth));
    }
    else if (layout == RKGridViewLayoutMedium)
    {
        CGFloat cellPadding = 5.0f;
        CGRect bounds = _scrollView.bounds;
        cellFrame = bounds;
        cellFrame.size.width    -= (2 * (_pagePadding + _cellMarginWidth));
        cellFrame.size.width     = (cellFrame.size.width / 2) - cellPadding;
        cellFrame.size.height   -= (2 * (_pagePadding + _cellMarginWidth));
        cellFrame.size.height    = (cellFrame.size.height / 2) - cellPadding;
        
        if(0 == location.row % 2) // row is even
            cellFrame.origin.y = (bounds.size.height * (location.row / 2)) + _pagePadding + _cellMarginHeight;              
        else        //row is odd
            cellFrame.origin.y = (bounds.size.height * (location.row / 2) - 1) + cellFrame.size.height + _pagePadding + _cellMarginHeight + cellPadding * 2 ;              

        if(0 == location.column % 2) // column is even
            cellFrame.origin.x = (bounds.size.width  * (location.column / 2)) + _pagePadding + _cellMarginWidth;
        else    // column is odd
            cellFrame.origin.x = (bounds.size.width  * (location.column / 2) - 1) + cellFrame.size.width + _pagePadding + _cellMarginWidth + cellPadding * 2;
    }
    else if (layout == RKGridViewLayoutSmall)
    {
        CGFloat cellPadding = 3.0f;
        CGRect bounds = _scrollView.bounds;
        cellFrame = bounds;
        cellFrame.size.width    -= (2 * (_pagePadding + _cellMarginWidth));
        cellFrame.size.width     = (cellFrame.size.width / 3) - cellPadding;
        cellFrame.size.height   -= (2 * (_pagePadding + _cellMarginWidth));
        cellFrame.size.height    = (cellFrame.size.height / 2) - cellPadding;
        
        switch (location.column % 3) 
        {
            case 0:
               cellFrame.origin.x = (bounds.size.width  * (location.column / 3)) + _pagePadding + _cellMarginWidth; 
                break;
            case 1:
                cellFrame.origin.x = (bounds.size.width  * (location.column / 3) - 1) + cellFrame.size.width + _pagePadding + _cellMarginWidth + cellPadding * 2;
                break;
            case 2:
                cellFrame.origin.x = (bounds.size.width  * (location.column / 3) - 1) + (cellFrame.size.width * 2) + _pagePadding + _cellMarginWidth + cellPadding * 4;
            default:
                break;
        }
        if(0 == location.row % 2) // row is even
            cellFrame.origin.y = (bounds.size.height * (location.row / 2)) + _pagePadding + _cellMarginHeight;              
        else        //row is odd
            cellFrame.origin.y = (bounds.size.height * (location.row / 2) - 1) + cellFrame.size.height + _pagePadding + _cellMarginHeight + cellPadding * 2;              
    }
    else
        cellFrame =  CGRectZero;
if(DEBUG_CELL_FRAME)
    NSLog(@"Location : %@ CellFrame : %@",NSStringFromRK2DLocation(location), NSStringFromCGRect(cellFrame) );
    return cellFrame;
}


-(NSArray *)cellLocationsForPageAtLocation:(RK2DLocation)page withLayout:(RKGridViewLayoutType)layout
{
    NSMutableArray *cellLocations = [[NSMutableArray alloc]initWithCapacity:6];
    
    if(layout == RKGridViewLayoutLarge)    // 1 Large Cell
    {
        [cellLocations addObject:NSStringFromRK2DLocation(page)];    
    }
    else if (layout == RKGridViewLayoutMedium) // 4 Medium Cells
    {
        //---------------
        //   A  |   B   |
        //---------------
        //   C  |   D   |
        //---------------
        RK2DLocation A = RK2DLocationMake(page.row * 2, page.column * 2); 
        RK2DLocation B = RK2DLocationMake(page.row * 2, (page.column * 2) +1);
        RK2DLocation C = RK2DLocationMake((page.row * 2) + 1, page.column * 2);
        RK2DLocation D = RK2DLocationMake((page.row * 2) + 1, (page.column * 2) +1);
        
        [cellLocations addObject:NSStringFromRK2DLocation(A)];
        [cellLocations addObject:NSStringFromRK2DLocation(B)];
        [cellLocations addObject:NSStringFromRK2DLocation(C)];
        [cellLocations addObject:NSStringFromRK2DLocation(D)];
    }
    else if (layout == RKGridViewLayoutSmall)  // 6 Small Cells
    {   //       Landscape          |    Portrait
        //------------------------  |---------------
        //   A  |   B   |   C    |  |   A   |   D  |
        //------------------------  |---------------
        //   D  |   E   |   F    |  |   B   |   E  |
        //------------------------  |---------------
        //                          |   C   |   F  |  
        //                          |---------------
        UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
        RK2DLocation A;
        RK2DLocation B;
        RK2DLocation C;
        RK2DLocation D;
        RK2DLocation E;
        RK2DLocation F;
        if(UIDeviceOrientationIsPortrait(orientation))
        {
            A = RK2DLocationMake(page.row * 3, page.column * 2); 
            B = RK2DLocationMake(A.row, A.column + 1);
            C = RK2DLocationMake(A.row, A.column + 2);
            D = RK2DLocationMake(A.row + 1, A.column);
            E = RK2DLocationMake(A.row + 1, A.column + 1);
            F = RK2DLocationMake(A.row + 1, A.column + 2);
            
        }
        else if(UIDeviceOrientationIsLandscape(orientation))
        {
            A = RK2DLocationMake(page.row * 2, page.column * 3); 
            B = RK2DLocationMake(A.row, A.column + 1);
            C = RK2DLocationMake(A.row, A.column + 2);
            D = RK2DLocationMake(A.row + 1, A.column);
            E = RK2DLocationMake(A.row + 1, A.column + 1);
            F = RK2DLocationMake(A.row + 1, A.column + 2);
        }
        
        [cellLocations addObject:NSStringFromRK2DLocation(A)];
        [cellLocations addObject:NSStringFromRK2DLocation(B)];
        [cellLocations addObject:NSStringFromRK2DLocation(C)];
        [cellLocations addObject:NSStringFromRK2DLocation(D)];
        [cellLocations addObject:NSStringFromRK2DLocation(E)];
        [cellLocations addObject:NSStringFromRK2DLocation(F)];
    }
    return [NSArray arrayWithArray:cellLocations];
}

-(RK2DLocation)pageForCellLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout
{
    RK2DLocation page;
    if(layout == RKGridViewLayoutLarge)    // 1 Large Cell
    {
        page = location;
    }
    else if (layout == RKGridViewLayoutMedium) // 4 Medium Cells
    {  
        page.row = (location.row - (location.row % 2)) / 2;
        page.column = (location.column - (location.column % 2)) / 2;
    }
    else if (layout == RKGridViewLayoutSmall)  // 6 Small Cells
    {  
        page.column = (location.column - (location.column % 3)) / 3;
        page.row = (location.row - (location.column % 2)) / 2;
    }
    
    return page;
}

-(void)scrollToPageAtRow:(NSUInteger)row Column:(NSUInteger)column Animated:(BOOL)animate
{   
    CGRect pageFrame;
    CGRect bounds = _scrollView.bounds;
    pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * column) ;
    pageFrame.origin.y = (bounds.size.height * row);;             
    pageFrame.size.width    -= (2 * _pagePadding);
    pageFrame.size.height   -= (2 * _pagePadding);      
  
    if (animate) 
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
        [_scrollView setContentOffset:pageFrame.origin];
        } completion:^(BOOL fin){}];
    else
        [_scrollView setContentOffset:pageFrame.origin];
}

//---------------------Havent used anything below just yet-----------------------------

-(void)layoutCellsWithStrategy:(RKGridViewLayoutType)newLayout
{   
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        
        switch (newLayout) {
            case RKGridViewLayoutLarge:
                
                break;
            case RKGridViewLayoutMedium:
                
                break;
                
            case RKGridViewLayoutSmall:
                
                break;
            default:
                break;
        }
        
    }
    else
    {
        
    }
    
}


-(void)demoo
{
    RK2DLocation loc;
    loc.row = 0;
    loc.column = 0;
    [self loadPageForLocation:loc];
}




-(void)willRotate:(NSNotification *)notification
{
    NSNumber *num = [notification.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"];
    _visablePageBeforeRotation = [self currentPage];
    switch ([num intValue]) 
    {
        case 1:
        case 2:
            NSLog(@"Orientation Changed to Portrait");
            _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"landscapeBackround.png"]];
            break;
        case 3:
        case 4:
            NSLog(@"Orientation Changed to Landscape");
            _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"portraitBackround.png"]];
            break;
        default:
            break;
    }
    
}


@end