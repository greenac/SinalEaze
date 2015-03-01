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

#define kSEGaugeVCRadiusModifier    .95f
#define kSEGaugeVCMaxInput          1023

@interface SEGaugeViewController ()

@property (nonatomic, strong) SEGaugeView *gaugeView;
@property (nonatomic, strong) SENeedleView *needleView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) CGPoint needlePosition0;
@property (nonatomic, strong) UIView *centerDotView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation SEGaugeViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = self.viewFrame;
    
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
    self.nameLabel.textColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.view addSubview:self.nameLabel];
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
    
    [self.view bringSubviewToFront:self.needleView];
    [self.view bringSubviewToFront:self.centerDotView];
}

- (SEGaugeView *)gaugeView
{
    if (!_gaugeView) {
        CGFloat width = kSEGaugeVCRadiusModifier*self.view.frame.size.width;
        CGFloat height = kSEGaugeVCRadiusModifier*self.view.frame.size.height;
        
        CGRect frame = CGRectMake(.5f*(self.view.bounds.size.width - width),
                                  .5f*(self.view.bounds.size.height - height),
                                  width,
                                  height);
        _gaugeView = [[SEGaugeView alloc] initWithFrame:frame
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
    
    CGRect frame0 = self.needleView.layer.frame;
    
    self.needleView.transform = CGAffineTransformMakeRotation(angle);
    //self.needleView.layer.position = CGPointMake(self.needlePosition0.x, self.needlePosition0.y+ .5*frame0.size.height);
    CGPoint position1 = self.needleView.layer.position;
    
    //self.needleView.layer.position = CGPointMake(150, 200);
    //self.needleView.layer.position = CGPointMake(position.x + width*cos(angle), position.y + width*sin(angle));
    
//    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
//                                   view.bounds.size.height * anchorPoint.y);
//    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
//                                   view.bounds.size.height * view.layer.anchorPoint.y);
//    
//    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
//    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
//    
//    CGPoint position = view.layer.position;
//    
//    position.x -= oldPoint.x;
//    position.x += newPoint.x;
//    
//    position.y -= oldPoint.y;
//    position.y += newPoint.y;
//    
//    view.layer.position = position;
//    view.layer.anchorPoint = anchorPoint;
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
@end
