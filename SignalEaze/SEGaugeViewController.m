//
//  SEGaugeViewController.m
//  SignalEaze
//
//  Created by Andre Green on 2/25/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeViewController.h"
#import "SEGaugeView.h"
#import "SESegment.h"
#import <QuartzCore/QuartzCore.h>
#import "SENeedleView.h"

//#define kSEGaugeVCRadiusModifier    .95f

@interface SEGaugeViewController ()

@end

@implementation SEGaugeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentValue = 0;
    self.view.frame = self.viewFrame;
    
    self.needlePosition0 = CGPointZero;

    self.centerDotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    self.centerDotView.backgroundColor = kSENeedleViewFillColor;
    self.centerDotView.clipsToBounds = YES;
    self.centerDotView.layer.cornerRadius = self.centerDotView.frame.size.width/2.0f;
    [self.view addSubview:self.centerDotView];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                 0.0f,
                                                                 .75*self.view.bounds.size.width,
                                                                 25.0f)];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont boldSystemFontOfSize:16];
    self.numberLabel.textColor = [UIColor colorWithWhite:.2 alpha:1];
    [self.view addSubview:self.numberLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                               0.0f,
                                                               .75*self.view.bounds.size.width,
                                                               25.0f)];
    self.nameLabel.text = self.displayName;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    [self.view addSubview:self.nameLabel];
}

- (void)updateLabelWithValue:(uint16_t)value
{
    CGFloat displayValue = (self.maxValue - self.minValue)*(CGFloat)value/(CGFloat)kSEGaugeVCMaxInput;
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", displayValue];
}

- (CGFloat)angleFromDegreesToRadians:(CGFloat)angle
{
    return angle*M_PI/180.0;
}


#pragma mark - Virtual methods
- (void)rotateNeedleToCurrentValue
{
    // must be overridden in child class
}

- (void)rotateNeedleToAngle:(CGFloat)angle
{
    // must override in child class
}

- (void)moveNeedleToCurrentValue
{
    // override in straight guage child class
}

@end
