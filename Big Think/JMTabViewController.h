//  Created by Jason Morrissey

#import <Foundation/Foundation.h>
#import "JMTabView.h"

@class ExploreViewController;
@class SpeakerViewController;

@interface JMTabViewController : UIViewController <JMTabViewDelegate>
{
    UIView*     _containerView;
    NSUInteger  _currentTab;
}
@property (strong,nonatomic) ExploreViewController* tab1;
@property (strong,nonatomic) SpeakerViewController* tab2;
@property (copy,nonatomic) NSArray* viewControllers;

@end
