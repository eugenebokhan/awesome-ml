//
//  StopDownloadButton.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"

IB_DESIGNABLE
@interface StopDownloadButton : CircleProgressView

@property (nonatomic, assign) IBInspectable CGFloat stopButtonWidth;
@property (nonatomic, weak, readonly) UIButton *stopButton;

@end
