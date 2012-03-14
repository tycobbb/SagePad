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

typedef enum SAGE_MSG_SIZE {
    SML_MSG_SIZE = 128,
    LRG_MSG_SIZE = 1280
} SAGE_MSG_SIZE;

// from SAGENext -- see commondefinitions.h
typedef enum MEDIA_TYPE { 
    MEDIA_TYPE_UNKNOWN = 100, 
    MEDIA_TYPE_IMAGE = 101, 
    MEDIA_TYPE_VIDEO, 
    MEDIA_TYPE_LOCAL_VIDEO, 
    MEDIA_TYPE_AUDIO, 
    MEDIA_TYPE_PLUGIN, 
    MEDIA_TYPE_VNC, 
    MEDIA_TYPE_WEBURL, 
    MEDIA_TYPE_PDF,
    MEDIA_TYPE_SAGE_STREAM
} MEDIA_TYPE;

// from SAGENext -- see uiserver.h
typedef enum EXTUI_MSG_TYPE { 
    MSG_NULL, 
    REG_FROM_UI, 
    ACK_FROM_WALL, 
    DISCONNECT_FROM_WALL, 
    WALL_IS_CLOSING, 
    TOGGLE_APP_LAYOUT, 
    RESPOND_APP_LAYOUT,
    VNC_SHARING, 
    POINTER_PRESS,
    POINTER_RIGHTPRESS,
    POINTER_RELEASE, 
    POINTER_RIGHTRELEASE, 
    POINTER_CLICK, 
    POINTER_RIGHTCLICK, 
    POINTER_DOUBLECLICK, 
    POINTER_DRAGGING, 
    POINTER_RIGHTDRAGGING, 
    POINTER_MOVING, 
    POINTER_SHARE, 
    POINTER_WHEEL, 
    POINTER_UNSHARE,
    WIDGET_Z, 
    WIDGET_REMOVE, 
    WIDGET_CHANGE
} EXTUI_MSG_TYPE;

// from SAGENext -- see uiserver.h
typedef enum EXTUI_TRANSFER_MODE {
    FILE_TRANSFER, 
    FILE_STREAM, 
    PIXEL_STREAM 
} EXTUI_TRANSFER_MODE;

@interface SagePadConstants : NSObject

@end
