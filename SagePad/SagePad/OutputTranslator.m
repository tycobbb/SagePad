//
//  OutputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "OutputTranslator.h"
#import "InputTranslator.h"
#import "SagePadConstants.h"

@implementation OutputTranslator

@synthesize formattedOutput;

- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight {
    self = [super init];
    if (self) {
        xAtom = deviceWidth; // not yet the atomic units...
        yAtom = deviceHeight;
        
        settings = [[SagePadSettings alloc] init];
        
        pointerAlreadyShared = NO;        
        previousTouch->x = 0;
        previousTouch->y = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handlePointerConfiguration:) 
                                                     name:NOTIFY_SAGE_CONFIG
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
    
    xAtom = sageWidth / xAtom * [settings.sensitivity floatValue] / 100.0;
    yAtom = sageWidth / xAtom * [settings.sensitivity floatValue] / 100.0;
    
    if(!pointerAlreadyShared) {
        [self formatOutputAndNotifyServer:18 withParam1:settings.pointerName andParam2:settings.pointerColor];
        pointerAlreadyShared = YES;
    }
}

- (void) formatOutput {
    formattedOutput = [NSString stringWithFormat:@"%d %u %s %s", 18, pointerId, "John", "#ff0000"]; //Implement formatting of Output Here!
    [[NSNotificationCenter defaultCenter] postNotificationName:sendOutputNotification object:self];
}

- (void) dealloc {
    [settings release];
    [formattedOutput release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
