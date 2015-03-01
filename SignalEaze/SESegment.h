//
//  SESegment.h
//  SignalEaze
//
//  Created by Andre Green on 2/24/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SESegment : NSObject

- (id)initWithColor:(UIColor *)color start:(CGFloat)start end:(CGFloat)end;
+ (id)segmentWithColor:(UIColor *)color start:(CGFloat)start end:(CGFloat)end;
- (CGFloat)startValue;
- (CGFloat)endValue;
- (UIColor *)segmentColor;

@end
