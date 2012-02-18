//
//  SagePadConstants.h
//  SagePad
//
//  Created by Matthew Cobb on 11/27/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SETTINGS_FILE_NAME;
extern NSString * const SETTINGS_FILE_EXT;

// keys for settings.plist
extern NSString * const SERVER_IP_KEY;
extern NSString * const SERVER_PORT_KEY;
extern NSString * const POINTER_NAME_KEY;
extern NSString * const POINTER_COLOR_KEY;
extern NSString * const POINTER_SENSITIVITY_KEY;

// notification names
extern NSString * const NOTIFY_INPUT;
extern NSString * const NOTIFY_OUTPUT;
extern NSString * const NOTIFY_SAGE_CONFIG;

// dropbox api constants
extern NSString * const DROPBOX_KEY;
extern NSString * const DROPBOX_SECRET;
extern NSString * const DROPBOX_ROOT_DIR;

extern NSString * const FILE_TREE_CELL_ID;

extern NSString * const DIRECTORY_EMPTY_SECTION_TITLE; // relocate these
extern NSString * const DIRECTORY_SECTION_TITLE;       // to some content
extern NSString * const FILES_SECTION_TITLE;           // management system

@interface SagePadConstants : NSObject

@end
