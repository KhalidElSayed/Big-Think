//
//  RKTagButton.h
//  Big Think
//
//  Created by Richard Kirk on 1/28/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXLabel;
@interface RKTagButton : UIButton
{
    NSString*       _tagString;
    FXLabel*        _tagLabel;
    UIImageView*    _backroundImage;
}
@property (strong, nonatomic) NSString *tagString;
-(id)initWithTag:(NSString*)newTag;



@end
