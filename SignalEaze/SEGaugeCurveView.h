//
//  SEGaugeCurveView.h
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEGaugeView.h"

#define kSEGaugeTickHeight          5.0f
#define kSEGaugeTickWidth           5.0f/M_PI
#define kSEGaugeTickWidthMultiplier 3.0f
#define kSEGaugeSectionHeight       10.0f

typedef NS_ENUM(NSUInteger, SEGaugeCurveViewDrawingValue) {
    SEGaugeCurveViewDrawingValuePoint1,
    SEGaugeCurveViewDrawingValuePoint2,
    SEGaugeCurveViewDrawingValuePoint3,
    SEGaugeCurveViewDrawingValuePoint4,
    SEGaugeCurveViewDrawingValueCenter,
    SEGaugeCurveViewDrawingValueAngle1,
    SEGaugeCurveViewDrawingValueAngle2,
    SEGaugeCurveViewDrawingValueNone
};

@interface SEGaugeCurveView : SEGaugeView

@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat radius;

- (id)initWithFrame:(CGRect)frame
           segments:(NSArray *)segments
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue
       numberOfTics:(NSUInteger)tics
            subTics:(NSUInteger)subTics
             radius:(CGFloat)radius;

- (CGFloat)thickness;
- (void)drawViewWithValues:(NSDictionary *)values;
// methods to override
- (void)drawSegments;
- (CGPoint)viewCenter;
- (void)drawTickFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle isLarge:(BOOL)isLarge;
- (CGFloat)angleForValue:(CGFloat)value;
- (CGFloat)valueForAngle:(CGFloat)angle;
- (CGPoint)pointForAngle:(CGFloat)angle radius:(CGFloat)radius;
- (void)drawTics;

@end
