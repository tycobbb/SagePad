//
//  SagePadConstants.m
//  SagePad
//
//  Created by Matthew Cobb on 11/27/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadConstants.h"
#import <DropboxSDK/DropboxSDK.h>

NSString * const SETTINGS_FILE_NAME = @"settings";
NSString * const SETTINGS_FILE_EXT = @"plist";

// keys for settings.plist
NSString * const SERVER_IP_KEY = @"SP_SERVER_IP_ADDRESS";
NSString * const SERVER_PORT_KEY = @"SP_SERVER_PORT_NUMBER";
NSString * const POINTER_NAME_KEY = @"SP_POINTER_NAME";
NSString * const POINTER_COLOR_KEY = @"SP_POINTER_COLOR";
NSString * const POINTER_SENSITIVITY_KEY = @"SP_POINTER_SENSITIVITY";

// notification names
NSString * const NOTIFY_INPUT = @"SP_NOTIFY_INPUT";
NSString * const NOTIFY_OUTPUT = @"SP_NOTIFY_OUTPUT";
NSString * const NOTIFY_SAGE_CONFIG = @"SP_NOTIFY_SAGE_CONFIG";

// dropbox api constants
NSString * const DROPBOX_KEY = @"5090d932zm4sguc";
NSString * const DROPBOX_SECRET = @"z2dg316hyr49zhw";

@implementation SagePadConstants

@end
