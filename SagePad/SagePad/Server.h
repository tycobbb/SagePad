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
    NSString *ipAddress;
    NSInteger *portNumber;
    
    NSStream *inputStream;
    NSStream *outputStream;
}

@end
