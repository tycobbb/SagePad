//
//  Server.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "Server.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"

@implementation Server

@synthesize inputFromStream;

- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger)_portNumber {
    self = [super init];
    if (self) {
        ipAddress = _ipAddress;
        portNumber = _portNumber;
        NSLog(@"IP Address: %@", ipAddress);
        NSLog(@"Port Number: %d", portNumber);
        
        inputTranslatorNotification = @"TranslateInput";
        
        
        bufferSize = 1024; // default buffer size
        isConfigured = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(sendOutputString:) 
                                                     name:@"SendOutput" 
                                                   object:nil];
    }
    
    return self;
}

- (void)startWithInputTranslator:(id<AbstractInputTranslator>)inputTranslator 
             andOutputTranslator:(id<AbstractOutputTranslator>)outputTranslator {    
    
    NSLog(@"Server.startWithInputTranslator");

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)[self getIpAddress], (UInt32)[self getPortNumber], &readStream, &writeStream);
    
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)stop { // Fixed
    NSLog(@"Server: Closing Streams");
    [inputStream close];
    [outputStream close];
    
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    
    [inputStream release];
    [outputStream release];
    
    inputStream = nil;
    outputStream = nil;
}

- (NSString*)getIpAddress {
    // get ip address from core data
    return ipAddress;
}

- (NSInteger)getPortNumber {
    // get port number from core data
    return portNumber;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
			NSLog(@"Input Stream opened.");
			break;
		case NSStreamEventHasBytesAvailable:
            if(stream == inputStream) [self handleBytesAvailableEvent];
            NSLog(@"Input Stream Has Bytes Available");
            break;			
		case NSStreamEventErrorOccurred:
			NSLog(@"Input Stream Unable to connect to host.");
			break;
		case NSStreamEventEndEncountered:
            NSLog(@"Input Stream End Event");
			break;
		default:
			NSLog(@"Input Stream Unknown event");
	}
    
}

- (void)handleBytesAvailableEvent {
    NSInteger responseLength;
    uint8_t buffer[bufferSize];
    while ([inputStream hasBytesAvailable] && !isConfigured) {
        responseLength = [inputStream read:buffer maxLength:sizeof(buffer)];
        if (responseLength > 0) {
            inputFromStream = [[NSString alloc] initWithBytes:buffer 
                                                          length:responseLength 
                                                        encoding:NSASCIIStringEncoding];
            if (inputFromStream != nil) {
                isConfigured = true;
                
                NSLog(@"Connection response: %@", inputFromStream);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:inputTranslatorNotification object:self];
            }
        }
    }
    
}

- (void)setBufferSize:(int)_bufferSize {
    bufferSize = _bufferSize;
}

- (void)sendOutputString:(NSNotification *)notification{
    OutputTranslator *output = [notification object];
    
    NSData *data = [[NSData alloc] initWithData:[output.formattedOutput dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

@end
