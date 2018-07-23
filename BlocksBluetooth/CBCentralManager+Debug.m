//
//  CBCentralManager+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <objc/runtime.h>
#import "CBCentralManager+Debug.h"

@implementation CBCentralManager (Debug)
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
        case CBCentralManagerStateUnknown:
            return @"Unknown";
            
        case CBCentralManagerStateResetting:
            return @"Resetting";
            
        case CBCentralManagerStateUnsupported:
            return @"Unsupported";
            
        case CBCentralManagerStateUnauthorized:
            return @"Unauthorized";
            
        case CBCentralManagerStatePoweredOff:
            return @"PoweredOff";
            
        case CBCentralManagerStatePoweredOn:
            return @"PoweredOn";
            
        default:
            return nil;
    }
}

@end
