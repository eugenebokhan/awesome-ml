//
//  StopDownloadButton.m
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import "StopDownloadButton.h"
#import "NSLayoutConstraint+DownloadButton.h"
#import "UIImage+DownloadButton.h"

static const CGFloat kDefaultStopButtonWidth = 8.f;

@interface StopDownloadButton ()

@property (nonatomic, weak) UIButton *stopButton;

- (UIButton *)createStopButton;
- (NSArray *)createStopButtonConstraints;
- (void)updateAppearance;
- (CircleProgressView *)createCircleProgressView;

@end

static StopDownloadButton *CommonInit(StopDownloadButton *self) {
    if (self != nil) {
        UIButton *stopButton = [self createStopButton];
        stopButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:stopButton];
        self.stopButton = stopButton;
        
        [self addConstraints:[self createStopButtonConstraints]];
        [self updateAppearance];
        [self setNeedsDisplay];
    }
    return self;
}

@implementation StopDownloadButton

#pragma mark - properties

- (void)setStopButtonWidth:(CGFloat)stopButtonWidth {
    _stopButtonWidth = stopButtonWidth;
    [self.stopButton setImage:[UIImage stopImageOfSize:stopButtonWidth
                                                 color:self.tintColor]
                     forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

#pragma mark - initialization

- (instancetype)initWithCoder:(NSCoder *)decoder {
    return CommonInit([super initWithCoder:decoder]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return CommonInit([super initWithFrame:frame]);
}

#pragma mark - private methods

- (UIButton *)createStopButton {
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	stopButton.tintColor = [UIColor clearColor];
    _stopButtonWidth = kDefaultStopButtonWidth;
    return stopButton;
}

- (NSArray *)createStopButtonConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsForWrappedSubview:self.stopButton
                                                                           withInsets:UIEdgeInsetsZero]];
    
    return constraints;
}

- (CircleProgressView *)createCircleProgressView {
    CircleProgressView *circleProgressView = [[CircleProgressView alloc] init];
    
    return circleProgressView;
}

#pragma mark - appearance

- (void)updateAppearance {
	[self.stopButton setImage:[UIImage stopImageOfSize:_stopButtonWidth color:self.tintColor]
				forState:UIControlStateNormal];
}

- (void)tintColorDidChange {
	[super tintColorDidChange];
	[self updateAppearance];
}
@end
