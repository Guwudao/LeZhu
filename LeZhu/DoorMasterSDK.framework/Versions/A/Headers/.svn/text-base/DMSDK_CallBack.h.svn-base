//
//  SDKCallBack.h
//  DoorMasterSDK
//
//  Created by Jason.Huang on 1/30/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>

// Scan device callback object, devDict {device serial number: signal value}. E.g: { "123456": -70, "654321": -72}
typedef void (^BlockOnScanOver)(NSMutableDictionary *devDict);

// Operate the device callback object
typedef void (^BlockOnControlOver)(int ret, NSMutableDictionary *msgDict);

// Bluetooth status change returns
typedef void (^BlockBluetoothStateOver)(int state);

// Initializes the Bluetooth callback object
typedef void (^BlockInitBluetoothOver)(int ret);
