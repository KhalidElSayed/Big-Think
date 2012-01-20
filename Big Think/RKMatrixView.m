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

@interface RKMatrixView () 
{
    CGFloat     _cellPaddingWidth;
    CGFloat     _cellPaddingHeight;
    CGFloat     _pagePadding;
    CGPoint     _contentOffsetMarker;   // Used to determine the direction a user wants to scroll
}
-(void)initForDevice:(UIUserInterfaceIdiom)idiom;
-(void)reloadData;
-(void)unloadUneccesaryCells;
-(void)loadPageForLocation:(RK2DLocation)location;
-(RKMatrixViewCell *)cellForLocation:(RK2DLocation)location;
-(NSString *)stringFromLocation:(RK2DLocation)location;
-(RK2DLocation)locationFromString:(NSString *)location;
@end


@implementation RKMatrixView
@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize currentLocation = _currentLocation;
@synthesize numberOfCells = _numberOfCells;
@synthesize layout;


-(void)initForDevice:(UIUserInterfaceIdiom)idiom
{
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
        [self initForDevice:[[UIDevice currentDevice] userInterfaceIdiom]];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initForDevice:[[UIDevice currentDevice] userInterfaceIdiom]];
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
        _contentOffsetMarker = _scrollView.contentOffset;
    }
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
        else if(_contentOffsetMarker.x > _scrollView.contentOffset.y)   // swiping right
        {
            locationUserIsMovingTo.column -= 1;
            direction = @"swiping right";
        }
    }
    
#define DEBUG_DRAGGING_DIRECTION NO    
    if(DEBUG_DRAGGING_DIRECTION)
        NSLog(@"%@",direction);
    
    [self loadPageForLocation:locationUserIsMovingTo];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self unloadUneccesaryCells];
}


#pragma mark - Memory Management 

#define DEBUG_UNLOADING_CELL NO
-(void)unloadUneccesaryCells
{
    
    RK2DLocation currentLocation = [self currentLocation];
    NSArray *allVisableCells = [_visableCells allValues];
    
    for (RKMatrixViewCell *aCell in allVisableCells) 
    {
        
         
         if(aCell.location.row < currentLocation.row -2      || 
            aCell.location.row > currentLocation.row +2      || 
            aCell.location.column < currentLocation.column-2 ||
            aCell.location.column > currentLocation.column +2)
         {
             
             if(DEBUG_UNLOADING_CELL)
             {
                 NSLog(@"Unloading Cell at location {%i,%i}", aCell.location.row, aCell.location.column);
             }
             [aCell.superview removeFromSuperview];
             [aCell prepareForReuse];
             [_resusableCells addObject:aCell];
             [_visableCells removeObjectsForKeys:[_visableCells allKeysForObject:aCell]];
         }
    };
    
    
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


#pragma mark - Data Management 

-(void)reloadData
{
    if([_datasource respondsToSelector:@selector(numberOfCellsInMatrix:)])
        self.numberOfCells = [_datasource numberOfCellsInMatrix:self];
    else
        NSLog(@"Delegate Does not respond to numberOfCellsInMatrix:");
    
}


-(void)loadPageForLocation:(RK2DLocation)location
{

    
    //  Determine which cells should be on this page 
    if(_layout == RKGridViewLayoutLarge)    // 1 Large Cell
    {
        [_scrollView addSubview:[self cellForLocation:location]];    
    }
    else if (_layout == RKGridViewLayoutMedium) // 4 Medium Cells
    {
        /*
        RK2DLocation one; 
        
        RK2DLocation two;
        
        RK2DLocation three;
        
        RK2DLocation four;
    */
    }
    else if (_layout == RKGridViewLayoutSmall)  // 6 Small Cells
    {
        
    }
    
}


-(RKMatrixViewCell *)cellForLocation:(RK2DLocation)location
{
    RKMatrixViewCell *cell = [_visableCells objectForKey:[self stringFromLocation:location]];
    
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

    if(!cell)
    {
        if([self.datasource respondsToSelector:@selector(matrixView:cellForLocation:)])
        {
            cell = [self.datasource matrixView:self cellForLocation:location];
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
        [_visableCells setObject:cell forKey:[self stringFromLocation:location]];
    }
    
        cell.frame = cellFrame;
        
    return cell;
}


-(NSString *)stringFromLocation:(RK2DLocation)location
{
    return [NSString stringWithFormat:@"{%i,%i}",location.row, location.column];
}


-(RK2DLocation)locationFromString:(NSString *)location
{
    RK2DLocation loc;
    loc.row = [[location substringWithRange:NSMakeRange(1, 1)] integerValue];
    loc.row = [[location substringWithRange:NSMakeRange(3, 1)] integerValue];
    return loc;
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


-(void)setLayout:(RKGridViewLayoutType)newLayout
{
    if (self.layout != newLayout)
    {
        // [self layoutCellsWithStrategy:(RKGridViewLayoutType)newLayout];
        
    }
    
    
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