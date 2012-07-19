//
//  MTActivityIndicatorView.h
//  testAnimation
//
//  Created by jesse on 12-7-5.
//  Copyright (c) 2012年 Jesse Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMTActivityIndicatorViewCycle -1

@interface MTActivityIndicatorView : UIView

@property (nonatomic, retain) UIColor *dotColor;

- (void)startAnimating;
- (void)stopAnimating;
- (void)stopAnimatingNeedDelay:(NSTimeInterval)time;
- (BOOL)isAnimating;

@end
