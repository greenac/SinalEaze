//
//  SEGaugeView.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeView.h"
#import <QuartzCore/QuartzCore.h>
#import "SESegment.h"

#define kSEGaugeMaxTics             10
#define kSEGaugeTicsInInterval      5
#define kSEGaugeStartAngle          30
#define kSEGaugeEndAngle            330
#define kSEGaugeTickHeight          5.0f
#define kSEGaugeTickWidth           2.0f
#define kSEGaugeTickWidthMultiplier 3.0f
#define kSEGaugeSectionHeight       10.0f

@interface SEGaugeView()

@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic, assign) CGPoint gaugeCenter;
@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;

@end

@implementation SEGaugeView

- (id)initWithFrame:(CGRect)frame segments:(NSArray *)segments minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    self = [super initWithFrame:frame];
    if (self) {
        _diameter = frame.size.width;
        _segments = segments;
        _minValue = minValue;
        _maxValue = maxValue;

        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = [self radius];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //[self addTickMarks];
}

- (CGFloat)radius
{
    return .5*self.diameter;
}

- (void)drawRect:(CGRect)rect
{
    [self drawSegments];
    
    CGFloat totalAngle = [self angleFromDegreesToRadians:kSEGaugeEndAngle - kSEGaugeStartAngle];
    NSUInteger numberOfTics = kSEGaugeMaxTics*kSEGaugeTicsInInterval;
    CGFloat angle = [self angleFromDegreesToRadians:kSEGaugeStartAngle];
    CGFloat dThetaTick = kSEGaugeTickWidth/[self radius];
    CGFloat dThetaGap = (totalAngle - numberOfTics*dThetaTick)/numberOfTics;
    
    [[UIColor grayColor] setFill];
    for (NSUInteger i=0; i <= numberOfTics; i++) {
        [self drawTickFromAngle:angle
                        toAngle:angle + dThetaTick
                        isLarge:i % kSEGaugeTicsInInterval == 0];
        
        angle += dThetaTick + dThetaGap;
    }
    
    
}

- (void)drawTickFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle isLarge:(BOOL)isLarge
{
    CGFloat radius = [self radius];
    CGFloat height = isLarge ? kSEGaugeTickWidthMultiplier*kSEGaugeTickHeight : kSEGaugeTickHeight;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[self pointForAngle:fromAngle radius:radius]];
    [path addLineToPoint:[self pointForAngle:fromAngle radius:radius - height]];
    [path addLineToPoint:[self pointForAngle:toAngle radius:radius - height]];
    [path addLineToPoint:[self pointForAngle:toAngle radius:radius]];
    
    [path closePath];
    [path fill];
}

- (CGFloat)range
{
    CGFloat degreeRange = (kSEGaugeEndAngle - kSEGaugeStartAngle);
    return [self angleFromDegreesToRadians:degreeRange];
}

- (CGFloat)angleForValue:(CGFloat)value
{
    return value*[self angleFromDegreesToRadians:[self range]]/(self.maxValue - self.minValue) + [self angleFromDegreesToRadians:kSEGaugeStartAngle];
}

- (CGFloat)valueForAngle:(CGFloat)angle
{
    return (self.maxValue - self.minValue)*angle/[self range] - [self angleFromDegreesToRadians:kSEGaugeStartAngle];
}

- (CGFloat)angleFromDegreesToRadians:(CGFloat)angle
{
    return angle*M_PI/180.0;
}

- (CGPoint)circleCenter
{
    return CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
}

- (CGPoint)pointForAngle:(CGFloat)angle radius:(CGFloat)radius
{
    CGFloat viewRadius = [self radius];
    return CGPointMake(viewRadius - radius*sin(angle), viewRadius + radius*cos(angle));
}

- (void)drawSegments
{
    for (SESegment *segment in self.segments) {
        
        CGFloat startAngle = [self angleForValue:segment.startValue];
        CGFloat endAngle = [self angleForValue:segment.endValue];
        
        [segment.segmentColor setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:[self pointForAngle:startAngle radius:[self radius]]];
        [path addArcWithCenter:[self circleCenter]
                        radius:[self radius]
                    startAngle:startAngle + M_PI_2
                      endAngle:endAngle + M_PI_2
                     clockwise:YES];
        [path addLineToPoint:[self pointForAngle:endAngle radius:[self radius] - kSEGaugeSectionHeight]];
        [path addArcWithCenter:[self circleCenter]
                        radius:[self radius] - kSEGaugeSectionHeight
                    startAngle:endAngle + M_PI_2
                      endAngle:startAngle + M_PI_2
                     clockwise:NO];
        [path addLineToPoint:[self pointForAngle:startAngle radius:[self radius]]];
        
        [path closePath];
        [path fill];
    }
}

@end
