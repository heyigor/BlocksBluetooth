//
//  CBCentralManager+Blocks.h
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BlocksBluetoothDefinitions.h"
#import "CBPeripheral+Blocks.h"

NS_ASSUME_NONNULL_BEGIN


@interface CBCentralManager (Blocks) <CBCentralManagerDelegate>

/**
 *  Called when the centralManagerDidUpdateState: delegate method is called.
 */
@property (nonatomic, nullable, copy) BBVoidBlock didUpdateState;


#pragma mark - Initializing a Central Manager

/**
 *  Default singleton manager on main queue with default options.
 *
 *  @return Returns the manager singleton.
 */
+ (instancetype)defaultManager;

/**
 *  Same as initWithDelegate:queue: but with the delegate set to self.
 *
 *  @param queue The dispatch queue on which the events will be dispatched.
 *
 *  @return Returns a newly initialized central manager.
 */
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue;

/**
 *  Same as initWithDelegate:queue:options: but with the delegate set to self.
 *
 *  @param queue   The dispatch queue on which the events will be dispatched.
 *  @param options An optional dictionary specifying options for the manager.
 *
 *  @return Returns a newly initialized central manager.
 */
- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue options:(nullable NSDictionary<NSString *, id> *)options;


#pragma mark - Scanning or Stopping Scans of Peripherals

/**
 *  Calls <code>scanForPeripheralsWithServices:options:</code> and uses <code>didDiscover</code> to handle the <code>centralManager:didDiscoverPeripheral:advertisementData:RSSI:</code> callbacks.
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service(s) to scan for.
 *  @param options      An optional dictionary specifying options for the scan.
 *  @param didDiscover  A block to handle the info returned by the <code>centralManager:didDiscoverPeripheral:advertisementData:RSSI:</code> delegate. Because scanning goes on indefinitely, <code>didDiscover</code> is retained and will not be set to nil automatically.
 */
- (void)scanForPeripheralsWithServices:(nullable NSArray *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options didDiscover:(nullable BBPeripheralDiscoverBlock)didDiscover;

/**
 *  Convenient method to <code>stopScan</code> and clear the <code>didDiscover</code> block. If you call <code>stopScan</code> manually, then it's your responsibility to set <code>didDiscover</code> to nil.
 */
- (void)stopScanAndRemoveHandler;

#pragma mark - Misc

/*!
 *  @method retrieveConnectedPeripheralsWithServices
 *
 *  @discussion Retrieves all peripherals that are connected to the system and implement any of the services listed in <i>serviceUUIDs</i>.
 *                Note that this set can include peripherals which were connected by other applications, which will need to be connected locally
 *                via {@link connectPeripheral:options:} before they can be used.
 *
 *   @param didRetrieve  A block to handle the info returned by the <code>centralManager:retrieveConnectedPeripheralsWithServices:serviceUUIDs:</code> delegate.
 *
 *    @return        A list of <code>CBPeripheral</code> objects.
 *
 */
- (NSArray<CBPeripheral *> *)retrieveConnectedPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs willRestore:(nullable BBCentralRestore)willRestore;

#pragma mark - Establishing or Canceling Connections with Peripherals

/**
 *  Block version of connectPeripheral:options:
 *
 *  @param peripheral    The <code>CBPeripheral</code> to be connected.
 *  @param options       An optional dictionary specifying connection behavior options.
 *  @param didConnect    Called when centralManager:didConnectPeripheral: (with an peripheral) or didFailToConnectPeripheral: (with an error) is called. Set to nil afterward.
 *  @param didDisconnect Called when centralManager:didDisconnectPeripheral:error: is called. Set to nil afterward.
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *, id> *)options didConnect:(nullable BBPeripheralBlock)didConnect didDisconnect:(nullable BBPeripheralBlock)didDisconnect;

/**
 *  Block version of cancelPeripheralConnection:
 *
 *  @param peripheral    A <code>CBPeripheral</code>.
 *  @param didDisconnect Called when centralManager:didDisconnectPeripheral:error: is called. Set to nil afterward.
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral didDisconnect:(nullable BBPeripheralBlock)didDisconnect;

@end


NS_ASSUME_NONNULL_END
