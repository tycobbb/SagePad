//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"
#import "Server.h"

@implementation InputTranslator

@synthesize pointerId;
@synthesize sageWidth;
@synthesize sageHeight;
@synthesize ftpPortNumber;

- (id)init
{    
    self = [super init];
    if (self) {
        pointerConfigurationNotification = @"SPSageConfiguration";
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(recieveConfigurationString:) 
                                                     name:@"TranslateInput" 
                                                   object:nil];
    }
    
    return self;
}

-(void)recieveConfigurationString:(NSNotification *)notification {
    Server *server = [notification object];
    
    [self translatePointerConfiguration:server.inputFromStream];
}

- (void)translatePointerConfiguration:(NSString *)pointerConfiguration {
    NSScanner *scanner = [NSScanner scannerWithString:pointerConfiguration];
    
    [scanner scanInt:&pointerId];
    NSLog(@"Client ID Config: %d", pointerId);
    [scanner scanInt:&sageWidth];
    NSLog(@"Screen Width ID Config: %d", sageWidth);
    [scanner scanInt:&sageHeight];
    NSLog(@"Screen Height ID Config: %d", sageHeight);
    [scanner scanInt:&ftpPortNumber];
    NSLog(@"FTP Port Config: %d", ftpPortNumber);
    
    // send the notification, may have to attach the data in some manner
    [[NSNotificationCenter defaultCenter] postNotificationName:pointerConfigurationNotification object:self];
}

- (void) dealloc {
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
