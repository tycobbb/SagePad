//
//  FtpClient.h
//  SagePad
//
//  Created by Jakub Misterka on 3/12/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "Client.h"

@interface FtpClient : Client {
    @private
    NSFileManager *fileManager;
}

- (id)initWithIp:(NSString *)_ipAddress;
- (void)initialFtpMessage;

@end
