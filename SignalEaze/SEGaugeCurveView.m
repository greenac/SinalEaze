//
//  SEGaugeView.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeCurveView.h"
#import <QuartzCore/QuartzCore.h>
#import "SESegment.h"
#import "SENeedleView.h"

#define kSEGagueViewSegmentScaler   .9f

@interface SEGaugeCurveView()

@end

@implementation SEGaugeCurveView

- (id)initWithFrame:(CGRect)frame
           segments:(NSArray *)segments
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
       numberOfTics:(NSUInteger)tics
            subTics:(NSUInteger)subTics
             radius:(CGFloat)radius
             isLeft:(BOOL)isLeft
{
    self = [super initWithFrame:frame
                       minValue:minValue
                       maxValue:maxValue
                           tics:tics
                        subtics:subTics
                       segments:segments
                         isLeft:isLeft];
    
    if (self) {
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (CGFloat)innerRadius
{
    return .4*self.radius;
}

- (CGFloat)arcRadius
{
    return kSEGagueViewSegmentScaler*self.radius;
}

- (CGFloat)thickness
{
    return self.radius - self.innerRadius;
}

- (void)drawViewWithValues:(NSDictionary *)values
{
    NSValue *a = values[@(SEGaugeCurveViewDrawingValuePoint1)];
    NSValue *b = values[@(SEGaugeCurveViewDrawingValuePoint2)];
    NSValue *c = values[@(SEGaugeCurveViewDrawingValuePoint3)];
    NSValue *center = values[@(SEGaugeCurveViewDrawingValueCenter)];
    NSNumber *angle1 = values[@(SEGaugeCurveViewDrawingValueAngle1)];
    NSNumber *angle2 = values[@(SEGaugeCurveViewDrawingValueAngle2)];
    
    [[UIColor whiteColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:a.CGPointValue];
    [path addLineToPoint:b.CGPointValue];
    [path addArcWithCenter:center.CGPointValue
                    radius:self.radius
                startAngle:angle1.doubleValue
                  endAngle:angle2.doubleValue
                 clockwise:NO];
    [path addLineToPoint:c.CGPointValue];
    [path addArcWithCenter:center.CGPointValue
                    radius:self.innerRadius
                startAngle:angle2.doubleValue
                  endAngle:angle1.doubleValue
                 clockwise:YES];
    [path addLineToPoint:a.CGPointValue];
    [path closePath];
    [path fill];
}

- (void)drawSegments
{
    for (SESegment *segment in self.segments) {
        CGFloat startAngle = [self angleForValue:segment.startValue];
        CGFloat endAngle = [self angleForValue:segment.endValue];
        CGFloat arcStartAngle = startAngle + M_PI_2;
        CGFloat arcEndAngle = endAngle + M_PI_2;
        
        [segment.segmentColor setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.0f;
        [path moveToPoint:[self pointForAngle:startAngle radius:self.radius]];
        [path addArcWithCenter:self.viewCenter
                        radius:self.radius
                    startAngle:arcStartAngle
                      endAngle:arcEndAngle
                     clockwise:YES];
        [path addLineToPoint:[self pointForAngle:endAngle radius:self.arcRadius]];
        [path addArcWithCenter:self.viewCenter
                        radius:self.arcRadius
                    startAngle:arcEndAngle
                      endAngle:arcStartAngle
                     clockwise:NO];
        [path addLineToPoint:[self pointForAngle:startAngle radius:self.radius]];
        [path closePath];
        [path fill];
    }
}

- (void)drawTics
{
    [[UIColor grayColor] setFill];
}

- (void)drawTickFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle isLarge:(BOOL)isLarge
{
    CGFloat height = isLarge ? kSEGaugeTickWidthMultiplier*kSEGaugeTickHeight : kSEGaugeTickHeight;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:[self pointForAngle:fromAngle radius:self.radius]];
    [path addLineToPoint:[self pointForAngle:fromAngle radius:self.radius - height]];
    [path addLineToPoint:[self pointForAngle:toAngle radius:self.radius - height]];
    [path addLineToPoint:[self pointForAngle:toAngle radius:self.radius]];
    [path closePath];
    [path fill];
}

- (CGFloat)angleForValue:(CGFloat)value
{
    CGFloat angle = value*M_PI/(self.maxValue - self.minValue);
    return self.isLeft ? angle : 2*M_PI - angle;
}

- (CGFloat)valueForAngle:(CGFloat)angle
{
    return (self.maxValue - self.minValue)*angle/M_PI;
}

- (CGPoint)pointForAngle:(CGFloat)angle radius:(CGFloat)radius
{
    return CGPointMake(self.isLeft ? self.radius - radius*sin(angle) : -radius*sin(angle),
                       self.radius + radius*cos(angle));
}

- (CGPoint)viewCenter
{
    return CGPointMake(self.isLeft ? self.bounds.size.width : 0.0f,
                       .5f*self.bounds.size.height);
}

@end
