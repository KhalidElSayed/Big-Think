//
//  RKGrid.m
//  Major grid
//
//  Created by Richard Kirk on 1/9/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RKMatrixView.h"
#import "RKMatrixViewCell.h"


@interface RKMatrixView () 
{
    CGFloat     _cellPaddingWidth;
    CGFloat     _cellPaddingHeight;
    CGFloat     _pagePadding;
    CGPoint     _contentOffsetMarker;   // Used to determine the direction a user wants to scroll
}
-(void)initForDevice:(UIUserInterfaceIdiom)idiom;
-(void)loadMatrixWithLocation:(RK2DLocation)location;
-(void)reloadData;
-(void)unloadUneccesaryCells;
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
        _cellPaddingHeight = 70.0f;
        _pagePadding = 50.0f;
        
    }
    else 
    {
        _cellPaddingWidth = 15.0f;
        _cellPaddingHeight = 15.0f;
        _pagePadding = 10.0f;        
    }
    
    
    CGRect frame = self.frame;
    frame.origin.x -= _pagePadding;
    frame.origin.y -= _pagePadding;
    frame.size.width += (2 * _pagePadding);
    frame.size.height += (2 * _pagePadding);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:frame];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    
    
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bt.png"]];
    _scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth         | 
    UIViewAutoresizingFlexibleHeight        |
    UIViewAutoresizingFlexibleBottomMargin  |
    UIViewAutoresizingFlexibleLeftMargin    |
    UIViewAutoresizingFlexibleRightMargin   |
    UIViewAutoresizingFlexibleTopMargin;    
    
    [self addSubview:_scrollView];
    
    _resusableCells = [[NSMutableSet alloc]init];
    _visableCells = [[NSMutableSet alloc]init];
    
    
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
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"_scrollView.tracking"];
}


-(void)layoutSubviews
{
    CGRect bounds = _scrollView.bounds;
    _scrollView.contentSize = CGSizeMake(bounds.size.width * sqrtf(_numberOfCells), bounds.size.height * sqrtf(_numberOfCells));
    
#define DEBUG_LAYOUT_SUBVIEWS NO
    
    if(DEBUG_LAYOUT_SUBVIEWS)
    {
        NSLog(@"self.frame : %f, %f, %f , %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"_scrollView.frame : %f, %f, %f , %f", _scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        NSLog(@"_scrollView.bounds : %f, %f, %f , %f", _scrollView.bounds.origin.x, _scrollView.bounds.origin.y, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        NSLog(@"_scrollView.contentSize : %f, %f, ", _scrollView.contentSize.width, _scrollView.contentSize.height);
        NSLog(@"_firstCell.frame : %f, %f, %f , %f", _firstCell.frame.origin.x, _firstCell.frame.origin.y, _firstCell.frame.size.width, _firstCell.frame.size.height);        
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
    
    
    [self loadMatrixWithLocation:locationUserIsMovingTo];
    
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
    
    [_visableCells enumerateObjectsUsingBlock:^(id obj, BOOL *stop)
     {
         RKMatrixViewCell *aCell = (RKMatrixViewCell*)obj;  
         
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
             [_visableCells removeObject:aCell];
         }
         
         
     }];
    
    
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


#define DEBUG_LOAD_MATRIX_WITH_LOCATION NO
-(void)loadMatrixWithLocation:(RK2DLocation)location
{    
    
    if(DEBUG_LOAD_MATRIX_WITH_LOCATION)
        NSLog(@"location :%i, column :%i", location.row, location.column);
    
    if(location.row < 0 || location.column < 0)
        return;
    BOOL alreadyOnScreen = NO;
    
    for (RKMatrixViewCell *cell in _visableCells) 
    {
        if (cell.location.row == location.row && cell.location.column == location.column) 
            
        {
            return;
            //alreadyOnScreen = YES;
        }
    }
    
    
    
           CGRect pageFrame = self.frame;
        
        pageFrame.origin.x = location.column * (_scrollView.frame.size.width);
        pageFrame.origin.y = location.row * (_scrollView.frame.size.height);
        
        CGRect bounds = _scrollView.bounds;
        CGRect pFrame = bounds;
        pFrame.size.width -= (2 * _pagePadding);
        pFrame.origin.x = (bounds.size.width * location.column) + _pagePadding;
        
        
        pFrame.size.height -= (2 * _pagePadding);
        pFrame.origin.y = (bounds.size.height * location.row) + _pagePadding;
        
        
        UIView *pageTile = [[UIView alloc]initWithFrame:pFrame];
        pageTile.backgroundColor = [UIColor randomColor];
        
        pageTile.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
        UIViewAutoresizingFlexibleHeight        | 
        UIViewAutoresizingFlexibleBottomMargin  | 
        UIViewAutoresizingFlexibleLeftMargin    | 
        UIViewAutoresizingFlexibleRightMargin   | 
        UIViewAutoresizingFlexibleTopMargin;
        
        
        
        CGRect cellFrame;
        cellFrame.origin = CGPointMake(_cellPaddingWidth, _cellPaddingHeight);
        cellFrame.size.width = pageFrame.size.width - (_cellPaddingWidth * 2);
        cellFrame.size.height = pageFrame.size.height - (_cellPaddingHeight * 2);
        
        
        
        RKMatrixViewCell *newCell;
        
        if([self.datasource respondsToSelector:@selector(matrixView:cellForLocation:)])
        {
            newCell = [self.datasource matrixView:self cellForLocation:location];
        }
        else if([self.datasource respondsToSelector:@selector(matrixView:viewForLocation:withFrame:)])
        {
            CGRect contentFrame = cellFrame;
            cellFrame.origin = CGPointZero;
            
            newCell = [[RKMatrixViewCell alloc]init];
            newCell.contentView = [self.datasource matrixView:self viewForLocation:location withFrame:contentFrame];
        }
        else
        {
            NSLog(@"Does not respond to selector!!");
        }
        
        newCell.frame = cellFrame;
        newCell.location = location;
        
        [pageTile addSubview:newCell];
        
        //-----------------------------Testing--------------------------
        UILabel *position = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pFrame.size.width, 200.0f)];
        position.text = [NSString stringWithFormat:@"{%i , %i}", location.row, location.column];
        position.font = [UIFont fontWithName:@"Helvetica" size:50.0f ];
        position.textColor = [UIColor blackColor];
        position.textAlignment = UITextAlignmentCenter;
        position.backgroundColor = [UIColor clearColor];
        [pageTile addSubview:position];
        //-----------------------------Testing--------------------------
        
        
        [_scrollView addSubview:pageTile];
        [_visableCells addObject:newCell];
#define DEBUG_LOAD_CELLS NO
        
        if (DEBUG_LOAD_CELLS) 
            NSLog(@"Loading Cell at location {%i,%i}", location.row, location.column);
        
        if(location.row == 0 && location.column == 0)
            _firstCell = pageTile;
    
    
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
{/*
  for (int i = 0; i < 5; i++) 
  {
  for (int p = 0; p < 5; p++) 
  {
  RK2DLocation loc;
  loc.column = i;
  loc.row = p;
  [self loadMatrixWithLocation:loc];            
  }
  }
  */
    
    RK2DLocation loc;
    loc.row = 0;
    loc.column = 0;
    [self loadMatrixWithLocation:loc];
    
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
            break;
        case 3:
        case 4:
            NSLog(@"Orientation Changed to Landscape");
            break;
        default:
            break;
    }
    
}



@end