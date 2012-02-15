//
//  RKMatrix.m
//
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMatrixView.h"
#import "RKMatrixViewCell.h"
#import "RKCellViewController.h"
#import "UIImage+RKImage.h"

#define MAX_RESUABLE_CELLS 30

//-----Debugging Helpers----------
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
    NSUInteger commaLocation = [string rangeOfString:@","].location;
    location.row = [[string substringWithRange:NSMakeRange(1, commaLocation - 1)] integerValue];
    location.column = [[string substringWithRange:NSMakeRange(commaLocation + 1, (string.length - 1) - (commaLocation + 1))] integerValue ];   
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
    BOOL            _didRotate;
    BOOL            _isAnimating;
}
-(void)setup;
-(void)reloadData;

-(void)loadPageAtLocation:(RK2DLocation)page;
-(void)unloadPageAtLocation:(RK2DLocation)page;
-(RKCellViewController *)cellForLocation:(RK2DLocation)location;
-(RKCellViewController *)loadCellForLocation:(RK2DLocation)location;
-(NSSet*)cellsForPage:(RK2DLocation)page;

-(NSArray *)cellLocationsForPageAtLocation:(RK2DLocation)page withLayout:(RKGridViewLayoutType)layout;
-(CGRect)cellFrameForLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout;
-(RK2DLocation)pageForCellLocation:(RK2DLocation)location withLayout:(RKGridViewLayoutType)layout;
-(void)enqueCell:(RKCellViewController*)cell;

-(void)willRotate:(NSNotification *)notification;
@end


@implementation RKMatrixView
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize currentPage = _currentPage;
@synthesize numberOfCells = _numberOfCells;
@synthesize layout = _layout;
@synthesize visableCells = _visableCells;
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
    
    _scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //-------------------------------------------
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * 15, _scrollView.bounds.size.height * 15);
    //-------------------------------------------
    
    
    [self addSubview:_scrollView];
    
    //_zoomingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //_zoomingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[_scrollView addSubview:_zoomingView];
    
    _layout = RKGridViewLayoutLarge;
    _reusableCells = [[NSMutableSet alloc]init];
    _visableCells = [[NSMutableSet alloc]init];
    RK2DLocationFromString(@"{1226,4503}");
    RK2DLocationFromString(@"{81923,1}");
    
    
    NSLog(@"%@%@%@", NSStringFromRK2DLocation(RK2DLocationMake(11, 12)), NSStringFromRK2DLocation(RK2DLocationMake(1112312312, 2)), NSStringFromRK2DLocation(RK2DLocationMake(13632,20395)));
    
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
    _reusableCells = nil;
    _scrollView = nil;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // -- reset content size 
    if(_didRotate)
    {
        [self scrollToPageAtRow:_visablePageBeforeRotation.row Column:_visablePageBeforeRotation.column Animated:YES];
        _didRotate = NO;
    }
    
    for (RKCellViewController* cell in _visableCells) 
    {
        
        cell.view.frame = [self cellFrameForLocation:cell.location withLayout:_layout];
    }
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice]orientation];
    if(UIDeviceOrientationIsLandscape(orientation)) 
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"landscapeBackround.png"] scaledToSize:_scrollView.bounds.size]]; 
    else if(UIDeviceOrientationIsPortrait(orientation))
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithImage:[UIImage imageNamed:@"portraitBackround.png"] scaledToSize:_scrollView.bounds.size] ];     
    
    
    
    
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
    
    CGFloat pageWidth = _scrollView.bounds.size.width;
    _currentPage.column = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGFloat pageHeight = _scrollView.bounds.size.height;
    _currentPage.row = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
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
        NSLog(@"_scrollView.contentOffset : %f, %f ", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
        NSLog(@"_scrollView.bounds : %@", NSStringFromCGRect(_scrollView.bounds) );
        NSLog(@"_contentOffsetMarker : %@", NSStringFromCGPoint(_contentOffsetMarker));
    }
    
    
    RK2DLocation locationUserIsMovingTo = self.currentPage;
    
    if (_contentOffsetMarker.x == _scrollView.contentOffset.x)   // scrolling Vertically
    {
        if(_contentOffsetMarker.y < _scrollView.contentOffset.y + 10)    // pushing up
        {
            locationUserIsMovingTo.row += 1;
    
        }
        else if (_contentOffsetMarker.y > _scrollView.contentOffset.y + 20) // pulling down
        {
            locationUserIsMovingTo.row -= 1;
    
        }
    }
    else if(_contentOffsetMarker.y == _scrollView.contentOffset.y) // scrolling Horizontally
    {
        if(_contentOffsetMarker.x < _scrollView.contentOffset.x + 10)    //swiping left
        {
            locationUserIsMovingTo.column += 1;
    
        }
        else if(_contentOffsetMarker.x > _scrollView.contentOffset.x + 20)   // swiping right
        {
            locationUserIsMovingTo.column -= 1;
    
        }
    }
    
    
    
    if(!_isAnimating && _scrollView.isTracking)
        [self loadPageAtLocation:locationUserIsMovingTo];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    _currentPage.column = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    CGFloat pageHeight = _scrollView.bounds.size.height;
    _currentPage.row = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    [self unloadUneccesaryCells:1];    
}




#pragma mark - Memory Management 


-(void)unloadUneccesaryCells:(int)level
{   
    CGRect bounds = _scrollView.bounds;
    CGRect boundsToSave = CGRectInset(bounds, -(bounds.size.width * level), -(bounds.size.height *level));
    //NSLog(@"%@,%@", NSStringFromCGRect(_scrollView.bounds),NSStringFromCGRect(boundsToSave));
    
    NSSet *cellsToRemove = [_visableCells objectsPassingTest:^BOOL(id obj, BOOL *stop){
        return !CGRectContainsRect(boundsToSave, [[(RKCellViewController*)obj view] frame]);
    }];
    
    for (RKCellViewController *cell in cellsToRemove) 
    {
        if (!CGRectContainsRect(boundsToSave, cell.view.frame))
        {
            if(DEBUG_CELL_LOAD)
                NSLog(@"UnLoaded Cell at Location : %@", NSStringFromRK2DLocation(cell.location));
            [self enqueCell:cell];
        }
    }
    [_visableCells minusSet:cellsToRemove];
    if(DEBUG_CELL_LOAD)
        NSLog(@"Number Of Visable Cells : %i", [_visableCells count]);
    
}




-(NSSet*)cellsForPage:(RK2DLocation)page
{
    NSMutableSet *setOfCells = [[NSMutableSet alloc]initWithCapacity:6];
    for (NSString *locationString in [self cellLocationsForPageAtLocation:page withLayout:_layout])
    {
        RKCellViewController* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
            [setOfCells addObject:cell];
        }
    }
    return ([setOfCells count] == 0) ? nil : setOfCells;
}


-(RKCellViewController *)dequeResuableCell
{
    RKCellViewController *cell = [_reusableCells anyObject];
    if(cell)
    {
        [_reusableCells removeObject:cell]; 
        
    }
    return cell;
}


#pragma mark - Setters/Getters

-(RK2DLocation)currentPage
{
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
    //  CGRect bounds = _scrollView.bounds;
    //_scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
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
    if (_layout == layout)
    {// Don't waste time if the layout isn't being changed
        return;
    }
    // Choose a cell to focus on, expand,
    RK2DLocation currentPage = [self currentPage];
    
    int focus;
    if (_layout == RKGridViewLayoutSmall && (currentPage.column -1) % 3 == 0) {
        focus = 2;
    }
    else 
        focus = 0;
    
    NSString* cellToFocusOnLocationString = [[self cellLocationsForPageAtLocation:currentPage withLayout:_layout] objectAtIndex:focus];
    RK2DLocation cellToFocusOnLocation = RK2DLocationFromString(cellToFocusOnLocationString);
    RK2DLocation newPage = [self pageForCellLocation:cellToFocusOnLocation withLayout:layout];
    
    
    NSArray *neededCellLocations = [self cellLocationsForPageAtLocation:newPage withLayout:layout];
    
    for (NSString *location in neededCellLocations) 
    {
        RKCellViewController *cell = [self loadCellForLocation:RK2DLocationFromString(location)];
        cell.view.frame = [self cellFrameForLocation:cell.location withLayout:_layout];
        if (![cell.view superview]) 
            [_scrollView addSubview:cell.view];
        [_visableCells addObject:cell];
        
    }
    
    
    
    
    
    _isAnimating = YES;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationCurveEaseInOut  animations:^{
        for (RKCellViewController *cell in _visableCells) 
        {
            cell.currentLayout = layout;
            cell.view.frame = [self cellFrameForLocation:cell.location withLayout:layout];
        }
        [self scrollToPageAtRow:newPage.row Column:newPage.column Animated:NO];
    }
     
                     completion:^(BOOL finished){
                         if (finished) {
                             _layout = layout;
                             _isAnimating = NO;
                             [self unloadUneccesaryCells:0];
                             [self setNeedsLayout];
                             _currentPage = newPage;
                             
                         }
                     }];
    
}





#pragma mark - Data Management 


-(void)loadPageAtLocation:(RK2DLocation)page
{
    if(DEBUG_PAGE_LOAD)
        NSLog(@"Loading Page : %@\tcells :", NSStringFromRK2DLocation(page));
    
    //  Determine which cells should be on this page 
    for (NSString *locationString in [self cellLocationsForPageAtLocation:page withLayout:_layout])
    {
        //if(DEBUG_PAGE_LOAD)
        //  NSLog(@"\t%@", locationString);
        RKCellViewController* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
            cell.view.frame = [self cellFrameForLocation:RK2DLocationFromString(locationString) withLayout:_layout];
        }
        [self loadCellForLocation:RK2DLocationFromString(locationString)];
    }
}


-(void)unloadPageAtLocation:(RK2DLocation)page
{
    NSArray *locationsForThisPage = [self cellLocationsForPageAtLocation:page withLayout:_layout];
    
    for (NSString *locationString in locationsForThisPage)
    {   
        RKCellViewController* cell = [self cellForLocation:RK2DLocationFromString(locationString)];
        if(cell)
        {
            if(DEBUG_CELL_LOAD)
                NSLog(@"UnLoaded Cell at Location : %@", NSStringFromRK2DLocation(cell.location));
            
            
            [self enqueCell:cell];
            
        }
    }
    [_visableCells minusSet:_reusableCells];
}



-(RKCellViewController *)loadCellForLocation:(RK2DLocation)location
{
    RKCellViewController *cell = [self cellForLocation:location];
    
    if(!cell)
    {
        CGRect cellFrame = [self cellFrameForLocation:location withLayout:_layout];
        
        if([self.datasource respondsToSelector:@selector(matrixView:cellForLocation:)])
        {
            cell = [self.datasource matrixView:self cellForLocation:location];
            cell.view.frame = cellFrame;
        }
        else if([self.datasource respondsToSelector:@selector(matrixView:viewForLocation:withFrame:)])
        {
            cell = [[RKCellViewController alloc]init];
            CGRect contentFrame = cellFrame;
            cellFrame.origin = CGPointZero;
            cell.view = [self.datasource matrixView:self viewForLocation:location withFrame:contentFrame];
        }
        else
            NSLog(@"Does not respond to selector!!");
        
        cell.location = location;
        cell.currentLayout = _layout;
        [_scrollView addSubview:cell.view];
        [_visableCells addObject:cell];
        
        if (DEBUG_CELL_LOAD) 
        {
            NSLog(@"Loaded Cell at Location : %@", NSStringFromRK2DLocation(cell.location));
        }
        
    }
    return cell;
}


-(RKCellViewController *)cellForLocation:(RK2DLocation)location
{
    __block RKCellViewController *cell = nil;
    [_visableCells enumerateObjectsUsingBlock:^(id obj, BOOL *stop)
     {        
         if (RK2DLocationEqualToLocation([(RKCellViewController*)obj location], location))
         {
             cell  = (RKCellViewController*)obj;
             *stop = YES;
         }
     }];
    return cell;
}


-(void)enqueCell:(RKCellViewController*)cell
{
    if([_visableCells containsObject:cell])
    {
        if ([_reusableCells count] < MAX_RESUABLE_CELLS) 
        {   
            [cell prepareForReuse];
            [_visableCells removeObject:cell];
            [_reusableCells addObject:cell];
        }
        else cell = nil;
    }
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
    {   //       Landscape         
        //------------------------ 
        //   A  |   B   |   C    | 
        //------------------------ 
        //   D  |   E   |   F    | 
        //------------------------ 
        RK2DLocation A = RK2DLocationMake(page.row * 2, page.column * 3); 
        RK2DLocation B = RK2DLocationMake(A.row, A.column + 1);
        RK2DLocation C = RK2DLocationMake(A.row, A.column + 2);
        RK2DLocation D = RK2DLocationMake(A.row + 1, A.column);
        RK2DLocation E = RK2DLocationMake(A.row + 1, A.column + 1);
        RK2DLocation F = RK2DLocationMake(A.row + 1, A.column + 2);
        
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
        page.row = (location.row - (location.row % 2)) / 2;
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


-(void)willRotate:(NSNotification *)notification
{
    _visablePageBeforeRotation = [self currentPage];
    _didRotate = YES;
}




@end