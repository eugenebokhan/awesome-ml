//
//  PendingView.m
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import "PendingView.h"
#import "NSLayoutConstraint+DownloadButton.h"
#import "CALayer+DownloadButtonAnimations.h"

static NSString *const kSpinAnimationKey = @"Spin";
static const CGFloat kDefaultRaduis = 13.f;
static const CGFloat kDefaultEmptyLineRadians = 0.4f;
static const CGFloat kDefaultSpinTime = 1.f;

@interface PendingView ()

@property (nonatomic, weak) CircleView *circleView;
@property (nonatomic, weak) NSLayoutConstraint *width;
@property (nonatomic, weak) NSLayoutConstraint *height;
@property (nonatomic, assign) BOOL isSpinning;

- (CircleView *)createCircleView;

- (NSArray *)createConstraints;

@end

static PendingView *CommonInit(PendingView *self) {
    if (self != nil) {
        CircleView *circleView = [self createCircleView];
        circleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:circleView];
        self.circleView = circleView;
        self.circleView.userInteractionEnabled = NO;
        [self addConstraints:[self createConstraints]];
        
        self.emptyLineRadians = kDefaultEmptyLineRadians;
        self.radius = kDefaultRaduis;
        self.clipsToBounds = NO;
        
        self.spinTime = kDefaultSpinTime;
        [self startSpin];
    }
    return self;
}

@implementation PendingView

#pragma mark - initialization

- (id)initWithCoder:(NSCoder *)decoder {
    return CommonInit([super initWithCoder:decoder]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return CommonInit([super initWithFrame:frame]);
}

#pragma mark - properties

- (void)setSpinTime:(CGFloat)spinTime {
    _spinTime = spinTime;
    [self.circleView.layer removeRotationAnimationWithKey:kSpinAnimationKey];
    if (self.isSpinning) {
        [self startSpin];
    }
}

- (void)setRadius:(CGFloat)radius {
    self.width.constant = radius * 2;
    self.height.constant = radius * 2;
    [self setNeedsLayout];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.circleView.lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (CGFloat)lineWidth {
    return self.circleView.lineWidth;
}

- (void)setEmptyLineRadians:(CGFloat)emptyLineRadians {
    _emptyLineRadians = emptyLineRadians;
    self.circleView.startAngleRadians = 1.5f * M_PI + emptyLineRadians / 2.f;
    self.circleView.endAngleRadians = self.circleView.startAngleRadians + 2 * M_PI - emptyLineRadians;
    [self setNeedsDisplay];
}

- (void)setTintColor:(UIColor *)tintColor {
    self.circleView.tintColor = tintColor;
    [self setNeedsDisplay];
}

#pragma mark - private methods

- (CircleView *)createCircleView {
    CircleView *circleView = [[CircleView alloc] init];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintForView:circleView
                                                                      withHeight:0.f];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintForView:circleView
                                                                      withWidth:0.f];
    
    [circleView addConstraints:@[heightConstraint, widthConstraint]];
    
    self.width = widthConstraint;
    self.height = heightConstraint;
    
    return circleView;
}

- (NSArray *)createConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsForWrappedSubview:self.circleView
                                                                           withInsets:UIEdgeInsetsZero]];
    return constraints;
}

- (void)startSpin {
    self.isSpinning = YES;
    [self.circleView.layer addRotationAnimationWithKey:kSpinAnimationKey
                                  fullRotationDuration:self.spinTime];
}

- (void)stopSpin {
    [self.circleView.layer removeRotationAnimationWithKey:kSpinAnimationKey];
    self.isSpinning = NO;
}

@end
