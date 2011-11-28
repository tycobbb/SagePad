//
//  SagePadSettings.m
//  SagePad
//
//  Created by Matthew Cobb on 11/27/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadSettings.h"
#import "SagePadConstants.h"

@implementation SagePadSettings

@synthesize ipAddress;
@synthesize portNumber;
@synthesize pointerName;
@synthesize pointerColor;
@synthesize sensitivity;

// --- "private" helper methods ---
+ (NSString *)getAppLibraryPath {
    NSString *libraryRoot = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.%@", libraryRoot, SETTINGS_FILE_NAME, SETTINGS_FILE_EXT];
}

// --- "public" methods ---

- (id)init
{
    self = [super init];
    if (self) {
        [self refreshSettings];
    }
    
    return self;
}

+ (NSMutableDictionary *)initDictionary {
    NSString *readPath = [SagePadSettings getAppLibraryPath];
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:readPath];
    if(settings == nil) {
        readPath = [[NSBundle mainBundle] pathForResource:SETTINGS_FILE_NAME ofType:SETTINGS_FILE_EXT];
        settings = [[NSMutableDictionary alloc] initWithContentsOfFile:readPath];
    }
    NSLog(@"Read path: %@", readPath);
    return settings;
}

+ (void)writeSettingsDictionary:(NSMutableDictionary *)settings {
    [settings writeToFile:[SagePadSettings getAppLibraryPath] atomically:YES];
}

- (void)refreshSettings {
    NSMutableDictionary *settings = [SagePadSettings initDictionary];
    
    ipAddress = [settings valueForKey:SERVER_IP_KEY];
    portNumber = [settings valueForKey:SERVER_PORT_KEY];
    
    pointerName = [settings valueForKey:POINTER_NAME_KEY];
    pointerColor = [settings valueForKey:POINTER_COLOR_KEY];
    sensitivity = [settings valueForKey:POINTER_SENSITIVITY_KEY];
    
    [settings release];
}

- (void)writeValue:(id)value forKey:(NSString *)key {
    NSMutableDictionary *settings = [SagePadSettings initDictionary];
    [settings writeToFile:[SagePadSettings getAppLibraryPath] atomically:YES];
    [settings release];
}

@end
