//
//  AppDelegate.m
//  Get WiFi Addresses
//
//  Created by Brandon Usher on 7/16/14.
//  Copyright (c) 2014 brandonusher. All rights reserved.
//

#import "AppDelegate.h"

static AppDelegate *classPointer;
struct am_device* device;
struct am_device_notification *notification;
NSString *headerString = @"SerialNumber, WiFiAddress";
NSString *completeString = @"";
NSMutableDictionary *dictionary;

void notification_callback(struct am_device_notification_callback_info *info, int cookie) {
	if (info->msg == ADNCI_MSG_CONNECTED) {
		NSLog(@"Device connected.");
		device = info->dev;
		AMDeviceConnect(device);
		AMDevicePair(device);
		AMDeviceValidatePairing(device);
		AMDeviceStartSession(device);
		[classPointer populateDeviceInfo];
	} else if (info->msg == ADNCI_MSG_DISCONNECTED) {
		NSLog(@"Device disconnected.");
		//[classPointer dePopulateData];
	} else {
		NSLog(@"Received device notification: %d", info->msg);
	}
}

void recovery_connect_callback(struct am_recovery_device *rdev) {
    [classPointer populateDeviceInfo];
}

void recovery_disconnect_callback(struct am_recovery_device *rdev) {
    [classPointer dePopulateDeviceInfo];
}

@implementation AppDelegate

//@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    classPointer = self;
    dictionary = [NSMutableDictionary dictionary];
    AMDeviceNotificationSubscribe(notification_callback, 0, 0, 0, &notification);
	AMRestoreRegisterForDeviceNotifications(recovery_disconnect_callback, recovery_connect_callback, recovery_disconnect_callback, recovery_disconnect_callback, 0, NULL);
    [classPointer populateDeviceInfo];
}

- (void)dePopulateDeviceInfo {
    //[deviceDetails setStringValue:headerString];
}

- (void)populateDeviceInfo {
    NSString *serialNumber = [[self getDeviceValue:@"SerialNumber"] uppercaseString];
    NSString *wifiAddress = [[self getDeviceValue:@"WiFiAddress"] uppercaseString];
    
    if(![dictionary objectForKey:serialNumber] && (device != NULL)) {
        [dictionary setObject:wifiAddress forKey:serialNumber];
    }
    
    completeString = [NSString stringWithFormat:@"%@\n", headerString];
    
    for (NSString* key in [dictionary allKeys]) {
        NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
        completeString = [NSString stringWithFormat:@"%@%@, %@\n", completeString, key, [dictionary objectForKey:key]];
    }
    
    [deviceDetails setStringValue:completeString];
    [deviceDetails selectText:self];
}

- (NSString *)getDeviceValue:(NSString *)value {
	return AMDeviceCopyValue(device, 0, value);
}

@end
