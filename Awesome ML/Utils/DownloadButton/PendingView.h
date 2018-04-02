//
//  PKPendingView.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

IB_DESIGNABLE
@interface PendingView : UIControl

@property (nonatomic, weak, readonly) CircleView *circleView;

@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, assign) IBInspectable CGFloat emptyLineRadians;
@property (nonatomic, assign) IBInspectable CGFloat spinTime;

- (void)startSpin;
- (void)stopSpin;

@end
