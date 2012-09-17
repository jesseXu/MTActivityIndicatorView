//
//  MTActivityIndicatorView.m
//  testAnimation
//
//  Created by jesse on 12-7-5.
//  Copyright (c) 2012年 Jesse Xu. All rights reserved.
//

#import "MTActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

#define kActivityIndicatorDotNumber 5

@interface MTActivityIndicatorView ()
{
    BOOL _isAnimating;
    
    //for calculate key frame value
    CGFloat _v0;
    CGFloat _v1;
    CGFloat _t0;
    CGFloat _t1;
    CGFloat _t2;
    CGFloat _a0;
    CGFloat _a1;
}

@property (nonatomic, retain) NSArray *keyframeValues;

@end


@implementation MTActivityIndicatorView

@synthesize dotColor = _dotColor;
@synthesize keyframeValues = _keyframeValues;

@synthesize animationDuration = _animationDuration;
@synthesize ratioOfMaxAndMinVelocity = _ratioOfMaxAndMinVelocity;
@synthesize accelerateDistance = _accelerateDistance;
@synthesize decelerateDistance = _decelerateDistance;
@synthesize interval = _interval;
@synthesize dotCount = _dotCount;
@synthesize repeated = _repeated;

- (void)dealloc
{
    [_dotColor release];
    [_keyframeValues release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //set default color
        self.backgroundColor            = [UIColor clearColor];
        self.dotColor                   = [UIColor redColor];
        self.dotCount                   = 5;
        self.ratioOfMaxAndMinVelocity   = 10;
        self.accelerateDistance         = 3./8;
        self.decelerateDistance         = 3./8;
        self.interval                   = 1.0f;
        self.repeated                   = YES;
        
        //cal key frame value
//        self.values             = [self values];
    }
    return self;
}


#pragma mark - public method

- (void)startAnimating
{
    if (_isAnimating)
        return;
    
    
    
    self.keyframeValues = [self values];
    
    [self initLayers];
    
    _isAnimating = YES;
    [self startAnimatingTransaction];
}


- (void)startAnimatingTransaction
{
    [CATransaction begin];
    
    CFTimeInterval currentTime = CACurrentMediaTime();
    
    for (int i = 0; i < self.layer.sublayers.count; i++)
    {
        CALayer *layer = [self.layer.sublayers objectAtIndex:i];
        
        CAKeyframeAnimation *dotMoveKA = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        [dotMoveKA setValues:self.keyframeValues];
        [dotMoveKA setDuration:8.0f];
//        [dotMoveKA setRepeatCount:INFINITY];
        [dotMoveKA setSpeed:2];
//        [dotMoveKA setTimeOffset:0.5 * i];
        [dotMoveKA setBeginTime:currentTime + i * 0.3];
        
        if (layer == [self.layer.sublayers lastObject])
        {
            [dotMoveKA setDelegate:self];
        }
        
        [layer addAnimation:dotMoveKA forKey:nil];
    }
    
    [CATransaction commit];
}

- (void)stopAnimating
{
//    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self removeDots];
    _isAnimating = NO;
}

- (void)stopAnimatingNeedDelay:(NSTimeInterval)time
{
    if (time == kMTActivityIndicatorViewCycle)
        _isAnimating = NO;
    else 
    {
        [self performSelector:@selector(removeDots) withObject:nil afterDelay:time];
        _isAnimating = NO;
    }
}

- (BOOL)isAnimating
{
    return _isAnimating;
}


#pragma mark - private method

- (void)initLayers
{
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i = 0; i < kActivityIndicatorDotNumber; i++)
    {
        CALayer *dotLayer = [CALayer layer];
        dotLayer.frame = CGRectMake(-2.0f, 5.0f, 2.0f, 2.0f);
        dotLayer.backgroundColor = self.dotColor.CGColor;
        [self.layer addSublayer:dotLayer];
    }
}

- (void)removeDots
{
    [[self.layer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (NSArray *)values
{
    NSMutableArray *array = [NSMutableArray array];

    //---
    [self evalBasic];
    
    NSInteger length = self.animationDuration / 0.1 + 1;
    for (int i = 0; i < length; i++)
    {
        CGFloat value = [self eval:i*0.1];
        [array addObject:[NSNumber numberWithFloat:value]];
    }
    
    return array;
}


#pragma mark - animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_isAnimating)
    {
        [self performSelector:@selector(startAnimatingTransaction) withObject:nil afterDelay:self.interval];
    }
}


/*

//start speed, can be modified
#define v0 200.0f
//second speed, cannot be modified
#define v1 (220.0f - v0)
//uniform velocity distance
#define sd 80.0
//acceleration
#define a (sTotal - 2 * v0 -sd)

- (CGFloat)eval:(CGFloat)time
{
    CGFloat sTotal = self.frame.size.width;
    
    if (time < 1)
    {
        return v0 * time + 0.5 * a * time * time;
    }
    else if (time < 1 + sd/v1)
    {
        return (sTotal - sd) * 0.5 + v1 * (time - 1);
    }
    else if (time < 2 + sd/v1)
    {
        return (sTotal + sd ) * 0.5 + v1 * (time - 1 - sd/v1) - 0.5 * a * (time - 1 - sd/v1) * (time - 1 - sd/v1);
    }
    else 
    {
        return sTotal + 2.0f;
    }
}

*/

- (CGFloat)eval:(CGFloat)time
{
    if (time < _t0)
    {
        return _v0 * time + 0.5 * _a0 * time * time;
    }
    else if (time < _t1)
    {
//        return _v0 * time +
    }
}


- (void)evalBasic
{
    
    //V1 = (2Ka*S + 2Kd*S + (1 - Ka - Kd)*S*(K + 1))/((K + 1)*Tt)
    
    CGFloat s = self.frame.size.width;
    CGFloat k = self.ratioOfMaxAndMinVelocity;
    CGFloat t = self.animationDuration;
    CGFloat ka = self.accelerateDistance;
    CGFloat kd = self.accelerateDistance;
    
    _v1 = (2*ka*s + 2*kd*s + (1 - ka - kd)*(k + 1))/((k + 1)*t);
    _v0 = k * _v1;
    _t0 = 2 * ka * s / ((k + 1) * _v1);
    _t1 = _t0 + (1 - ka - kd) * s / _v1;
    _t2 = _t1 + 2 * kd * s / ((k + 1) * _v1);
    _a0 = (1 - k) * _v1 / _t0;
    _a1 = (k - 1) * _v1 / (_t2 - _t1);
    
}

@end
