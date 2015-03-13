//
//  SEGaugeLeftCurveView.m
//  SignalEaze
//
//  Created by Andre Green on 3/13/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeLeftCurveView.h"

@implementation SEGaugeLeftCurveView

- (void)drawRect:(CGRect)rect
{
    CGPoint a, b, c, d, center;
    CGFloat angle1, angle2;
    
    [[UIColor blueColor] setFill];
    
    a = CGPointMake(self.bounds.size.width, self.bounds.size.height - self.innerRadius);
    b = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    c = CGPointMake(b.x, self.innerRadius);
    center = CGPointMake(self.bounds.size.width, .5f*self.bounds.size.height);
    angle1 = 3*M_PI_2;
    angle2 = M_PI_2;
    
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

- (void)drawViewWithValues:(NSDictionary *)values
{
    [super drawViewWithValues:values];
}

- (CGPoint)viewCenter
{
    return CGPointMake(self.bounds.size.width, .5f*self.bounds.size.height);
}

@end
