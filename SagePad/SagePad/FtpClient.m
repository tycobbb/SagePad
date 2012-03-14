//
//  FtpClient.m
//  SagePad
//
//  Created by Jakub Misterka on 3/11/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "FtpClient.h"

@implementation FtpClient

- (id)initWithIp:(NSString *)_ipAddress{
    self = [super initWithIp:_ipAddress andPortNumber:0];
    if (self) {
        fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {
    super.sageConfiguration = configuration;
    portNumber = configuration.ftpPort;
    isConfigured = true;
    [super start];
    [self initialFtpMessage];
}


- (void)initialFtpMessage {
    
    [super sendOutputString:[NSString stringWithFormat:@"%d", super.sageConfiguration.pointerId]
                                                 withSize:LRG_MSG_SIZE];
    
}

// to be implemented
- (void)handleBytesAvailableEvent:(NSInputStream*)inStream withSize:(NSInteger)size {
    
}


- (void)sendFile:(NSString *)path {
    NSNumber *size;
    NSData *data;
    NSMutableData * newData;
    NSLog(@"Path of File to be Sent: %@", path);
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!error) {
        size = [attributes objectForKey:NSFileSize];
        data = [fileManager contentsAtPath:path];
        newData = [NSMutableData dataWithData:data];
        [newData appendData:[[NSString stringWithFormat:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        NSLog(@"There is an error in the path name");
        return;
    }
    
    NSLog(@"Size of File: %d", [size unsignedIntValue]);
    [(NSOutputStream *)outputStream write:[newData bytes] maxLength:[size unsignedIntValue] + 1];
}

@end
