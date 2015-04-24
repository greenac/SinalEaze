//
//  SEGaugeStraightView.m
//  SignalEaze
//
//  Created by Andre Green on 4/21/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeStraightView.h"
#import "SESegment.h"

#define kSEGaugeStraitViewMajorTickWidthScaler  .3
#define kSEGaugeStraitViewMinorTickWidthScaler  .15
#define kSEGaugeStraitViewTickHeight       2.0

@interface SEGaugeStraightView()

@property (nonatomic, assign) BOOL isLeft;

@end


@implementation SEGaugeStraightView

- (id)initWithFrame:(CGRect)frame
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
               tics:(NSUInteger)tics
            subtics:(NSUInteger)subtics
           segments:(NSArray *)segments
             isLeft:(BOOL)isLeft
{
    self = [super initWithFrame:frame
                       minValue:minValue
                       maxValue:maxValue
                           tics:tics
                        subtics:subtics
                       segments:segments];
    if (self) {
        _isLeft = isLeft;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawSegments];
    [self drawTicks];
}

- (void)drawSegments
{
    for (SESegment *segment in self.segments) {
        CGFloat start = [self yPositionForValue:segment.startValue];
        CGFloat end = [self yPositionForValue:segment.endValue];
        
        CGPoint a = CGPointMake(0.0f, start);
        CGPoint b = CGPointMake(self.bounds.size.width, a.y);
        CGPoint c = CGPointMake(b.x, end);
        CGPoint d = CGPointMake(a.x, c.y);
        
        [segment.segmentColor setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:a];
        [path addLineToPoint:b];
        [path addLineToPoint:c];
        [path addLineToPoint:d];
        [path addLineToPoint:a];
        
        [path closePath];
        [path fill];
    }
}

- (CGFloat)yPositionForValue:(CGFloat)value
{
    return (1.0 - (value - self.minValue)/(self.maxValue - self.minValue))*self.bounds.size.height;
}

- (void)drawTicks
{
    
    CGFloat x0 = self.isLeft ? 0.0f:self.bounds.size.width;
    CGFloat y = self.bounds.size.height;
    CGFloat ySpacing = self.bounds.size.height/self.numberOfTics;
    UIColor *fillColor = [UIColor grayColor];
    
    for (NSUInteger i = 0; i < self.numberOfTics; i++) {
        
        CGFloat xF = i % self.subTics == 0 ? kSEGaugeStraitViewMajorTickWidthScaler*self.bounds.size.width : kSEGaugeStraitViewMinorTickWidthScaler*self.bounds.size.width;
        
        if (!self.isLeft) {
            xF = x0 - xF;
        }

        CGFloat y1 = y - kSEGaugeStraitViewTickHeight;
        CGPoint a = CGPointMake(x0, y);
        CGPoint b = CGPointMake(xF, y);
        CGPoint c = CGPointMake(xF, y1);
        CGPoint d = CGPointMake(x0, y1);
        
        [fillColor setFill];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:a];
        [path addLineToPoint:b];
        [path addLineToPoint:c];
        [path addLineToPoint:d];
        [path addLineToPoint:a];
        
        [path closePath];
        [path fill];
        
        y = y1 - ySpacing;
    }
}

@end
