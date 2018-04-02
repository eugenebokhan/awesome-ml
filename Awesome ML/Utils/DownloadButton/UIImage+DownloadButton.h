//
//  UIImage+DownloadButton.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DownloadButton)

+ (UIImage *)stopImageOfSize:(CGFloat)size color:(UIColor *)color;
+ (UIImage *)borderedImageWithFill:(UIColor *)fillColor radius:(CGFloat)radius lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

@end
