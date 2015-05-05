//
//  ViewController.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "ViewController.h"
#import "SEGaugeViewController.h"
#import "SESegment.h"
#import "SEGaugeCurveView.h"
#import "SEGaugeCircleView.h"
#import "SEGaugeCircleViewController.h"
#import "SEGaugeCurveViewController.h"
#import "SEGaugeStraightViewController.h"
#import "SENotifications.h"
#import "SEBLEInterfaceManager.h"

@interface ViewController() <SEBLEInterfaceManagerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *tick;
@property (nonatomic, strong) NSDictionary *gauges;
@property (nonatomic, strong) SEBLEInterfaceMangager *bleInterfaceManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleInterfaceManager = [SEBLEInterfaceMangager manager];
    self.bleInterfaceManager.delegate = self;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 100)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:self.label];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.1 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGuageValuesWithValues:)
                                                 name:kSENotificationUpdateGuages
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.label.center = self.view.center;
    
    
    //UIView *test = [[UIView alloc] initWithFrame:CGRectMake(self.tick.frame.origin.x, self.tick.frame.origin.y, 10, 10)];
//    UIView *test = [[UIView alloc] initWithFrame:self.tick.frame];
//    test.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:test];
    
    SESegment *segmentTach1 = [SESegment segmentWithColor:[UIColor greenColor] start:1800.0f end:2700.0f];
    SESegment *segmentTach2 = [SESegment segmentWithColor:[UIColor redColor] start:2700.0f end:3000.0f];
    
    SEGaugeCircleViewController *gaugeTach = [SEGaugeCircleViewController new];
    gaugeTach.controllerId = SEGaugeViewControllerIdTach;
    gaugeTach.minValue = 0.0;
    gaugeTach.maxValue = 3000.0;
    gaugeTach.minAngle = 30.0;
    gaugeTach.maxAngle = 330.0;
    gaugeTach.tics = 10;
    gaugeTach.subTics = 3;
    gaugeTach.displayName = NSLocalizedString(@"TACH", nil);
    gaugeTach.segments = @[segmentTach1, segmentTach2];
    
    SESegment *segmentFuel1 = [SESegment segmentWithColor:[UIColor redColor] start:0.0 end:5.0];
    SESegment *segmentFuel2 = [SESegment segmentWithColor:[UIColor yellowColor] start:5.0 end:10];
    SESegment *segmentFuel3 = [SESegment segmentWithColor:[UIColor greenColor] start:5.0 end:23.0];

    NSArray *fuelSegments = @[segmentFuel1, segmentFuel3];

    SEGaugeCurveViewController *fuelGaugeLeft = [SEGaugeCurveViewController new];
    fuelGaugeLeft.controllerId = SEGaugeViewControllerIdFuelLeft;
    fuelGaugeLeft.minValue = 0.0;
    fuelGaugeLeft.maxValue = 23;
    fuelGaugeLeft.minAngle = 30.0;
    fuelGaugeLeft.maxAngle = 330.0;
    fuelGaugeLeft.tics = 8;
    fuelGaugeLeft.subTics = 2;
    fuelGaugeLeft.displayName = NSLocalizedString(@"FUEL LEFT", nil);
    fuelGaugeLeft.segments = fuelSegments;
    fuelGaugeLeft.isLeft = YES;
    
    
    SEGaugeCurveViewController *fuelGaugeRight = [SEGaugeCurveViewController new];
    fuelGaugeRight.controllerId = SEGaugeViewControllerIdFuelRight;
    fuelGaugeRight.minValue = 0;
    fuelGaugeRight.maxValue = 23;
    fuelGaugeRight.minAngle = 30;
    fuelGaugeRight.maxAngle = 330;
    fuelGaugeRight.tics = 8;
    fuelGaugeRight.subTics = 2;
    fuelGaugeRight.displayName = NSLocalizedString(@"FUEL RIGHT", nil);
    fuelGaugeRight.segments = fuelSegments;
    fuelGaugeRight.isLeft = NO;
    
    SESegment *ampSegment1 = [SESegment segmentWithColor:[UIColor redColor] start:0.0 end:9.0];
    SESegment *ampSegment2 = [SESegment segmentWithColor:[UIColor blueColor] start:9.0 end:12.0];
    NSArray *ampSegments = @[ampSegment1, ampSegment2];
    
    SEGaugeStraightViewController *ampMeter = [SEGaugeStraightViewController new];
    ampMeter.controllerId = SEGaugeViewControllerIdAmps;
    ampMeter.isLeft = YES;
    ampMeter.minValue = 0;
    ampMeter.maxValue = 12;
    ampMeter.tics = 12;
    ampMeter.subTics = 2;
    ampMeter.displayName = NSLocalizedString(@"Amps", nil);
    ampMeter.segments = ampSegments;
    
    self.gauges = @{@(SEGaugeViewControllerIdTach):gaugeTach,
                    //@(SEGaugeViewControllerIdFuelLeft):fuelGaugeLeft,
                    @(SEGaugeViewControllerIdFuelRight):fuelGaugeRight,
                    @(SEGaugeViewControllerIdAmps):ampMeter
                    };
    
    NSArray *gaugeOrder = @[@(SEGaugeViewControllerIdTach),
                            //@(SEGaugeViewControllerIdFuelLeft),
                            @(SEGaugeViewControllerIdFuelRight),
                            @(SEGaugeViewControllerIdAmps)
                            ];
    
    static CGFloat diameter = 220.0;
    NSUInteger counter = 0;
    CGPoint start = CGPointMake(10, self.view.center.y - .5*diameter);
    for (NSNumber *controllerId in gaugeOrder) {
        SEGaugeViewController *gvc = self.gauges[controllerId];
        [self addChildViewController:gvc];
        CGFloat gDiameter = gvc.controllerId == SEGaugeViewControllerIdTach ? diameter : .5*diameter;
        gvc.viewFrame = CGRectMake(start.x,
                                   start.y,
                                   gDiameter,
                                   diameter);
        [self.view addSubview:gvc.view];
        [self.view bringSubviewToFront:gvc.view];
        [gvc didMoveToParentViewController:self];
        start = CGPointMake(start.x + 10.0f + gDiameter, start.y);
        counter++;
    }
}

- (void)updateGaugeLabelForId:(SEGaugeViewControllerId)controllerId withValue:(uint16_t)value
{
    SEGaugeViewController *gvc = self.gauges[@(controllerId)];
    gvc.currentValue = value;
    [gvc updateLabelWithCurrentValue];
}

- (void)updateNeedlePositionForId:(SEGaugeViewControllerId)controllerId withValue:(uint16_t)value
{
    SEGaugeViewController *gvc = self.gauges[@(controllerId)];
    gvc.currentValue = value;
    [gvc rotateNeedleToCurrentValue];
}

- (SEGaugeViewControllerId)controllerIdForIndex:(int)index
{
    SEGaugeViewControllerId controllerId;
    switch (index) {
        case 0:
            controllerId = SEGaugeViewControllerIdTach;
            break;
        case 1:
            controllerId = SEGaugeViewControllerIdFuelLeft;
            break;
        case 2:
            controllerId = SEGaugeViewControllerIdFuelRight;
            break;
        default:
            controllerId = SEGaugeViewControllerIdNone;
            break;
    }
    
    return controllerId;
}

- (void)updateGuageValuesWithValues:(NSNotification *)notification
{
    NSArray *values;
    for (int i=0; i < values.count; i++) {
        SEGaugeViewControllerId controllerId = [self controllerIdForIndex:i];
        if (controllerId != SEGaugeViewControllerIdNone) {
            NSNumber *value = values[i];
            [self updateGaugeLabelForId:controllerId withValue:value.intValue];
            [self updateNeedlePositionForId:controllerId withValue:value.intValue];
        }
    }
}

#pragma mark - SEBLEInterfaceManager delegate methods
- (void)bleInterfaceManager:(SEBLEInterfaceMangager *)interfaceManager didUpdateVales:(NSArray *)values
{
    NSLog(@"values in delegate method: %@", values);
}

@end
