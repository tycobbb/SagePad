//
//  Server.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "AbstractServer.h"

@interface Server : NSObject <AbstractServer> {
    NSString *inputTranslatorNotification;
    
    NSString *ipAddress;
    NSInteger portNumber;
    
    NSStream *inputStream;
    NSStream *outputStream;
    
    NSInteger bufferSize;
    BOOL isConfigured;
}

@property(readonly, nonatomic) NSString *inputFromStream;

- (void)handleBytesAvailableEvent;
- (void)setBufferSize:(int)_bufferSize;
- (void)sendOutputString:(NSNotification *)notification;

@end
