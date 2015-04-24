//
//  SEStraitNeedleView.m
//  SignalEaze
//
//  Created by Andre Green on 4/21/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEStraightNeedleView.h"

#define kSEStraitNeedleViewXScaler  .75

@interface SEStraightNeedleView()

@property (nonatomic, assign) BOOL isLeft;

@end

@implementation SEStraightNeedleView

- (id)initWithFrame:(CGRect)frame isLeft:(BOOL)isLeft
{
    self = [super initWithFrame:frame];
    if (self) {
        _isLeft = isLeft;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor setFill];
    
    CGFloat start = self.isLeft ? self.bounds.size.width : 0.0f;
    CGFloat middle = self.isLeft ? (1.0 - kSEStraitNeedleViewXScaler)*self.bounds.size.width : kSEStraitNeedleViewXScaler*self.bounds.size.width;
    CGFloat end = self.isLeft ? 0.0f : self.bounds.size.width;
    
    CGPoint a = CGPointMake(start, self.bounds.size.height);
    CGPoint b = CGPointMake(middle, a.y);
    CGPoint c = CGPointMake(end, .5f*self.bounds.size.height);
    CGPoint d = CGPointMake(middle, 0.0f);
    CGPoint e = CGPointMake(start, d.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:a];
    [path addLineToPoint:b];
    [path addLineToPoint:c];
    [path addLineToPoint:d];
    [path addLineToPoint:e];
    [path addLineToPoint:a];
    
    [path closePath];
    [path fill];
}


@end
