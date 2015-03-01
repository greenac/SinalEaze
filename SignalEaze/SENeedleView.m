//
//  SENeedleView.m
//  SignalEaze
//
//  Created by Andre Green on 2/25/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SENeedleView.h"

@implementation SENeedleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    static CGFloat heightScaler = .05f;
    static CGFloat diamondHeightScaler = .9f;
    
    UIColor *fillColor = kSENeedleViewFillColor;
    [fillColor setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(.3f*rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(.7f*rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, diamondHeightScaler*rect.size.height)];
    [path addLineToPoint:CGPointMake(.5f*rect.size.width + .5f, heightScaler*rect.size.height)];
    [path addLineToPoint:CGPointMake(.5f*rect.size.width - .5f, heightScaler*rect.size.height)];
    [path addLineToPoint:CGPointMake(.0f, diamondHeightScaler*rect.size.height)];
    [path addLineToPoint:CGPointMake(.3f*rect.size.width, rect.size.height)];
    
    [path closePath];
    [path fill];
}


@end
