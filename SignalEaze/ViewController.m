//
//  ViewController.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "ViewController.h"
#import "SEGaugeViewBackground.h"

#define kPeriphialName  @"Andre's Macbook Pro"

@interface ViewController ()

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *arduinoPeriphial;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *tick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SEGaugeViewBackground *gaugeView = [[SEGaugeViewBackground alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    gaugeView.center = self.view.center;
    
    [self.view addSubview:gaugeView];
//
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
//    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    self.label.center = self.view.center;
//    self.label.text = @"Warming Up...";
//    
//    [self.view addSubview:self.label];
    
//    CGFloat width = .5*self.view.bounds.size.width;
//    CGFloat height = .5*self.view.bounds.size.height;
//    
//    CGRect frame = CGRectMake(.5*(self.view.bounds.size.width - width),
//                              .5*(self.view.bounds.size.height - height),
//                              width,
//                              height);
//    
//    NSLog(@"frame initial: %@", [NSValue valueWithCGRect:frame]);
//          
//    UIView *control = [[UIView alloc] initWithFrame:frame];
//    control.backgroundColor = [UIColor redColor];
//    [self.view addSubview:control];
    
//    self.tick = [[UIView alloc] initWithFrame:frame];
//    self.tick.layer.transform = CATransform3DMakeRotation(45.0*M_PI/180.0,
//                                                          0.0f,
//                                                          0.0f,
//                                                          1.0f);
//    self.tick.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:self.tick];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"frame final: %@", [NSValue valueWithCGRect:self.tick.frame]);
    
    
    //UIView *test = [[UIView alloc] initWithFrame:CGRectMake(self.tick.frame.origin.x, self.tick.frame.origin.y, 10, 10)];
//    UIView *test = [[UIView alloc] initWithFrame:self.tick.frame];
//    test.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:test];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"found periphial named: %@ with advertistment data: %@", peripheral.name, advertisementData.description);
        //if ([localName length] > 0) {
        //[self.centralManager stopScan];
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
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

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

@end
