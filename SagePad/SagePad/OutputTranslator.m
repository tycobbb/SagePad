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

@synthesize delegate = _delegate;
@synthesize sageConfiguration = _sageConfiguration;

// --- "private" helper methods ---
//   -- coordinate calculation helpers
- (void)setPreviousTouch:(CGPoint *)newTouch {
    previousTouch.x = newTouch->x;
    previousTouch.y = newTouch->y;
}

- (void)calculateNewSageLocation:(CGPoint *)newTouch {
    CGFloat sageX = sageLocation.x + (newTouch->x - previousTouch.x) * xAtom;
    CGFloat sageY = sageLocation.y + (newTouch->y - previousTouch.y) * yAtom;
    
    if(sageX > _sageConfiguration.width) sageX = _sageConfiguration.width;
    else if(sageX < 0) sageX = 0;    
    if(sageY > _sageConfiguration.height) sageY = _sageConfiguration.height;
    else if(sageY < 0) sageY = 0;
    
    sageLocation.x = sageX;
    sageLocation.y = sageY;
    
    [self setPreviousTouch:newTouch];
}

//  -- output message formatters
- (void)formatOutputAndNotifyClient:(NSInteger)outputType {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u", outputType, _sageConfiguration.pointerId]];
}

- (void)formatOutputAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u %@ %@", outputType, _sageConfiguration.pointerId, param1, param2]];
}

- (void)formatOutputAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 
                          andParam3:(NSString *)param3 {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u %@ %@ %@", outputType, _sageConfiguration.pointerId, param1, param2, param3]];
}

- (void)notifyOutputReady:(NSString *)output {
    [_delegate handleOutputReady:output];
}

//  -- specific output messages
- (void)sharePointer {
    [self formatOutputAndNotifyClient:POINTER_SHARE withParam1:settings.pointerName andParam2:settings.pointerColor];
    pointerAlreadyShared = YES;
}

- (void)unsharePointer {
    [self formatOutputAndNotifyClient:POINTER_UNSHARE];
}

// --- "public" methods ---

- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight {
    self = [super init];
    if (self) {
        settings = [[SagePadSettings alloc] init];
        fileManager = [[NSFileManager alloc] init];

        xAtom = deviceWidth; // not yet the atomic values...
        yAtom = deviceHeight;        
        
        pointerAlreadyShared = NO;        
        previousTouch.x = 0;
        previousTouch.y = 0;
        sageLocation.x = 0;
        sageLocation.y = 0;
        firstPinch = 0;
    }
    
    return self;
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {
    _sageConfiguration = configuration;

    xAtom = _sageConfiguration.width / xAtom * [settings.sensitivity floatValue] / 100.0; // now the atomic values are set correctly
    yAtom = _sageConfiguration.height / yAtom * [settings.sensitivity floatValue] / 100.0;
    
    if(!pointerAlreadyShared) [self sharePointer];
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

- (void)sendFile:(NSString *)path {
    
}

- (void) dealloc {
    [self unsharePointer];
    [settings release];
    [fileManager release];
    [_sageConfiguration release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
