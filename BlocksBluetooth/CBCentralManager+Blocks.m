//
//  CBCentralManager+Blocks.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/22/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "CBCentralManager+Blocks.h"
#import <objc/runtime.h>
#import "CBCentralManager+Debug.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - CBCentralManager Private Properties

@interface CBCentralManager (_Blocks)
@property (nonatomic, nullable, copy) BBPeripheralDiscoverBlock didDiscoverPeripheral;
@property (nonatomic, nullable, copy) BBCentralRestore willRestore;
@end


@implementation CBCentralManager (_Blocks)

- (nullable BBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    return (BBPeripheralDiscoverBlock)objc_getAssociatedObject(self, @selector(didDiscoverPeripheral));
}

- (void)setDidDiscoverPeripheral:(nullable BBPeripheralDiscoverBlock)didDiscoverPeripheral
{
    objc_setAssociatedObject(self, @selector(didDiscoverPeripheral), didDiscoverPeripheral, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (nullable BBCentralRestore)willRestore
{
    return (BBCentralRestore)objc_getAssociatedObject(self, @selector(willRestore));
}

- (void)setWillRestore:(nullable BBCentralRestore)willRestore
{
    objc_setAssociatedObject(self, @selector(willRestore), willRestore, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end



#pragma mark - CBCentralManager

@implementation CBCentralManager (Blocks)

- (nullable BBVoidBlock)didUpdateState
{
    return (BBVoidBlock)objc_getAssociatedObject(self, @selector(didUpdateState));
}

- (void)setDidUpdateState:(nullable BBVoidBlock)didUpdateState
{
    objc_setAssociatedObject(self, @selector(didUpdateState), didUpdateState, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - Initializing a Central Manager

+ (instancetype)defaultManager
{
    static CBCentralManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[CBCentralManager alloc] initWithQueue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
    });
    return _defaultManager;
}

- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue
{
    self = [self initWithDelegate:self queue:queue];
    return self;
}

- (instancetype)initWithQueue:(nullable dispatch_queue_t)queue options:(nullable NSDictionary<NSString *, id> *)options
{
    self = [self initWithDelegate:self queue:queue options:options];
    return self;
}


#pragma mark - Scanning or Stopping Scans of Peripherals

- (void)scanForPeripheralsWithServices:(nullable NSArray *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options didDiscover:(nullable BBPeripheralDiscoverBlock)didDiscover
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.didDiscoverPeripheral = didDiscover;
    [self scanForPeripheralsWithServices:serviceUUIDs options:options];
}

- (void)stopScanAndRemoveHandler
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    [self stopScan];
    self.didDiscoverPeripheral = nil;
}


#pragma mark - Establishing or Canceling Connections with Peripherals

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *, id> *)options didConnect:(nullable BBPeripheralBlock)didConnect didDisconnect:(nullable BBPeripheralBlock)didDisconnect
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    peripheral.didConnect = didConnect;
    peripheral.didDisconnect = didDisconnect;
    [self connectPeripheral:peripheral options:options];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral didDisconnect:(nullable BBPeripheralBlock)didDisconnect
{
    if (self.delegate != self) {
        self.delegate = self;
    }
    peripheral.didDisconnect = didDisconnect;
    [self cancelPeripheralConnection:peripheral];
}

#pragma mark - Misc
- (NSArray<CBPeripheral *> *)retrieveConnectedPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs willRestore:(nullable BBCentralRestore)willRestore
{
    if ([self isVerbose]) {
        NSLog(@"retrieveConnectedPeripheralsWithServices");
    }
    if (self.delegate != self) {
        self.delegate = self;
    }
    self.willRestore = willRestore;
    return [self retrieveConnectedPeripheralsWithServices: serviceUUIDs];
}

#pragma mark - Central Manager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([self isVerbose]) {
        NSLog(@"centralManagerDidUpdateState: %@", central.stateString);
    }
    if (self.didUpdateState) {
        self.didUpdateState();
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([self isVerbose]) {
        NSLog(@"Discovered %@", peripheral);
    }
    if (self.didDiscoverPeripheral) {
        self.didDiscoverPeripheral(peripheral, advertisementData, RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([self isVerbose]) {
        NSLog(@"Peripheral connected: %@", peripheral);
    }
    if (peripheral.didConnect) {
        peripheral.didConnect(peripheral, nil);
        peripheral.didConnect = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if ([self isVerbose]) {
        NSLog(@"didFailToConnectPeripheral: %@", error);
    }
    if (peripheral.didConnect) {
        peripheral.didConnect(nil, error);
        peripheral.didConnect = nil;
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if ([self isVerbose]) {
        NSLog(@"didDisconnectPeripheral: %@, %@", peripheral, error);
    }
    if (peripheral.didDisconnect) {
        peripheral.didDisconnect(peripheral, error);
        peripheral.didDisconnect = nil;
    }
}

/*!
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict            A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion            For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *                        the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *                        Bluetooth system.
 *
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
 *
 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict
{
    if ([self isVerbose]) {
        NSLog(@"willRestoreState: %@", dict);
    }
    if (self.willRestore) {
        self.willRestore(central, dict);
    }
}


@end


NS_ASSUME_NONNULL_END
