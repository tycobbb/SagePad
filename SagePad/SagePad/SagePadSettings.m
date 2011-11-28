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
@synthesize dictionary;

// --- "private" helper methods ---
- (NSString *)getAppLibraryPath {
    NSString *libraryRoot = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@.%@", libraryRoot, SETTINGS_FILE_NAME, SETTINGS_FILE_EXT];
}

- (void)refreshDictionary {
    if(dictionary != nil) [dictionary release];
    
    NSString *readPath = [self getAppLibraryPath];
    dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:readPath];
    if(dictionary == nil) {
        readPath = [[NSBundle mainBundle] pathForResource:SETTINGS_FILE_NAME ofType:SETTINGS_FILE_EXT];
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:readPath];
    }
    NSLog(@"Read path: %@", readPath);
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

- (void)refreshSettings {
    [self refreshDictionary];
    
    ipAddress = [dictionary valueForKey:SERVER_IP_KEY];
    portNumber = [dictionary valueForKey:SERVER_PORT_KEY];
    
    pointerName = [dictionary valueForKey:POINTER_NAME_KEY];
    pointerColor = [dictionary valueForKey:POINTER_COLOR_KEY];
    sensitivity = [dictionary valueForKey:POINTER_SENSITIVITY_KEY];
}

- (void)writeCurrentDictionary {
    [dictionary writeToFile:[self getAppLibraryPath] atomically:YES];
    [self refreshSettings];
}

- (void)writeValue:(id)value forKey:(NSString *)key {
    [dictionary setValue:value forKey:key];
    [dictionary writeToFile:[self getAppLibraryPath] atomically:YES];
    [self refreshSettings];
}

- (void)dealloc {
    [dictionary release];
    [super dealloc];
}

@end
