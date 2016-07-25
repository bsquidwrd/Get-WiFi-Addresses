//
//  AppDelegate.h
//  Get WiFi Addresses
//
//  Created by Brandon Usher on 7/16/14.
//  Copyright (c) 2014 brandonusher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MobileDevice.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    //NSWindow *window;
    IBOutlet NSTextField *deviceDetails;
}

- (void) populateDeviceInfo;
- (void) dePopulateDeviceInfo;
- (NSString *)getDeviceValue:(NSString *)value;
- (IBAction)exportDeviceInfo:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
