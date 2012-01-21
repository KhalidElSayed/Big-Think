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
#define DEBUG_DRAGGING_DIRECTION NO    

static inline RK2DLocation RK2DLocationMake(NSInteger row, NSInteger column)
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
    CGFloat     _cellPaddingWidth;
    CGFloat     _cellPaddingHeight;
    CGFloat     _pagePadding;
    CGPoint     _contentOffsetMarker;   // Used to determine the direction a user wants to scroll
}
-(void)setup;
-(void)reloadData;
-(void)unloadUneccesaryCells:(int)level;
-(void)loadPageForLocation:(RK2DLocation)location;
-(void)unloadPageForLocation:(RK2DLocation)location;
-(RKMatrixViewCell *)cellForLocation:(RK2DLocation)location;
-(NSArray *)cellLocationsForPageAtLocation:(RK2DLocation)location;
-(CGRect)cellFrameForLocation:(RK2DLocation)location;
-(void)loadCellForLocation:(RK2DLocation)location;
@end


@implementation RKMatrixView
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize currentLocation = _currentLocation;
@synthesize numberOfCells = _numberOfCells;
@synthesize layout = _layout;


-(void)setup
{
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    if (idiom == UIUserInterfaceIdiomPad) 
    {
        _cellPaddingWidth = 50.0f;
        _cellPaddingHeight = 50.0f;
        _pagePadding = 50.0f;
    }
    else 
    {
        _cellPaddingWidth = 15.0f;
        _cellPaddingHeight = 15.0f;
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
    
    [_scrollView setMinimumZoomScale:0.5f];
    [_scrollView setMaximumZoomScale:2.0f];
    

    [self addSubview:_scrollView];
    
    _layout = RKGridViewLayoutLarge;
    _resusableCells = [[NSMutableSet alloc]init];
    _visableCells = [[NSMutableDictionary alloc]init];
    
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
}


-(void)layoutSubviews
{
    CGRect bounds = _scrollView.bounds;
    _scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
    
    if(DEBUG_LAYOUT_SUBVIEWS)
    {
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
#define DEBUG_DRAGGING NO   
    if(DEBUG_DRAGGING)
    {
        NSLog(@"_scrollView.contentOffset : %f, %f\n\n ", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
    }
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
        RK2DLocation location = [self currentLocation];
        NSLog(@"CurrentLocation row :%i, column :%i", location.row, location.column);
        NSLog(@"_scrollView.contentOffset : %f, %f\n\n ", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
        NSLog(@"_scrollView.bounds : %@", NSStringFromCGRect(_scrollView.bounds) );
    }
    
    
    NSString *direction;
    RK2DLocation locationUserIsMovingTo = self.currentLocation;
    
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
    [self unloadUneccesaryCells:2];
}


#pragma mark - Memory Management 


-(void)unloadUneccesaryCells:(int)level
{
    RK2DLocation currentLocation = [self currentLocation];
    RK2DLocation left = RK2DLocationMake(currentLocation.row, currentLocation.column - level);
    RK2DLocation top = RK2DLocationMake(currentLocation.row - level, currentLocation.column);
    RK2DLocation bottom = RK2DLocationMake(currentLocation.row + level, currentLocation.column);
    RK2DLocation right = RK2DLocationMake(currentLocation.row , currentLocation.column + level );
    
    if(left.column >=0)
    [self unloadPageForLocation:left];
    

    [self unloadPageForLocation:bottom];
    [self unloadPageForLocation:right];
    
    if(top.row >= 0)
    [self unloadPageForLocation:top];
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

-(RK2DLocation)currentLocation
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    _currentLocation.column = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    CGFloat pageHeight = _scrollView.bounds.size.height;
    _currentLocation.row = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    return _currentLocation;
}

-(void)setDatasource:(id<RKMatrixViewDatasource>)aDatasource
{
    _datasource = aDatasource;
    [self reloadData];
}

-(void)setNumberOfCells:(int)newNumberOfCells
{
    _numberOfCells = newNumberOfCells;
    CGRect bounds = _scrollView.bounds;
    _scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
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
    
    
    
    
    
}

#pragma mark - Data Management 


-(void)loadPageForLocation:(RK2DLocation)location
{
#define DEBUG_PAGE_LOAD NO
    if(DEBUG_PAGE_LOAD)
        NSLog(@"Loading Page : %@", NSStringFromRK2DLocation(location));
    
    //  Determine which cells should be on this page 
    for (NSString *locationString in [self cellLocationsForPageAtLocation:location])
    {
        [self loadCellForLocation:RK2DLocationFromString(locationString)];
    }
}


-(void)unloadPageForLocation:(RK2DLocation)location
{
    NSArray *locationsForThisPage = [self cellLocationsForPageAtLocation:location];
    
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


-(void)loadCellForLocation:(RK2DLocation)location
{
    RKMatrixViewCell *cell = [self cellForLocation:location];

    if(!cell)
    {
        CGRect cellFrame = [self cellFrameForLocation:location];
        
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

-(CGRect)cellFrameForLocation:(RK2DLocation)location
{
    CGRect cellFrame;
    if(_layout == RKGridViewLayoutLarge)
    {
        CGRect bounds = _scrollView.bounds;
        cellFrame = bounds;
        cellFrame.origin.x = (bounds.size.width * location.column) + _pagePadding + _cellPaddingWidth;
        cellFrame.origin.y = (bounds.size.height * location.row) + _pagePadding + _cellPaddingHeight;              
        cellFrame.size.width    -= (2 * (_pagePadding + _cellPaddingWidth));
        cellFrame.size.height   -= (2 * (_pagePadding + _cellPaddingWidth));
    }
    else if (_layout == RKGridViewLayoutMedium)
    {
        
    }
    else if (_layout == RKGridViewLayoutSmall)
    {
        
    }
    else
        cellFrame =  CGRectZero;

    return cellFrame;
}


-(NSArray *)cellLocationsForPageAtLocation:(RK2DLocation)location
{
    NSMutableArray *cellLocations = [[NSMutableArray alloc]initWithCapacity:6];
    
    if(_layout == RKGridViewLayoutLarge)    // 1 Large Cell
    {
        [cellLocations addObject:NSStringFromRK2DLocation(location)];    
    }
    else if (_layout == RKGridViewLayoutMedium) // 4 Medium Cells
    {
        //---------------
        //   A  |   B   |
        //---------------
        //   C  |   D   |
        //---------------
        RK2DLocation A = RK2DLocationMake(location.row * 2, location.column * 2); 
        RK2DLocation B = RK2DLocationMake(location.row * 2, (location.column * 2) +1);
        RK2DLocation C = RK2DLocationMake((location.row * 2) + 1, location.column * 2);
        RK2DLocation D = RK2DLocationMake((location.row * 2) + 1, (location.column * 2) +1);
        
        [cellLocations addObject:NSStringFromRK2DLocation(A)];
        [cellLocations addObject:NSStringFromRK2DLocation(B)];
        [cellLocations addObject:NSStringFromRK2DLocation(C)];
        [cellLocations addObject:NSStringFromRK2DLocation(D)];
    }
    else if (_layout == RKGridViewLayoutSmall)  // 6 Small Cells
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
            A = RK2DLocationMake(location.row * 3, location.column * 2); 
            B = RK2DLocationMake(A.row, A.column + 1);
            C = RK2DLocationMake(A.row, A.column + 2);
            D = RK2DLocationMake(A.row + 1, A.column);
            E = RK2DLocationMake(A.row + 1, A.column + 1);
            F = RK2DLocationMake(A.row + 1, A.column + 2);
            
        }
        else if(UIDeviceOrientationIsLandscape(orientation))
        {
            A = RK2DLocationMake(location.row * 2, location.column * 3); 
            B = RK2DLocationMake(A.row + 1, A.column);
            C = RK2DLocationMake(A.row + 2, A.column);
            D = RK2DLocationMake(A.row, A.column + 1);
            E = RK2DLocationMake(A.row + 1, A.column + 1);
            F = RK2DLocationMake(A.row + 2, A.column + 1);
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


-(void)zoom:(float)scale
{
    [_scrollView setZoomScale:scale animated:YES];
}


-(void)willRotate:(NSNotification *)notification
{
    NSNumber *num = [notification.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"];
    
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