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

- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger)_portNumber {
    self = [super init];
    if (self) {
        ipAddress = _ipAddress;
        portNumber = _portNumber;
        NSLog(@"IP Address: %@", ipAddress);
        NSLog(@"Port Number: %d", portNumber);
    }
    
    return self; // maybe if we change the return type here to (id<AbstractServer> *) and cast self to it as well...
}

- (void)startWithInputTranslator:(id<NSStreamDelegate>)inputTranslator andOutputTranslator:(id<NSStreamDelegate>)outputTranslator {    
    
    NSLog(@"startWithInputTranslator");

    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)[self getIpAddress], (UInt32)[self getPortNumber], &readStream, &writeStream);
    
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:inputTranslator];
    [outputStream setDelegate:outputTranslator];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)stop { // Fixed
    NSLog(@"Closing Streams");
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

@end
