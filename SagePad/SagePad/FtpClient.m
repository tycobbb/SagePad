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

- (void) stream: (NSStream *) stream handleEvent: (NSStreamEvent) eventCode{
    if(eventCode == NSStreamEventHasSpaceAvailable){
        
    }
}

- (void)sendFile:(NSString *)path {
    NSNumber *size;
    NSInteger bytesWritten = 0;
    NSInteger bytesLeft;
    
    NSData *data, *subData;

    NSLog(@"Path of File to be Sent: %@", path);
    
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!error) {
        size = [attributes objectForKey:NSFileSize];
        data = [fileManager contentsAtPath:path];
        bytesLeft = [data length];
    }
    else{
        NSLog(@"There is an error in the path name");
        return;
    }
    
    NSLog(@"Size of File: %d", [size unsignedIntValue]);
    
    while(YES){
        if([outputStream hasSpaceAvailable]){
            subData = [data subdataWithRange:NSMakeRange(bytesWritten, bytesLeft)];
            bytesWritten += [outputStream write:[subData bytes] maxLength:bytesLeft];
            bytesLeft = [data length] - bytesWritten;
            if(bytesWritten >= [data length])
                break;
        }
    }
}

@end
