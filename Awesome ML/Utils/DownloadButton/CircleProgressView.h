//
//  CircleProgressView.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CircleProgressView : UIView

@property (nonatomic, assign) IBInspectable CGFloat progress; /// 0.f - 1.0f
@property (nonatomic, assign) IBInspectable CGFloat filledLineWidth; /// 0.f +
@property (nonatomic, assign) IBInspectable CGFloat emptyLineWidth; /// 0.f +
@property (nonatomic, assign) IBInspectable CGFloat radius; /// 0.f +
@property (nonatomic, assign) IBInspectable BOOL filledLineStyleOuter;

@end
