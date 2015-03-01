//
//  SEGaugeCurveView.h
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEGaugeView.h"

@interface SEGaugeCurveView : SEGaugeView

- (id)initWithFrame:(CGRect)frame
           segments:(NSArray *)segments
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
       numberOfTics:(NSUInteger)tics
numOfTicsInInterval:(NSUInteger)subTics;

@end
