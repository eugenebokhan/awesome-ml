//
//  CircleView.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CircleView : UIView

@property (nonatomic, assign) IBInspectable CGFloat startAngleRadians;
@property (nonatomic, assign) IBInspectable CGFloat endAngleRadians;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

@end
