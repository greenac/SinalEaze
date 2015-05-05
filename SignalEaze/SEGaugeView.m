//
//  SEGaugeView.m
//  SignalEaze
//
//  Created by Andre Green on 2/28/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeView.h"

@implementation SEGaugeView

- (id)initWithFrame:(CGRect)frame
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
               tics:(NSUInteger)tics
            subtics:(NSUInteger)subtics
           segments:(NSArray *)segments
             isLeft:(BOOL)isLeft
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = minValue;
        _maxValue = maxValue;
        _tics = tics;
        _subTics = subtics;
        _segments = segments;
        _isLeft = isLeft;
    }
    
    return self;
}

- (NSUInteger)numberOfTics
{
    return self.tics*self.subTics;
}

@end
