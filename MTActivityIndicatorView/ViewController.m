//
//  ViewController.m
//  MTActivityIndicatorView
//
//  Created by jesse on 12-7-19.
//  Copyright (c) 2012年 Jesse Xu. All rights reserved.
//

#import "ViewController.h"
#import "MTActivityIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    MTActivityIndicatorView *aiv = [[MTActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 10.0f)];
    aiv.animationDuration = 4.0f;
    aiv.dotColor = [UIColor whiteColor];
    [self.view addSubview:aiv];
    [aiv release];
    
    [aiv startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
