//
//  CBCharacteristic+Debug.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <objc/runtime.h>
#import "CBCharacteristic+Debug.h"


@implementation CBCharacteristic (Debug)
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


- (NSString *)propertiesString
{
    NSMutableArray *properties = [NSMutableArray new];

    if (self.properties & CBCharacteristicPropertyBroadcast) {
        [properties addObject:@"Broadcast"];
    }
    if (self.properties & CBCharacteristicPropertyRead) {
        [properties addObject:@"Read"];
    }
    if (self.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [properties addObject:@"WriteWithoutResponse"];
    }
    if (self.properties & CBCharacteristicPropertyWrite) {
        [properties addObject:@"Write"];
    }
    if (self.properties & CBCharacteristicPropertyNotify) {
        [properties addObject:@"Notify"];
    }
    if (self.properties & CBCharacteristicPropertyIndicate) {
        [properties addObject:@"Indicate"];
    }
    if (self.properties & CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [properties addObject:@"AuthenticatedSignedWrites"];
    }
    if (self.properties & CBCharacteristicPropertyExtendedProperties) {
        [properties addObject:@"ExtendedProperties"];
    }
    if (self.properties & CBCharacteristicPropertyNotifyEncryptionRequired) {
        [properties addObject:@"NotifyEncryptionRequired"];
    }
    if (self.properties & CBCharacteristicPropertyIndicateEncryptionRequired) {
        [properties addObject:@"IndicateEncryptionRequired"];
    }
    
    NSString *string = [properties componentsJoinedByString:@", "];
    return string;
}

@end
