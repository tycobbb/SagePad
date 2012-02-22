//
//  Client.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "Client.h"
#import "OutputTranslator.h"
#import "SagePadConstants.h"

@implementation Client

@synthesize inputFromStream;

- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger)_portNumber {
    self = [super init];
    if (self) {
        ipAddress = _ipAddress;
        portNumber = _portNumber;
        NSLog(@"IP Address: %@", ipAddress);
        NSLog(@"Port Number: %d", portNumber);
                
        bufferSize = 1280; // default buffer size
        isConfigured = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(sendOutputString:) 
                                                     name:NOTIFY_OUTPUT 
                                                   object:nil];
    }
    
    return self;
}

- (void)start {    
    NSLog(@"Client.startWithInputTranslator");

    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ipAddress, (UInt32)portNumber, &readStream, &writeStream);
    
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
    NSLog(@"Client: Closing Streams");
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
			if(stream == inputStream) NSLog(@"Input Stream opened.");
            else NSLog(@"Output Stream opened.");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if(stream == inputStream){
                [self handleBytesAvailableEvent:(NSInputStream*)inputStream];
                NSLog(@"Input Stream Has Bytes Available"); }
            else 
                NSLog(@"Output Stream Has Bytes Available");
            break;
			
		case NSStreamEventErrorOccurred:
            if(stream == inputStream) NSLog(@"Input Stream Unable to connect to host.");
            else NSLog(@"Output Stream Unable to connect to host.");
            break;
            
        case NSStreamEventHasSpaceAvailable:
            if(stream == inputStream) NSLog(@"Input Stream has Space Available");
            else NSLog(@"Output Stream has Space Available");
            break;
		
        case NSStreamEventEndEncountered:
            if(stream == inputStream) NSLog(@"Input Stream End Event");
            else NSLog(@"Output Stream End Event");
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [stream release];
            stream = nil;
			break;
            
		default:
			if(stream == inputStream) NSLog(@"Input Stream Unknown event");
            else NSLog(@"Output Stream Unknown event");
            NSLog(@"stream event %i", streamEvent);
            break;
	}
    
}

- (void)handleBytesAvailableEvent:(NSInputStream*)inStream {
    NSInteger responseLength;
    uint8_t buffer[bufferSize];
    while ([inStream hasBytesAvailable] && !isConfigured) {
        responseLength = [inStream read:buffer maxLength:sizeof(buffer)];
        NSLog(@"Size of buffer: %lu", sizeof(buffer));
        NSLog(@"Reading from stream");
        if (responseLength > 0) {
            inputFromStream = [[NSString alloc] initWithBytes:buffer 
                                                       length:responseLength 
                                                     encoding:NSASCIIStringEncoding];
            if (inputFromStream != nil) {
                isConfigured = true;
                NSLog(@"Connection response: %@", inputFromStream);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_INPUT object:self];
            }
        }
    }
}

- (void)sendOutputString:(NSNotification *)notification{
    OutputTranslator *output = [notification object];
    NSLog(@"MESSAGE FROM OUTPUT TRANSLATOR: %@", output.formattedOutput);
    
    NSMutableData *data = [[NSMutableData alloc] initWithLength:128];
    NSMutableData *outputData = [NSMutableData dataWithData:[output.formattedOutput dataUsingEncoding:NSUTF8StringEncoding]];
    NSRange range = NSMakeRange(0, [outputData length]);
    [data replaceBytesInRange:range withBytes:[outputData bytes] length:[outputData length]];
    
    NSLog(@"Length of Data: %d", [data length]);
    
    [(NSOutputStream *)outputStream write:[data bytes] maxLength:[data length]];
}

- (void)setBufferSize:(NSInteger)_bufferSize {
    bufferSize = _bufferSize;
}

- (void)dealloc {
    [inputFromStream release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end