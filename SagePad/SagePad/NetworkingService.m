//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "NetworkingService.h"
#import "AbstractServer.h"
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

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

- (void)handlePinchEvent:(CGFloat *)scalef isFirst:(BOOL)isFirst {
    [outputTranslator translatePinchEvent:scalef isFirst:isFirst];
}

- (void)handleTouchEvent:(CGPoint *)coordinates isFirst:(BOOL)isFirst {
    [outputTranslator translateTouchEvent:coordinates isFirst:isFirst];
}

- (void)dealloc {
    [inputTranslator release];
    [outputTranslator release];
    [server release];
    
    [super dealloc];
}

@end
