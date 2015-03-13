//
//  SEGaugeCircleViewController.m
//  SignalEaze
//
//  Created by Andre Green on 3/2/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeCircleViewController.h"
#import "SEGaugeCircleView.h"
#import "SENeedleView.h"




@interface SEGaugeCircleViewController ()

@property (nonatomic, strong) SEGaugeCircleView *gaugeView;
@property (nonatomic, strong) SENeedleView *needleView;

@end

@implementation SEGaugeCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = .5f*self.view.frame.size.width;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
    
    [self.view addSubview:self.gaugeView];
    
    self.needleView = [[SENeedleView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     7.0f,
                                                                     .49f*self.view.frame.size.height)];
    self.needleView.layer.anchorPoint = CGPointMake(.5, 1.0);
    [self.view addSubview:self.needleView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.needleView.frame = CGRectMake((self.view.frame.size.width - self.needleView.frame.size.width)/2.0f,
                                       self.view.frame.size.height/2.0f - self.needleView.frame.size.height,
                                       self.needleView.frame.size.width,
                                       self.needleView.frame.size.height);
    
    self.centerDotView.frame = CGRectMake(.5*(self.view.bounds.size.width - self.centerDotView.bounds.size.width),
                                          .5*(self.view.bounds.size.height - self.centerDotView.bounds.size.height),
                                          self.centerDotView.bounds.size.width,
                                          self.centerDotView.bounds.size.height);
    
    self.numberLabel.frame = CGRectMake(.5*(self.view.bounds.size.width - self.numberLabel.frame.size.width),
                                        self.view.bounds.size.height - 1.2*self.numberLabel.bounds.size.height,
                                        self.numberLabel.bounds.size.width,
                                        self.numberLabel.bounds.size.height);
    
    self.nameLabel.frame = CGRectMake(.5*(self.view.bounds.size.width - self.nameLabel.frame.size.width),
                                      self.numberLabel.frame.origin.y - 2*self.nameLabel.frame.size.height,
                                      self.nameLabel.bounds.size.width,
                                      self.nameLabel.bounds.size.height);
    
    [self.view bringSubviewToFront:self.nameLabel];
    [self.view bringSubviewToFront:self.needleView];
    [self.view bringSubviewToFront:self.centerDotView];
}

- (SEGaugeCircleView *)gaugeView
{
    if (!_gaugeView) {
        CGFloat width = kSEGaugeVCRadiusModifier*self.view.frame.size.width;
        CGFloat height = kSEGaugeVCRadiusModifier*self.view.frame.size.height;
        
        CGRect frame = CGRectMake(.5f*(self.view.bounds.size.width - width),
                                  .5f*(self.view.bounds.size.height - height),
                                  width,
                                  height);
        _gaugeView = [[SEGaugeCircleView alloc] initWithFrame:frame
                                                     segments:self.segments
                                                     minValue:self.minValue
                                                     maxValue:self.maxValue
                                                     minAngle:self.minAngle
                                                     maxAngle:self.maxAngle
                                                 numberOfTics:self.tics
                                          numOfTicsInInterval:self.subTics];
    }
    
    return _gaugeView;
}

- (void)rotateNeedleToValue:(uint16_t)value
{
    CGFloat ratio = (CGFloat)value/(CGFloat)kSEGaugeVCMaxInput;
    CGFloat theta = ratio*[self angleFromDegreesToRadians:self.maxAngle - self.minAngle] - M_PI +[self angleFromDegreesToRadians:self.minAngle];
    
    [self rotateNeedleToAngle:theta];
}

- (void)rotateNeedleToAngle:(CGFloat)angle
{
    if (CGPointEqualToPoint(self.needlePosition0, CGPointZero)) {
        self.needlePosition0 = self.needleView.layer.position;
    }

    self.needleView.transform = CGAffineTransformMakeRotation(angle);
}

- (void)updateLabelWithValue:(uint16_t)value
{
    CGFloat displayValue = (self.maxValue - self.minValue)*(CGFloat)value/(CGFloat)kSEGaugeVCMaxInput;
    self.numberLabel.text = [NSString stringWithFormat:@"%.0f", displayValue];
}

@end
