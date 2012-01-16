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
}
-(void)initForDevice:(UIUserInterfaceIdiom)idiom;
-(void)loadMatrixWithLocation:(RK2DLocation)location;
//-(void)layoutCellsWithStrategy:(RKGridViewLayoutType)newLayout;
//-(void)setNumberOfPages:(NSInteger)pages;


@end


@implementation RKMatrixView


@synthesize delegate = _delegate;
@synthesize datasource = _datasource;
@synthesize currentLocation = _currentLocation;
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
        _cellPaddingWidth = 20.0f;
        _cellPaddingHeight = 44.0f;
        _pagePadding = 10.0f;        
    }
    
    
    
    // Initialization code
  //  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width + _pagePadding, self.bounds.size.height + _pagePadding)];
    
    [_scrollView setPagingEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setDirectionalLockEnabled:YES];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(5 * (self.frame.size.width + _pagePadding), 5 * (self.frame.size.height + _pagePadding))];
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bt.png"]]];
    // [_scrollView setContentMode:UIViewContentModeCenter];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth         | 
    UIViewAutoresizingFlexibleHeight        ;    
    [self addSubview:_scrollView];
    _testCells = [[NSMutableArray alloc]initWithCapacity:30];
    _cells = [[NSMutableDictionary alloc]initWithCapacity:100];
    
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification  object:nil];
}

-(void)willRotate:(NSNotification *)notification
{
    
    NSNumber *num = [notification.userInfo objectForKey:@"UIApplicationStatusBarOrientationUserInfoKey"];
    
    switch ([num intValue]) 
    {
        case 1:
        case 2:
            NSLog(@"Orientation Changed to Portrait");
            /*
             NSLog(@"self.frame : %f, %f, %f , %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
             NSLog(@"_scrollView.frame : %f, %f, %f , %f", _scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);        
             NSLog(@"_firstCell.frame : %f, %f, %f , %f", _firstCell.frame.origin.x, _firstCell.frame.origin.y, _firstCell.frame.size.width, _firstCell.frame.size.height);        
             */ 
            //  [_scrollView setContentSize:CGSizeMake(5 * (self.frame.size.width + _pagePadding), 5 * (self.frame.size.height + _pagePadding))];
            break;
        case 3:
        case 4:
            NSLog(@"Orientation Changed to Landscape");
            /*
             NSLog(@"self.frame : %f, %f, %f , %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
             NSLog(@"_scrollView.frame : %f, %f, %f , %f", _scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);        
             NSLog(@"_firstCell.frame : %f, %f, %f , %f", _firstCell.frame.origin.x, _firstCell.frame.origin.y, _firstCell.frame.size.width, _firstCell.frame.size.height);        
             */
          //    [_scrollView setContentSize:CGSizeMake(5 * (self.frame.size.width + _pagePadding), 5 * (self.frame.size.height + _pagePadding))];
            
            break;
        default:
            break;
    }
    
}

-(RK2DLocation)currentLocation
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    _currentLocation.column = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    CGFloat pageHeight = _scrollView.frame.size.height;
    _currentLocation.row = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    
    return _currentLocation;
}

-(void)setLayout:(RKGridViewLayoutType)newLayout
{
    if (self.layout != newLayout)
    {
        // [self layoutCellsWithStrategy:(RKGridViewLayoutType)newLayout];
        
    }
    
    
}

-(void)setNumberOfPages:(NSInteger)pages
{
    
}

-(void)loadMatrixWithLocation:(RK2DLocation)location
{    
    
    CGRect pageFrame = self.frame;
   // pageFrame.size.width += 5.0f;
    pageFrame.origin.x = location.column * (_scrollView.frame.size.width);
    pageFrame.origin.y = location.row * (_scrollView.frame.size.height);
    
    UIView *pageTile = [[UIView alloc]initWithFrame:pageFrame];
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
    
    
    
    RKMatrixViewCell *newCell = [[RKMatrixViewCell alloc]initWithFrame:cellFrame];
    
    if([self.datasource respondsToSelector:@selector(matrixView:viewForLocation:withFrame:)])
    {
        CGRect viewFrame = newCell.bounds;
        viewFrame.origin = CGPointZero;
        
        newCell.contentView = [self.datasource matrixView:self viewForLocation:location withFrame:viewFrame];
  
    
    }
    else
    {
        NSLog(@"Does not respond to selector!!");
    }
    
    [pageTile addSubview:newCell];
    
    [_scrollView addSubview:pageTile];
    
    //--------------------Testing---------------------
    [_testCells addObject:pageTile];
    
    if(location.row == 0 && location.column == 0)
        _firstCell = pageTile;
    
    
}


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
    
    
    
    
}














@end