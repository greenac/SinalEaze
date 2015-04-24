//
//  SEGaugeViewController.h
//  SignalEaze
//
//  Created by Andre Green on 2/25/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEGaugeViewController;
@class SEGaugeView, SENeedleView;

#define kSEGaugeVCRadiusModifier    .97f
#define kSEGaugeVCMaxInput          1023

typedef NS_ENUM(NSUInteger, SEGaugeViewControllerId) {
    SEGaugeViewControllerIdTach = 0,
    SEGaugeViewControllerIdFuelLeft,
    SEGaugeViewControllerIdFuelRight,
    SEGaugeViewControllerIdAmps,
    SEGaugeViewControllerIdNone
};

@interface SEGaugeViewController : UIViewController

@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, assign) SEGaugeViewControllerId controllerId;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat minAngle;
@property (nonatomic, assign) CGFloat maxAngle;

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, assign) NSUInteger tics;
@property (nonatomic, assign) NSUInteger subTics;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, assign) CGPoint needlePosition0;
@property (nonatomic, strong) UIView *centerDotView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) uint16_t currentValue;

- (void)updateLabelWithCurrentValue;
- (void)rotateNeedleToCurrentValue;
- (void)rotateNeedleToAngle:(CGFloat)angle;
- (void)moveNeedleToCurrentValue;
- (CGFloat)angleFromDegreesToRadians:(CGFloat)angle;
@end
