//
//  BorderedButton.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderedButton : UIButton

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat lineWidth;

- (void)configureDefaultAppearance;

- (void)cleanDefaultAppearance;

@end
