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

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat ratioOfMaxAndMinVelocity;
@property (nonatomic, assign) CGFloat accelerateDistance;
@property (nonatomic, assign) CGFloat decelerateDistance;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, assign) NSInteger dotCount;
@property (nonatomic, assign) BOOL repeated;


- (void)startAnimating;
- (void)stopAnimating;
- (void)stopAnimatingNeedDelay:(NSTimeInterval)time;
- (BOOL)isAnimating;

@end
