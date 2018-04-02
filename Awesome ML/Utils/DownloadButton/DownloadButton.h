//
//  DownloadButton.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StopDownloadButton.h"
#import "BorderedButton.h"
#import "CircleProgressView.h"
#import "PendingView.h"

typedef NS_ENUM(NSUInteger, DownloadButtonState) {
    kDownloadButtonState_StartDownload,
    kDownloadButtonState_Pending,
    kDownloadButtonState_Downloading,
    kDownloadButtonState_Downloaded
};

@class DownloadButton;

typedef void(^DownloadButtonTappedCallback)(DownloadButton *downloadButton, DownloadButtonState state);

@protocol DownloadButtonDelegate <NSObject>

- (void)downloadButtonTapped:(DownloadButton *)downloadButton
                currentState:(DownloadButtonState)state;

@end

IB_DESIGNABLE
@interface DownloadButton : UIView

@property (nonatomic, weak) IBOutlet id <DownloadButtonDelegate> delegate;
@property (nonatomic, copy) DownloadButtonTappedCallback callback;

@property (nonatomic, weak, readonly) BorderedButton *startDownloadButton;
@property (nonatomic, weak, readonly) StopDownloadButton *stopDownloadButton;
@property (nonatomic, weak, readonly) BorderedButton *downloadedButton;
@property (nonatomic, weak, readonly) PendingView *pendingView;

@property (nonatomic, assign) DownloadButtonState state;

-(void)updateStartDownloadButtonText:(NSString *)title;
-(void)updateDownloadedButtonText:(NSString *)title;
-(void)updateStartDownloadButtonText:(NSString *)title font:(UIFont *)font;
-(void)updateDownloadedButtonText:(NSString *)title font:(UIFont *)font;

@end
