//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"

@implementation InputTranslator

- (id)init
{    
    self = [super init];
    if (self) {
        bufferSize = 1024; // default buffer size
        pointerConfigurationNotification = @"SPSageConfiguration"; // move this into some constant storage
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
        while ([inputStream hasBytesAvailable]) {
            responseLength = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (responseLength > 0) {
                NSString *response = [[NSString alloc] initWithBytes:buffer 
                                                              length:responseLength 
                                                            encoding:NSASCIIStringEncoding];
                if (response != nil) {
                    NSLog(@"Connection response: %@", response);
                    [self translatePointerConfiguration:response];
                }
            }
        }
    }

}

- (void)translatePointerConfiguration:(NSString *)pointerConfiguration {
    NSInteger clientId, screenWidth, screenHeight, ftpPortNumber;
    NSScanner *scanner = [NSScanner scannerWithString:pointerConfiguration];
    
    [scanner scanInt:&clientId];
    [scanner scanInt:&screenWidth];
    [scanner scanInt:&screenHeight];
    [scanner scanInt:&ftpPortNumber];
    
    // send the notification, may have to attach the data in some manner
    [[NSNotificationCenter defaultCenter] postNotificationName:pointerConfigurationNotification object:self];
}

- (void)setBufferSize:(int)_bufferSize {
    bufferSize = _bufferSize;
}

@end
