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

@class SEBLEInterfaceMangager;

@protocol SEBLEInterfaceManagerDelegate <NSObject>

- (void)bleInterfaceManager:(SEBLEInterfaceMangager *)interfaceManager didUpdateVales:(NSArray *)values;

@end

@interface SEBLEInterfaceMangager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, weak) id<SEBLEInterfaceManagerDelegate>delegate;

+ (id)manager;
- (void)runTests;

@end
