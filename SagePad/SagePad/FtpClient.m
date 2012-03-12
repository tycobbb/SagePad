//
//  FtpClient.m
//  SagePad
//
//  Created by Jakub Misterka on 3/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FtpClient.h"

@implementation FtpClient

- (id)initWithIp:(NSString *)_ipAddress{
    self = [super init];
    if (self) {
        ipAddress = _ipAddress;
        NSLog(@"IP Address for FTP: %@", ipAddress);
        isConfigured = false;
    }
    
    fileManager = [[NSFileManager alloc] init];
    
    return self;
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {
    portNumber = super.sageConfiguration.ftpPort;
    isConfigured = true;
}

//To be implemented
- (void)handleBytesAvailableEvent:(NSInputStream*)inStream withSize:(NSInteger)size {
    
}

- (void)sendFile:(NSString *)path {
    NSNumber *size;
    NSData *data;
    NSLog(@"Path of File to be Sent: %@", path);
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!error) {
        size = [attributes objectForKey:NSFileSize];
        data = [fileManager contentsAtPath:path];
    }
    else{
        NSLog(@"There is an error in the path name");
        return;
    }
    
    NSLog(@"Size of File: %d", [size unsignedIntValue]);
    [(NSOutputStream *)outputStream write:[data bytes] maxLength:[size unsignedIntValue]];
}

@end
