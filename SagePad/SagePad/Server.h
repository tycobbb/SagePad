//
//  Server.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "AbstractServer.h"

@interface Server : NSObject <AbstractServer, NSStreamDelegate> {
    NSString *inputTranslatorNotification;
    
    NSString *ipAddress;
    NSInteger portNumber;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSInteger bufferSize;
    BOOL isConfigured;
}

@property(readonly, nonatomic) NSString *inputFromStream;

- (void)handleBytesAvailableEvent:(NSInputStream *)inputStream;
- (void)setBufferSize:(int)_bufferSize;
- (void)sendOutputString:(NSNotification *)notification;

@end
