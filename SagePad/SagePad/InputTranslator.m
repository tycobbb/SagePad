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
    int clientID;
    int screenWidth;
    int screenHeight;
    int fileTransport;
    if(inputStream){
        int len;
        uint8_t buffer[bufferSize];
        while ([inputStream hasBytesAvailable]) {
            len = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                NSString *response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                if (response != nil) {
                    NSLog(@"Connection response: %@", response);
                    NSScanner *scanner = [NSScanner scannerWithString:response];
                    [scanner scanInt:&clientID];
                    [scanner scanInt:&screenWidth];
                    [scanner scanInt:&screenHeight];
                    [scanner scanInt:&fileTransport];
                    [self translatePointerConfiguration:response];
                }
            }
        }
    }

}

- (void)translatePointerConfiguration:(NSString *)pointerConfiguration {
    [[NSNotificationCenter defaultCenter] postNotificationName:pointerConfigurationNotification object:self];
}

- (void)setBufferSize:(int)_bufferSize {
    bufferSize = _bufferSize;
}

@end
