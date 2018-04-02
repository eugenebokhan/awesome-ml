//
//  BorderedButton.m
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import "BorderedButton.h"
#import "UIImage+DownloadButton.h"

@implementation BorderedButton

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateBackgroundImage];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self updateBackgroundImage];
}

- (void)configureDefaultAppearance {
    [self setCornerRadius:4];
    [self setLineWidth:1];
}

- (void)updateBackgroundImage {
    [self setBackgroundImage:[UIImage borderedImageWithFill:nil radius:self.cornerRadius lineColor:self.tintColor lineWidth:self.lineWidth]
                    forState:UIControlStateNormal];

    [self setBackgroundImage:[UIImage borderedImageWithFill:self.tintColor radius:self.cornerRadius lineColor:self.tintColor lineWidth:self.lineWidth]
                    forState:UIControlStateHighlighted];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self updateBackgroundImage];
}

- (void)cleanDefaultAppearance {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self setAttributedTitle:nil forState:UIControlStateNormal];
    [self setAttributedTitle:nil forState:UIControlStateHighlighted];
}

@end
