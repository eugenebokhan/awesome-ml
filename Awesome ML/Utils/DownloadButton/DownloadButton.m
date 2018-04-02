//
//  DownloadButton.m
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import "DownloadButton.h"
#import "Macros.h"
#import "NSLayoutConstraint+DownloadButton.h"
#import "UIImage+DownloadButton.h"
#import "PendingView.h"

@interface DownloadButton ()

@property (nonatomic, weak) BorderedButton *startDownloadButton;
@property (nonatomic, weak) StopDownloadButton *stopDownloadButton;
@property (nonatomic, weak) BorderedButton *downloadedButton;
@property (nonatomic, weak) PendingView *pendingView;

@property (nonatomic, strong) NSMutableArray *stateViews;

- (BorderedButton *)createStartDownloadButton;
- (StopDownloadButton *)createStopDownloadButton;
- (BorderedButton *)createDownloadedButton;
- (PendingView *)createPendingView;

- (void)currentButtonTapped:(id)sender;

- (void)createSubviews;
- (NSArray *)createConstraints;

@end

static DownloadButton *CommonInit(DownloadButton *self) {
    if (self != nil) {
        [self createSubviews];
        [self addConstraints:[self createConstraints]];
        
        self.state = kDownloadButtonState_StartDownload;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@implementation DownloadButton

#pragma mark - Properties

- (void)setState:(DownloadButtonState)state {
    _state = state;
    
    [self.stateViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SafeObjClassCast(UIView, view, obj);
        view.hidden = YES;
    }];
    
    switch (state) {
        case kDownloadButtonState_StartDownload:
            self.startDownloadButton.hidden = NO;
            break;
        case kDownloadButtonState_Pending:
            self.pendingView.hidden = NO;
            [self.pendingView startSpin];
            break;
        case kDownloadButtonState_Downloading:
            self.stopDownloadButton.hidden = NO;
            self.stopDownloadButton.progress = 0.f;
            break;
        case kDownloadButtonState_Downloaded:
            self.downloadedButton.hidden = NO;
            break;
        default:
            NSAssert(NO, @"unsupported state");
            break;
    }
}

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    return CommonInit([super initWithCoder:decoder]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return CommonInit([super initWithFrame:frame]);
}

- (void)tintColorDidChange {
	[super tintColorDidChange];
	
    [self updateButton:self.startDownloadButton title:[self.startDownloadButton titleForState:UIControlStateNormal] font:self.startDownloadButton.titleLabel.font];
	[self updateButton:self.downloadedButton title:[self.downloadedButton titleForState:UIControlStateNormal] font:self.downloadedButton.titleLabel.font];
}


#pragma mark - appearance

-(void)updateStartDownloadButtonText:(NSString *)title {
    [self updateButton:self.startDownloadButton title:title];
}

-(void)updateDownloadedButtonText:(NSString *)title {
    [self updateButton:self.downloadedButton title:title];
}


-(void)updateStartDownloadButtonText:(NSString *)title font:(UIFont *)font {
    [self updateButton:self.startDownloadButton title:title font: font];
}

-(void)updateDownloadedButtonText:(NSString *)title font:(UIFont *)font {
    [self updateButton:self.downloadedButton title:title font: font];
}


- (void)updateButton:(UIButton *)button title:(NSString *)title {
    [self updateButton:button title:title font:[UIFont systemFontOfSize:14.f]];
}

- (void)updateButton:(UIButton *)button title:(NSString *)title font:(UIFont *)font {
    if (title == nil) {
        title = @"";
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.tintColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    
    button.titleLabel.font = font;
}

#pragma mark - private methods

- (BorderedButton *)createStartDownloadButton {
    BorderedButton *startDownloadButton = [BorderedButton buttonWithType:UIButtonTypeCustom];
    [startDownloadButton configureDefaultAppearance];
    
	[self updateButton:startDownloadButton title:@"DOWNLOAD"];
	
    [startDownloadButton addTarget:self
                            action:@selector(currentButtonTapped:)
                  forControlEvents:UIControlEventTouchUpInside];
    return startDownloadButton;
}

- (StopDownloadButton *)createStopDownloadButton {
    StopDownloadButton *stopDownloadButton = [[StopDownloadButton alloc] init];
    [stopDownloadButton.stopButton addTarget:self action:@selector(currentButtonTapped:)
                            forControlEvents:UIControlEventTouchUpInside];
    return stopDownloadButton;
}

- (BorderedButton *)createDownloadedButton {
    BorderedButton *downloadedButton = [BorderedButton buttonWithType:UIButtonTypeCustom];
    [downloadedButton configureDefaultAppearance];

	[self updateButton:downloadedButton title:@"REMOVE"];
    
    [downloadedButton addTarget:self
                         action:@selector(currentButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
    return downloadedButton;
}

- (PendingView *)createPendingView {
    PendingView *pendingView = [[PendingView alloc] init];
    [pendingView addTarget:self action:@selector(currentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return pendingView;
}

- (void)currentButtonTapped:(id)sender {
    [self.delegate downloadButtonTapped:self currentState:self.state];
    BlockSafeRun(self.callback, self, self.state);
}

- (void)createSubviews {
    self.stateViews = (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
    
    BorderedButton *startDownloadButton = [self createStartDownloadButton];
    startDownloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:startDownloadButton];
    self.startDownloadButton = startDownloadButton;
    [self.stateViews addObject:startDownloadButton];
    
    StopDownloadButton *stopDownloadButton = [self createStopDownloadButton];
    stopDownloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:stopDownloadButton];
    self.stopDownloadButton = stopDownloadButton;
    [self.stateViews addObject:stopDownloadButton];
    
    BorderedButton *downloadedButton = [self createDownloadedButton];
    downloadedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:downloadedButton];
    self.downloadedButton = downloadedButton;
    [self.stateViews addObject:downloadedButton];
    
    PendingView *pendingView = [self createPendingView];
    pendingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pendingView];
    self.pendingView = pendingView;
    [self.stateViews addObject:pendingView];
}

- (NSArray *)createConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    
    [self.stateViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SafeObjClassCast(UIView, view, obj);
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsForWrappedSubview:view
                                                                               withInsets:UIEdgeInsetsZero]];
    }];
    
    return constraints;
}

@end

