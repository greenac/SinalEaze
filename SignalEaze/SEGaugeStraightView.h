//
//  SEGaugeStraightView.h
//  SignalEaze
//
//  Created by Andre Green on 4/21/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeView.h"

@interface SEGaugeStraightView : SEGaugeView

- (id)initWithFrame:(CGRect)frame
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
               tics:(NSUInteger)tics
            subtics:(NSUInteger)subtics
           segments:(NSArray *)segments
             isLeft:(BOOL)isLeft;

@end
