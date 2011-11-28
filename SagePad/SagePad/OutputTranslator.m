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

@synthesize formattedOutput;
@synthesize currentCoordinates;

- (id)init
{
    self = [super init];
    if (self) {
        //Notifications
        pointerConfigurationNotification = @"SPSageConfiguration";
        sendOutputNotification = @"SendOutput"; // move this into some constant storage
        
        //Keeping track of coordinates in SAGE-Next
        currentCoordinates.x = 0;
        currentCoordinates.y = 0;
        sharePointer = false;
        
        //Notification handler
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handlePointerConfiguration:) 
                                                     name:@"SPSageConfiguration" 
                                                   object:nil];
    }
    
    return self;
}

- (void)translateTouchEvent:(CGPoint *)touchCoordinates {
    if(sharePointer){
        if(touchCoordinates->x > sageWidth) currentCoordinates.x = sageWidth;
        else currentCoordinates.x = touchCoordinates->x;
        
        if(touchCoordinates->y > sageHeight) currentCoordinates.y = sageHeight;
        else currentCoordinates.y = touchCoordinates->y;
    
        formattedOutput = [NSString stringWithFormat:@"%d %u %f %f", 17, pointerId, currentCoordinates.x, currentCoordinates.y];
    
        //[[NSNotificationCenter defaultCenter] postNotificationName:sendOutputNotification object:self];
    }
}

- (void)handlePointerConfiguration:(NSNotification *)notification {    
    InputTranslator *inputTranslator = [notification object];
    
    pointerId = inputTranslator.pointerId;
    sageWidth = inputTranslator.sageWidth;
    sageHeight = inputTranslator.sageHeight;
    ftpPortNumber = inputTranslator.ftpPortNumber;
    
    NSLog(@"Output translator received notification: %d %d %d %d", pointerId, sageWidth, sageHeight, ftpPortNumber);
    if(sharePointer == false){
        [self formatOutput];
        sharePointer = true;
    }
}

- (void) formatOutput {
    formattedOutput = [NSString stringWithFormat:@"%d %u %s %s", 18, pointerId, "John", "#ff0000"]; //Implement formatting of Output Here!
    [[NSNotificationCenter defaultCenter] postNotificationName:sendOutputNotification object:self];
}

- (void) dealloc {
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [formattedOutput release];
    [super dealloc];
}

@end
