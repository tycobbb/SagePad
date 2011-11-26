//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"

@implementation InputTranslator

@synthesize pointerId;
@synthesize sageWidth;
@synthesize sageHeight;
@synthesize ftpPortNumber;

- (id)init
{    
    self = [super init];
    if (self) {
        bufferSize = 1024; // default buffer size
        pointerConfigurationNotification = @"SPSageConfiguration"; // move this into some constant storage
        isConfigured = false;
    }
    
    return self;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened.");
			break;
		case NSStreamEventHasBytesAvailable:
            [self handleBytesAvailableEvent:(NSInputStream *)stream];
            break;			
		case NSStreamEventErrorOccurred:
			NSLog(@"Unable to connect to host.");
			break;
		case NSStreamEventEndEncountered:
			break;
		default:
			NSLog(@"Unknown event");
	}
    
}

- (void)handleBytesAvailableEvent:(NSInputStream *)inputStream {
    if(inputStream){
        NSInteger responseLength;
        uint8_t buffer[bufferSize];
        while ([inputStream hasBytesAvailable] && !isConfigured) {
            responseLength = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (responseLength > 0) {
                NSString *response = [[NSString alloc] initWithBytes:buffer 
                                                              length:responseLength 
                                                            encoding:NSASCIIStringEncoding];
                if (response != nil) {
                    isConfigured = true;
                    NSLog(@"Connection response: %@", response);
                    [self translatePointerConfiguration:response];
                }
            }
        }
    }

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

- (void)setBufferSize:(int)_bufferSize {
    bufferSize = _bufferSize;
}

@end
