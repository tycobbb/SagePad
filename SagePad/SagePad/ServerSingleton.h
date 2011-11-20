//
//  ServerSingleton.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface ServerSingleton : NSObject {
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

- (NSString*)getIpAddress;
- (int)getPortNumber;
                    
@end
