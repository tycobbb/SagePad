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
        previousTouch.x = 0;
        previousTouch.y = 0;
        pinchBegan = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handlePointerConfiguration:) 
                                                     name:NOTIFY_SAGE_CONFIG
                                                   object:nil];
    }
    
    return self;
}

- (void)handlePointerConfiguration:(NSNotification *)notification {    
    InputTranslator *inputTranslator = [notification object];
    
    pointerId = inputTranslator.pointerId;
    sageWidth = inputTranslator.sageWidth;
    sageHeight = inputTranslator.sageHeight;
    ftpPortNumber = inputTranslator.ftpPortNumber;
    
    xAtom = sageWidth / xAtom * [settings.sensitivity floatValue] / 100.0;
    yAtom = sageWidth / yAtom * [settings.sensitivity floatValue] / 100.0;
    
    if(!pointerAlreadyShared) {
        [self formatOutputAndNotifyServer:18 withParam1:settings.pointerName andParam2:settings.pointerColor];
        pointerAlreadyShared = YES;
    }
}

- (void)translateTouchEvent:(CGPoint *)newTouch {
    if(pointerAlreadyShared) {
        CGFloat sageX = previousTouch.x + (newTouch->x - previousTouch.x) * xAtom;
        CGFloat sageY = previousTouch.y + (newTouch->y - previousTouch.y) * yAtom;
        
        if(sageX > sageWidth) sageX = sageWidth;
        else if(sageX < 0) sageX = 0;    
        if(sageY > sageHeight) sageY = sageHeight;
        else if(sageY < 0) sageY = 0;
        
        previousTouch.x = sageX;
        previousTouch.y = sageY;
        
        [self formatOutputAndNotifyServer:17 
                               withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageX] 
                                andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageY]];
    }
}

- (void)translatePinchBegan:(CGFloat *)scalef {
    pinchBegan = *scalef;
    NSLog(@"Pinch Began at: %f", pinchBegan);
}

- (void)translatePinchEvent:(CGFloat *)scalef {
    CGFloat changeScale = *scalef - pinchBegan;
    NSLog(@"Pinch scale: %f and current pinch at: %f", changeScale, *scalef);
    if(pointerAlreadyShared){
        [self formatOutputAndNotifyServer:19 
                               withParam1:[NSString stringWithFormat:@"%d", (NSInteger)previousTouch.x] 
                                andParam2:[NSString stringWithFormat:@"%d", (NSInteger)previousTouch.y]
                                andParam3:[NSString stringWithFormat:@"%d", (NSInteger)changeScale]];
    }
}

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 andParam2:(NSString *)param2 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@", outputType, pointerId, param1, param2];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OUTPUT object:self];
}

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 andParam2:(NSString *)param2 andParam3:(NSString *)param3 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@ %@", outputType, pointerId, param1, param2, param3];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OUTPUT object:self];
}

- (void) dealloc {
    [settings release];
    [formattedOutput release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
