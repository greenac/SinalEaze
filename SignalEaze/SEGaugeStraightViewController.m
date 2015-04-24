//
//  SEGaugeStraightViewController.m
//  SignalEaze
//
//  Created by Andre Green on 4/21/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeStraightViewController.h"
#import "SEStraightNeedleView.h"
#import "SEGaugeStraightView.h"

@interface SEGaugeStraightViewController ()

@property (nonatomic, strong) SEStraightNeedleView *needleView;
@property (nonatomic, strong) SEGaugeStraightView *gaugeView;

@end

@implementation SEGaugeStraightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.gaugeView;
    
    [self.view addSubview:self.needleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat x0 = self.isLeft ? self.view.bounds.size.width - self.needleView.bounds.size.width : 0.0f;
    self.needleView.frame = CGRectMake(x0,
                                       self.view.bounds.size.height - self.needleView.bounds.size.height - 10,
                                       self.needleView.bounds.size.width,
                                       self.needleView.bounds.size.height);
    
    
    [self.view bringSubviewToFront:self.needleView];
    
    NSTimer *needleTimer = [NSTimer scheduledTimerWithTimeInterval:.05
                                                            target:self
                                                          selector:@selector(testNeedle)
                                                          userInfo:nil
                                                           repeats:YES];
    [needleTimer fire];
}


- (SEStraightNeedleView *)needleView
{
    if (!_needleView) {
        _needleView = [[SEStraightNeedleView alloc] initWithFrame:CGRectMake(0.0f,
                                                                             0.0f,
                                                                             .9f*self.view.bounds.size.width,
                                                                             3.0f)
                                                           isLeft:self.isLeft];
    }
    
    return _needleView;
}

- (SEGaugeStraightView *)gaugeView
{
    if (!_gaugeView) {
        _gaugeView = [[SEGaugeStraightView alloc] initWithFrame:self.view.frame
                                                       minValue:self.minValue
                                                       maxValue:self.maxValue
                                                           tics:self.tics
                                                        subtics:self.subTics
                                                       segments:self.segments
                                                         isLeft:self.isLeft];
    }
    
    return _gaugeView;
}

- (CGFloat)yPositionForValue:(uint16_t)value
{
    return self.view.bounds.size.height - self.view.bounds.size.height/1023*value;
}

- (void)moveNeedleToCurrentValue
{
    self.needleView.frame = CGRectMake(self.needleView.frame.origin.x,
                                       [self yPositionForValue:self.currentValue],
                                       self.needleView.bounds.size.width,
                                       self.needleView.bounds.size.height);
}

- (void)testNeedle
{
    self.currentValue = self.currentValue + 5 <= 1023 ? self.currentValue + 5 : 0;
    [self moveNeedleToCurrentValue];
}

@end
