//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"

@implementation InputTranslator

- (id)init
{    
    self = [super init];
    if (self) {
        notificationName = @"SPSageConfiguration";
        
    }
    
    return self;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if(theStream){
                uint8_t buffer[1024];
                int len;
                
                while ([theStream hasBytesAvailable]) {
                    len = [theStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            [self translateConnectionConfirmation:output];
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
			break;			
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
    
}


- (void)translateConnectionConfirmation: (NSString *) sageConfiguration {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end
