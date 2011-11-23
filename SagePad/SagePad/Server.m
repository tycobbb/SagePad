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

- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger *)_portNumber {
    self = [super init];
    if (self) {
        ipAddress = _ipAddress;
        portNumber = _portNumber;
    }
    return self;
}

- (void)startWithInputTranslator:(id<AbstractInputTranslator> *)_inputTranslator andOutputTranslator:(id<AbstractOutputTranslator> *)_outputTranslator {
    inputTranslator = _inputTranslator;
    outputTranslator = _outputTranslator;
    
    CFStringRef ipAddress = (CFStringRef)[self getIpAddress];
    UInt32 portNumber = (UInt32)[self getPortNumber];
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, ipAddress, portNumber, 
        &readStream, &writeStream);
    
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    
    [inputStream setDelegate:inputTranslator];
    [outputStream setDelegate:outputTranslator];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (NSString*)getIpAddress {
    // get ip address from core data
    return ipAddress;
}

- (NSInteger*)getPortNumber {
    // get port number from core data
    return portNumber;
}

@end
