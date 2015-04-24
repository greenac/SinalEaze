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

#define kPeriphialName  @"SigEazeBLE"
#define kPeriphialUIDD  @"713D0000-503E-4C75-BA94-3148F18D941E"
#define kServiceUIDD    @"713D0002-503E-4C75-BA94-3148F18D941E"

@interface ViewController ()

typedef NS_ENUM(UInt8, SEDataId) {
    SEDataIdNone = 0,
    SEDataIdTach
};

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *arduinoPeriphial;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *tick;
@property (nonatomic, strong) NSDictionary *gauges;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 100)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:self.label];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.1 alpha:1];
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
    fuelGaugeLeft.subTics = 1;
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
    fuelGaugeRight.subTics = 1;
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
                    @(SEGaugeViewControllerIdFuelLeft):fuelGaugeLeft,
                    @(SEGaugeViewControllerIdFuelRight):fuelGaugeRight,
                    @(SEGaugeViewControllerIdAmps):ampMeter
                    };
    
    NSArray *gaugeOrder = @[@(SEGaugeViewControllerIdTach),
                            @(SEGaugeViewControllerIdFuelLeft),
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

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral == self.arduinoPeriphial) {
        NSLog(@"Connected Periphial: %@", self.arduinoPeriphial.name);
        self.arduinoPeriphial.delegate = self;
        [self.arduinoPeriphial discoverServices:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"found periphial named: %@ with advertistment data: %@", peripheral.name, advertisementData.description);
    if (peripheral.name && [peripheral.name isEqualToString:kPeriphialName] && !self.arduinoPeriphial) {
        self.arduinoPeriphial = peripheral;
        self.arduinoPeriphial.delegate = self;
        [self.centralManager connectPeripheral:self.arduinoPeriphial options:nil];
        [self.centralManager stopScan];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    } else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    } else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    } else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    } else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (peripheral == self.arduinoPeriphial) {
        self.arduinoPeriphial = nil;
    }
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"error discovering characteristic for service: %@", error.localizedDescription);
        return;
    } else {
        NSLog(@"service characteristics: %@", service.characteristics);
        
        if (peripheral == self.arduinoPeriphial) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kServiceUIDD]]) {
                    [self.arduinoPeriphial setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    const uint8_t *recievedData = data.bytes;
    uint16_t value = 0;
    NSMutableArray *numbers = [NSMutableArray new];
    
    for (int i=0; i < data.length; i++) {
        //[numbers addObject:@(recievedData[i])];
        uint8_t digit = recievedData[i];
        value += [self value:digit forIndex:i];
        if (i == data.length - 1 || i % 2 == 1) {
            [numbers addObject:@(value)];
            value = 0;
        }
    }
    
//    NSMutableArray *values = [NSMutableArray new];
//    for (int i=0; i < numbers.count; i++) {
//        NSNumber *digitNumber = numbers[i];
//        value += [self value:digitNumber.intValue forIndex:i];
//        if (i == numbers.count - 1 || (i % 2 == 0 && i != 0)) {
//            [values addObject:@(value)];
//            value = 0;
//        }
//    }
    
    [self updateGuageValuesWithValues:numbers];

    NSLog(@"there are %ld sensor values. they are: %@", (long)numbers.count, numbers);
}

- (uint16_t)value:(uint8_t)value forIndex:(int)index
{
    uint16_t returnValue = 0;
    switch (index%2) {
        case 0:
            returnValue = 256*value;
            break;
        case 1:
            returnValue = value;
            break;
        default:
            break;
    }
    
    return returnValue;
}

- (CBUUID *)CBUUIDFromString:(NSString *)CBUUIDString
{
    return [CBUUID UUIDWithString:CBUUIDString];
}

- (NSString *)stringFromCBUUID:(CBUUID *)cbUUID
{
    NSString *CBUUIDString = [NSString stringWithFormat:@"%@", cbUUID];
    return CBUUIDString;
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

- (void)updateGuageValuesWithValues:(NSArray *)values
{
    for (int i=0; i < values.count; i++) {
        SEGaugeViewControllerId controllerId = [self controllerIdForIndex:i];
        if (controllerId != SEGaugeViewControllerIdNone) {
            NSNumber *value = values[i];
            [self updateGaugeLabelForId:controllerId withValue:value.intValue];
            [self updateNeedlePositionForId:controllerId withValue:value.intValue];
        }
    }
}
@end
