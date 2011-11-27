//
//  OutputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "OutputTranslator.h"
#import "InputTranslator.h"

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
        sharePointer = true;
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
            if(sharePointer == true){
                NSString *response  = [NSString stringWithFormat:@"%d %u %@ %@", 18, pointerId, @"john", @"#ff0000" ];
                NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
                [outputStream write:[data bytes] maxLength:[data length]];
                NSLog(@"Sent: %@", response);
                sharePointer = false;
            }
            else{
                NSString *response  = [NSString stringWithFormat:@"%d %u %d %d", 17, pointerId, 200, 200 ];
                NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
                [outputStream write:[data bytes] maxLength:[data length]];
                NSLog(@"Sent: %@", response);
            }
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
    InputTranslator *inputTranslator = [notification object];
    
    pointerId = inputTranslator.pointerId;
    sageWidth = inputTranslator.sageWidth;
    sageHeight = inputTranslator.sageHeight;
    ftpPortNumber = inputTranslator.ftpPortNumber;
    
    NSLog(@"Output translator received notification: %d %d %d %d", pointerId, sageWidth, sageHeight, ftpPortNumber);
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
