//
//  Client.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "AbstractClient.h"
#import "NetworkingDelegate.h"
#import "SageConfiguration.h"

@interface Client : NSObject <AbstractClient, NSStreamDelegate> {    
    @private
    NSString *ipAddress;
    NSInteger portNumber;
    NSInteger ftpPortNumber;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSInteger bufferSize;
    BOOL isConfigured;
}

@end
