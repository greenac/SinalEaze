//
//  SESegment.m
//  SignalEaze
//
//  Created by Andre Green on 2/24/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SESegment.h"

@interface SESegment()

@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat end;
@property (nonatomic, strong) UIColor *color;

@end

@implementation SESegment

- (id)initWithColor:(UIColor *)color start:(CGFloat)start end:(CGFloat)end
{
    self = [super init];
    if (self) {
        _color = color;
        _start = start;
        _end = end;
    }
    
    return self;
}

+ (id)segmentWithColor:(UIColor *)color start:(CGFloat)start end:(CGFloat)end
{
    return [[self alloc] initWithColor:color start:start end:end];
}

- (CGFloat)startValue
{
    return self.start;
}

- (CGFloat)endValue
{
    return self.end;
}

- (UIColor *)segmentColor
{
    return self.color.copy;
}

@end
