//
//  SEGaugeRightCurveView.m
//  SignalEaze
//
//  Created by Andre Green on 3/13/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeRightCurveView.h"
#import "SESegment.h"

@implementation SEGaugeRightCurveView

- (void)drawRect:(CGRect)rect
{
    CGPoint a, b, c, d, center;
    CGFloat angle1, angle2;
    
    a = CGPointMake(0.0f, self.bounds.size.height - self.innerRadius);
    b = CGPointMake(0.0f, self.bounds.size.height);
    c = CGPointMake(0.0f, self.innerRadius);
    center = CGPointMake(0.0f, .5f*self.bounds.size.height);
    angle1 = M_PI_2;
    angle2 = 3*M_PI_2;
    
    NSDictionary *values = @{@(SEGaugeCurveViewDrawingValuePoint1):[NSValue valueWithCGPoint:a],
                             @(SEGaugeCurveViewDrawingValuePoint2):[NSValue valueWithCGPoint:b],
                             @(SEGaugeCurveViewDrawingValuePoint3):[NSValue valueWithCGPoint:c],
                             @(SEGaugeCurveViewDrawingValuePoint4):[NSValue valueWithCGPoint:d],
                             @(SEGaugeCurveViewDrawingValueCenter):[NSValue valueWithCGPoint:center],
                             @(SEGaugeCurveViewDrawingValueAngle1):@(angle1),
                             @(SEGaugeCurveViewDrawingValueAngle2):@(angle2)
                             };
    
    [self drawViewWithValues:values];
    [self drawSegments];
    [self drawTics];
}

- (void)drawSegments
{
    for (SESegment *segment in self.segments) {
        static CGFloat angleOffset = 3*M_PI_2;
        CGFloat startAngle = [self angleForValue:segment.startValue];
        CGFloat endAngle = [self angleForValue:segment.endValue];
        CGFloat arcStartAngle = startAngle - angleOffset;
        CGFloat arcEndAngle = endAngle - angleOffset;
    
        [segment.segmentColor setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.0f;
        [path moveToPoint:[self pointForAngle:startAngle radius:self.radius]];
        [path addArcWithCenter:self.viewCenter
                        radius:self.radius
                    startAngle:arcStartAngle
                      endAngle:arcEndAngle
                     clockwise:NO];
        [path addLineToPoint:[self pointForAngle:endAngle radius:self.innerRadius]];
        [path addArcWithCenter:self.viewCenter
                        radius:self.innerRadius
                    startAngle:arcEndAngle
                      endAngle:arcStartAngle
                     clockwise:YES];
        [path addLineToPoint:[self pointForAngle:startAngle radius:self.radius]];
        [path closePath];
        [path fill];
    }
}

- (void)drawTics
{
    [super drawTics];
    
    NSUInteger numberOfTics = self.tics*self.subTics;
    CGFloat dThetaTick = kSEGaugeTickWidth/self.radius;
    CGFloat dThetaGap = (M_PI - numberOfTics*dThetaTick)/numberOfTics;
    CGFloat angle = 2*M_PI - dThetaGap;

    for (NSUInteger i=0; i <= numberOfTics; i++) {
        [self drawTickFromAngle:angle
                        toAngle:angle - dThetaTick
                        isLarge:i % self.subTics == 0];
        
        angle += -dThetaTick - dThetaGap;
    }
}

- (CGFloat)angleForValue:(CGFloat)value
{
    CGFloat supersAngle = [super angleForValue:value];
    return 2*M_PI - supersAngle;
}

- (CGPoint)viewCenter
{
    return CGPointMake(0.0f, .5f*self.bounds.size.height);
}

- (CGPoint)pointForAngle:(CGFloat)angle radius:(CGFloat)radius
{
    CGPoint point = CGPointMake(-radius*sin(angle), self.radius + radius*cos(angle));
    return point;
}




@end
