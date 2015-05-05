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






@end
