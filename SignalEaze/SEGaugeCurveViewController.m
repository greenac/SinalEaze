//
//  SEGaugeCurveViewController.m
//  SignalEaze
//
//  Created by Andre Green on 3/2/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeCurveViewController.h"
#import "SEGaugeCurveView.h"
#import "SEGaugeLeftCurveView.h"
#import "SEGaugeRightCurveView.h"

#define kSEGaugeCurveVCInnerRadiusModifier  .4
#define kSEGaugeCurveVCMaxPoint             CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)

@interface SEGaugeCurveViewController ()

@property (nonatomic, strong) SEGaugeCurveView *gaugeView;
@property (nonatomic, strong) UIView *needleView;
@property (nonatomic, assign) CGPoint currentAnchor;


@end

@implementation SEGaugeCurveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    self.view = self.gaugeView;
    
    self.needleView.layer.anchorPoint = CGPointMake(.5, 1.0);

    [self.view addSubview:self.needleView];
    
    self.currentAnchor = kSEGaugeCurveVCMaxPoint;
    
    CGSize nameSize = [self.displayName sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    
    self.nameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.9f];
    self.nameLabel.font = [self.nameLabel.font fontWithSize:12.0f];
    self.nameLabel.textAlignment = self.isLeft ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 2;
    if (![self.view.subviews containsObject:self.nameLabel]) {
        [self.view addSubview:self.nameLabel];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    CGFloat needleX0 = self.isLeft ? self.view.bounds.size.width - self.needleView.bounds.size.width:0.0f;
    self.needleView.frame = CGRectMake(needleX0,
                                       .5*self.view.bounds.size.height - self.needleView.bounds.size.height,
                                       self.needleView.bounds.size.width,
                                       self.needleView.bounds.size.height);
    
    CGFloat nameLabelX0 = self.isLeft ? self.view.bounds.size.width - self.nameLabel.bounds.size.width : 0.0f;
    CGFloat nameLabelY0 = self.view.bounds.size.height - self.radius - 2*self.innerRadius;
    
    self.nameLabel.frame = CGRectMake(nameLabelX0,
                                      nameLabelY0,
                                      self.nameLabel.frame.size.width,
                                      self.nameLabel.frame.size.height);
    
    self.currentValue = 0.0f;
    
    NSTimer *needleTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                            target:self
                                                          selector:@selector(testNeedle)
                                                          userInfo:nil
                                                           repeats:YES];
    [needleTimer fire];
    
    //self.nameLabel.frame = CGRectMake(0, 0, self.nameLabel.bounds.size.width, self.nameLabel.bounds.size.height);
}

- (SEGaugeCurveView *)gaugeView
{
    if (!_gaugeView) {

        CGFloat width = self.view.frame.size.width;
        if (self.isLeft) {
            _gaugeView = [[SEGaugeLeftCurveView alloc] initWithFrame:self.view.frame
                                                            segments:self.segments
                                                            minValue:self.minValue
                                                            maxValue:self.maxValue
                                                        numberOfTics:self.tics
                                                             subTics:self.subTics
                                                              radius:width];
        } else {
            _gaugeView = [[SEGaugeRightCurveView alloc] initWithFrame:self.view.frame
                                                             segments:self.segments
                                                             minValue:self.minValue
                                                             maxValue:self.maxValue
                                                         numberOfTics:self.tics
                                                              subTics:self.subTics
                                                               radius:width];
        }
    }
    
    return _gaugeView;
}

- (UIView *)needleView
{
    if (!_needleView) {
        _needleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                               0.0f,
                                                               3.0f,
                                                               .95*self.radius)];
        _needleView.backgroundColor = [UIColor clearColor];
        
        UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     _needleView.bounds.size.width,
                                                                     _needleView.bounds.size.height - self.innerRadius)];
        outerView.backgroundColor = [UIColor whiteColor];
        
        UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     outerView.bounds.size.height,
                                                                     outerView.bounds.size.width,
                                                                     self.innerRadius)];
        innerView.backgroundColor = [UIColor clearColor];
        
        [_needleView addSubview:outerView];
        [_needleView addSubview:innerView];
    }
    
    return _needleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)innerRadius
{
    return kSEGaugeCurveVCInnerRadiusModifier*[self radius];
}

- (CGFloat)radius
{
    return self.view.bounds.size.width;
}

- (void)rotateNeedleToAngle:(CGFloat)angle
{
    [super rotateNeedleToAngle:angle];
    self.needleView.transform = CGAffineTransformMakeRotation(angle);
}

- (void)rotateNeedleToCurrentValue
{
    [super rotateNeedleToCurrentValue];
    
    CGFloat ratio = (CGFloat)self.currentValue/(CGFloat)kSEGaugeVCMaxInput;
    //CGFloat theta = ratio*[self angleFromDegreesToRadians:self.maxAngle - self.minAngle] - M_PI +[self angleFromDegreesToRadians:self.minAngle];
    CGFloat theta = (1.0 - ratio)*M_PI;
    
    [self rotateNeedleToAngle:self.isLeft ? -theta:theta];
}

- (CGPoint)anchorPointForAngle:(CGFloat)angle
{
    return CGPointMake(self.radius + self.innerRadius*cos(angle),
                       self.radius - self.innerRadius*sin(angle));
}

- (void)testNeedle
{
    self.currentValue += 5;
    [self rotateNeedleToCurrentValue];
}

@end
