//
//  SEGaugeViewController.h
//  SignalEaze
//
//  Created by Andre Green on 2/25/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SEGaugeViewController;

typedef NS_ENUM(NSUInteger, SEGaugeViewControllerId) {
    SEGaugeViewControllerIdTach = 0,
    SEGaugeViewControllerIdFuelLeft,
    SEGaugeViewControllerIdFuelRight,
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

- (void)updateLabelWithValue:(uint16_t)value;
- (void)rotateNeedleToValue:(uint16_t)value;
@end
