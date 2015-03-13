//
//  SEGaugeCurveViewConroller.m
//  SignalEaze
//
//  Created by Andre Green on 3/2/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeCurveViewConroller.h"
#import "SEGaugeCurveView.h"
#import "SEGaugeLeftCurveView.h"
#import "SEGaugeRightCurveView.h"

#define kSEGaugeCurveVCInnerRadiusModifier  .4
#define kSEGaugeCurveVCMaxPoint             CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)
@interface SEGaugeCurveViewConroller ()

@property (nonatomic, strong) SEGaugeCurveView *gaugeView;
@property (nonatomic, strong) UIView *needleView;
@property (nonatomic, assign) CGPoint currentAnchor;
@property (nonatomic, assign) uint16_t currentValue;

@end

@implementation SEGaugeCurveViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentValue = 0;

    self.view.clipsToBounds = YES;
    
    self.view = self.gaugeView;
    
    self.needleView.layer.anchorPoint = CGPointMake(.5, 1.0);

    [self.view addSubview:self.needleView];
    
    self.currentAnchor = kSEGaugeCurveVCMaxPoint;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.needleView.frame = CGRectMake(self.view.bounds.size.width - self.needleView.bounds.size.width,
                                       0.0f,
                                       self.needleView.bounds.size.width,
                                       self.needleView.bounds.size.height);
    
    self.currentValue = 0.0f;
    NSTimer *needleTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                            target:self
                                                          selector:@selector(testNeedle)
                                                          userInfo:nil
                                                           repeats:YES];
    [needleTimer fire];
}

- (SEGaugeCurveView *)gaugeView
{
    if (!_gaugeView) {

        CGFloat width = self.view.frame.size.width;
        CGRect frame = self.view.frame;
        
        if (self.isLeft) {
            _gaugeView = [[SEGaugeLeftCurveView alloc] initWithFrame:frame
                                                            segments:self.segments
                                                            minValue:self.minValue
                                                            maxValue:self.maxValue
                                                        numberOfTics:self.tics
                                                             subTics:self.subTics
                                                              radius:width];
        } else {
            _gaugeView = [[SEGaugeRightCurveView alloc] initWithFrame:frame
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
                                                               self.radius)];
        _needleView.backgroundColor = [UIColor clearColor];
        
        UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     _needleView.bounds.size.width,
                                                                     self.radius - self.innerRadius)];
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

- (void)rotateNeedleToValue:(uint16_t)value
{
    [super rotateNeedleToValue:value];
    
    CGFloat ratio = (CGFloat)value/(CGFloat)kSEGaugeVCMaxInput;
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
    self.currentValue++;
    [self rotateNeedleToValue:self.currentValue];
}

@end
