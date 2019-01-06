//
//  CBCharacteristic+Blocks.m
//  BlocksBluetooth
//
//  Created by Steve Hales on 1/5/19.
//

#import "CBCharacteristic+Blocks.h"
#import <objc/runtime.h>

@implementation CBCharacteristic (Blocks)
@dynamic updateUseAlways;
    
- (BOOL)isUpdateUseAlways {
    return [self.updateUseAlways boolValue];
}
    
- (NSNumber *)updateUseAlways {
    return (NSNumber *)objc_getAssociatedObject(self, @selector(updateUseAlways));
}
    
- (void)setUpdateUseAlways:(NSNumber *)updateUseAlways {
    objc_setAssociatedObject(self, @selector(updateUseAlways), updateUseAlways, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
    

@end
