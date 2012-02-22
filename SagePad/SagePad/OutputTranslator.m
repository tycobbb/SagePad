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

// --- "private" helper methods ---

- (void)setPreviousTouch:(CGPoint *)newTouch {
    previousTouch.x = newTouch->x;
    previousTouch.y = newTouch->y;
}

- (void)calculateNewSageLocation:(CGPoint *)newTouch {
    CGFloat sageX = sageLocation.x + (newTouch->x - previousTouch.x) * xAtom;
    CGFloat sageY = sageLocation.y + (newTouch->y - previousTouch.y) * yAtom;
    
    if(sageX > sageWidth) sageX = sageWidth;
    else if(sageX < 0) sageX = 0;    
    if(sageY > sageHeight) sageY = sageHeight;
    else if(sageY < 0) sageY = 0;
    
    sageLocation.x = sageX;
    sageLocation.y = sageY;
    
    [self setPreviousTouch:newTouch];
}

// --- "public" methods ---

- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight {
    self = [super init];
    if (self) {
        xAtom = deviceWidth; // not yet the atomic values...
        yAtom = deviceHeight;
        
        settings = [[SagePadSettings alloc] init];
        
        pointerAlreadyShared = NO;        
        previousTouch.x = 0;
        previousTouch.y = 0;
        sageLocation.x = 0;
        sageLocation.y = 0;
        firstPinch = 0;
        
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
    
    xAtom = sageWidth / xAtom * [settings.sensitivity floatValue] / 100.0; // now the atomic values are set correctly
    yAtom = sageHeight / yAtom * [settings.sensitivity floatValue] / 100.0;
    
    if(!pointerAlreadyShared) {
        [self formatOutputAndNotifyClient:18 withParam1:settings.pointerName andParam2:settings.pointerColor];
        pointerAlreadyShared = YES;
    }
}

- (void)translateMove:(CGPoint *)newTouch isFirst:(BOOL)isFirst {
    if(!pointerAlreadyShared) return;
    if(isFirst) {
        [self setPreviousTouch:newTouch];
        return;
    }
    
    [self calculateNewSageLocation:newTouch];    
    [self formatOutputAndNotifyClient:POINTER_MOVING 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translatePinch:(CGFloat *)scale {
    if(!pointerAlreadyShared) return;
    
    CGFloat changeScale = *scale - 1;
    if (changeScale < 0) changeScale *= 10;
    [self formatOutputAndNotifyClient:POINTER_WHEEL 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]
                            andParam3:[NSString stringWithFormat:@"%d", (NSInteger)changeScale]];
}

- (void)translatePress:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self setPreviousTouch:newTouch];
    [self formatOutputAndNotifyClient:POINTER_PRESS 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateDrag:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self calculateNewSageLocation:newTouch];    
    [self formatOutputAndNotifyClient:POINTER_DRAGGING 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateRelease:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self formatOutputAndNotifyClient:POINTER_RELEASE
                              withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                               andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateClick:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self formatOutputAndNotifyClient:POINTER_CLICK
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)unsharePointer {
    [self formatOutputAndNotifyClient:POINTER_UNSHARE];
}

- (void)formatOutputAndNotifyClient:(NSInteger)outputType {
    formattedOutput = [NSString stringWithFormat:@"%d %u", outputType, pointerId];
    [self notifyClientOfOutput];
}

- (void)formatOutputAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@", outputType, pointerId, param1, param2];
    [self notifyClientOfOutput];
}

- (void)formatOutputAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 
                          andParam3:(NSString *)param3 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@ %@", outputType, pointerId, param1, param2, param3];
    [self notifyClientOfOutput];
}

- (void)notifyClientOfOutput {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OUTPUT object:self];
}

- (void) dealloc {
    [self unsharePointer];
    [settings release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
