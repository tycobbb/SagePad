//
//  OutputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "OutputTranslator.h"

@implementation OutputTranslator

- (id)init
{
    self = [super init];
    if (self) {
        pointerConfigurationNotification = @"SPSageConfiguration"; // move this into some constant storage
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handlePointerConfiguration:) 
                                                     name:@"SPSageConfiguration" 
                                                   object:nil];
        test = false;
    }
    
    return self;
}

// we can probably eliminate this, does the output stream have to handle events?
- (void)stream:(NSStream *)outputStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
			NSLog(@"Output Stream opened.");
			break;
		case NSStreamEventHasBytesAvailable:
            NSLog(@"Output Stream has bytes available");
            break;			
		case NSStreamEventErrorOccurred:
			NSLog(@"Output Stream Unable to connect to host.");
			break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Output Stream has Space Available");
            break;
		case NSStreamEventEndEncountered:
            NSLog(@"Output Stream End Event");
			break;
		default:
			NSLog(@"Output Stream Unknown event");
    }
}

- (void)translateTouchEvent:(CGPoint *)touchCoordinates {
    // translate and send to SAGE
}


- (void)handlePointerConfiguration:(NSNotification *)notification {
    NSLog(@"Received notification in output translator: %@", [notification name]);
    
    
    // need to figure out how to get the acutal string, not just notification name
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
