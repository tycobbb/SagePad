//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "NetworkingService.h"

@implementation NetworkingService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator 
                    andServer:(id<AbstractServer>)_server {
    
    self = [super init];
    if (self) {
        inputTranslator = _inputTranslator;
        outputTranslator = _outputTranslator;
        server = _server;
        
        [inputTranslator retain];
        [outputTranslator retain];
        [server retain];
    }
    
    return self;
}

- (void)startServer {
    [server start]; 
}

- (void)stopServer {
    [server stop];
}

- (void)setServerBufferSize:(NSInteger)bufferSize {
    [server setBufferSize:bufferSize];
}

- (void)handleMove:(CGPoint *)coordinates isFirst:(BOOL)isFirst {
    [outputTranslator translateMove:coordinates isFirst:isFirst];
}

- (void)handlePinch:(CGFloat *)scale {
    [outputTranslator translatePinch:scale];
}

- (void)handlePress:(CGPoint *)touchCoordinates {
    [outputTranslator translatePress:touchCoordinates];
}

- (void)handleDrag:(CGPoint *)touchCoordinates {
    [outputTranslator translateDrag:touchCoordinates];
}

- (void)handleRelease:(CGPoint *)touchCoodinates {
    [outputTranslator translateRelease:touchCoodinates];
}

- (void)handleClick:(CGPoint *)touchCoordinates {
    [outputTranslator translateClick:touchCoordinates];
}    

- (void)dealloc {
    [inputTranslator release];
    [outputTranslator release];
    [server release];
    
    [super dealloc];
}

@end
