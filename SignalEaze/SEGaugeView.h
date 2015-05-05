//
//  SEGaugeView.h
//  SignalEaze
//
//  Created by Andre Green on 2/28/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEGaugeView : UIView

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) NSUInteger tics;
@property (nonatomic, assign) NSUInteger subTics;
@property (nonatomic, assign) BOOL isLeft;

- (id)initWithFrame:(CGRect)frame
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
               tics:(NSUInteger)tics
            subtics:(NSUInteger)subtics
           segments:(NSArray *)segments
             isLeft:(BOOL)isLeft;

- (NSUInteger)numberOfTics;

@end
