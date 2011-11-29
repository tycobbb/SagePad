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
    yAtom = sageWidth / yAtom * [settings.sensitivity floatValue] / 100.0;
    
    if(!pointerAlreadyShared) {
        [self formatOutputAndNotifyServer:18 withParam1:settings.pointerName andParam2:settings.pointerColor];
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
    [self formatOutputAndNotifyServer:17 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translatePinch:(CGFloat *)scale isFirst:(BOOL)isFirst {
    if(!pointerAlreadyShared) return;
    if(isFirst) {
        firstPinch = *scale;
        return;
    }
    
    CGFloat changeScale = *scale - firstPinch;
    [self formatOutputAndNotifyServer:19 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]
                            andParam3:[NSString stringWithFormat:@"%d", (NSInteger)changeScale]];
}

- (void)translatePress:(CGPoint *)newTouch {
    NSLog(@"x:%f y:%f", newTouch->x, newTouch->y);
    if(!pointerAlreadyShared) return;
    [self setPreviousTouch:newTouch];
    [self formatOutputAndNotifyServer:8 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateDrag:(CGPoint *)newTouch {
    NSLog(@"x:%f y:%f", newTouch->x, newTouch->y);
    if(!pointerAlreadyShared) return;
    [self calculateNewSageLocation:newTouch];    
    [self formatOutputAndNotifyServer:15 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@", outputType, pointerId, param1, param2];
    [self notifyServerOfOutput];
}

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 
                          andParam3:(NSString *)param3 {
    formattedOutput = [NSString stringWithFormat:@"%d %u %@ %@ %@", outputType, pointerId, param1, param2, param3];
    [self notifyServerOfOutput];
}

- (void)notifyServerOfOutput {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_OUTPUT object:self];
}

- (void) dealloc {
    [settings release];
    [formattedOutput release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
