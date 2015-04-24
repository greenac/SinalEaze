//
//  SEBLEInterface.m
//  SignalEaze
//
//  Created by Andre Green on 4/24/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEBLEInterfaceManager.h"

@implementation SEBLEInterfaceMangager

+ (id)manager
{
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    static SEBLEInterfaceMangager *bleManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [[self alloc] init];
    });
    
    return bleManager;
}



@end
