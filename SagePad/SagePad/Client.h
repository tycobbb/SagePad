//
//  Client.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "AbstractClient.h"

@interface Client : NSObject <AbstractClient, NSStreamDelegate> {
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

@end
