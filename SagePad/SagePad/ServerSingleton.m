//
//  ServerSingleton.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "ServerSingleton.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"

@implementation ServerSingleton

static ServerSingleton *sharedServer;

+ (void)intialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedServer = [[ServerSingleton alloc] init];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        CFStringRef ipAddress = (CFStringRef)[self getIpAddress];
        UInt32 portNumber = (UInt32)[self getPortNumber];
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocketToHost(NULL, ipAddress, portNumber, 
            &readStream, &writeStream);
        
        inputStream = (NSInputStream *)readStream;
        outputStream = (NSOutputStream *)writeStream;
        
        InputTranslator *inputDelegate = [[InputTranslator alloc] init];
        OutputTranslator *outputDelegate = [[OutputTranslator alloc] init];
        [inputStream setDelegate:inputDelegate];
        [outputStream setDelegate:outputDelegate];
        
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [inputStream open];
        [outputStream open];
    }
    
    return self;
}

- (NSString*)getIpAddress {
    // get ip address from core data
    return @"localhost";
}

- (int)getPortNumber {
    // get port number from core data
    return 5000;
}

@end
