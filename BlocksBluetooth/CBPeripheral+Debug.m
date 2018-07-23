//
//  CBPeripheral+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <objc/runtime.h>
#import "CBPeripheral+Debug.h"

@implementation CBPeripheral (Debug)
@dynamic verbose;

- (BOOL)isVerbose {
    return [self.verbose boolValue];
}

- (NSNumber *)verbose {
    return (NSNumber *)objc_getAssociatedObject(self, @selector(verbose));
}

- (void)setVerbose:(NSNumber *)verbose {
    objc_setAssociatedObject(self, @selector(verbose), verbose, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)stateString
{
    switch (self.state) {
        case CBPeripheralStateDisconnected:
            return @"Disconnected";
            
        case CBPeripheralStateConnecting:
            return @"Connecting";

        case CBPeripheralStateConnected:
            return @"Connected";
            
        default:
            return nil;
    }
}

@end
