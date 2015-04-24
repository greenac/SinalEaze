//
//  SEBLEInterfaceManager.h
//  SignalEaze
//
//  Created by Andre Green on 4/24/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import QuartzCore;


@interface SEBLEInterfaceMangager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

+ (id)manager;
- (void)runTests;

@end
