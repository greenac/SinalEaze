//
//  SEGaugeCircleView.h
//  SignalEaze
//
//  Created by Andre Green on 2/28/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeCurveView.h"

@interface SEGaugeCircleView : SEGaugeCurveView

- (id)initWithFrame:(CGRect)frame
           segments:(NSArray *)segments
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
           minAngle:(CGFloat)minAngle
           maxAngle:(CGFloat)maxAngle
       numberOfTics:(NSUInteger)tics
numOfTicsInInterval:(NSUInteger)subTics;

@end
