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
    }
    
    return self;
}

// we can probably eliminate this, does the output stream have to handle events?
- (void)stream:(NSStream *)outputStream handleEvent:(NSStreamEvent)streamEvent {
    // handle events
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
