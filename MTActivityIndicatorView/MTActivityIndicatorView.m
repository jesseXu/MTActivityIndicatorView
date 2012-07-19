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
}

@property (nonatomic, retain) NSArray *values;

@end


@implementation MTActivityIndicatorView

@synthesize dotColor = _dotColor;
@synthesize values = _values;

- (void)dealloc
{
    [_dotColor release];
    [_values release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //set default color
        self.dotColor           = [UIColor redColor];
        self.backgroundColor    = [UIColor clearColor];
        
        //cal key frame value
        self.values             = [self values];
    }
    return self;
}


#pragma mark - public method

- (void)startAnimating
{
    if (_isAnimating)
        return;
    
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
        [dotMoveKA setValues:self.values];
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
    for (int i = 0; i < 81; i++)
    {
        CGFloat value = [self eval:i*0.1];
        
//        NSLog(@"time:%f s:%f", i * 0.1, value);
        
        [array addObject:[NSNumber numberWithFloat:value]];
    }
    
    return array;
}


#pragma mark - animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_isAnimating)
    {
        [self performSelector:@selector(startAnimatingTransaction) withObject:nil afterDelay:1.0f];
    }
}

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



@end
