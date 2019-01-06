//
//  CBCharacteristic+Blocks.h
//  BlocksBluetooth
//
//  Created by Steve Hales on 1/5/19.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBCharacteristic (Blocks)
@property (nonatomic, copy) NSNumber *updateUseAlways;
    
- (BOOL)isUpdateUseAlways;
@end

NS_ASSUME_NONNULL_END
