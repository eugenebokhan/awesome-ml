//
//  CALayer+DownloadButtonAnimations.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (DownloadButtonAnimations)

- (void)addRotationAnimationWithKey:(NSString *)animationKey
               fullRotationDuration:(NSTimeInterval)fullRotationDuration;
- (void)removeRotationAnimationWithKey:(NSString *)animationKey;
- (void)removeRotationAnimationWithKey:(NSString *)animationKey
                  fullRotationDuration:(NSTimeInterval)fullRotationDuration;

@end
