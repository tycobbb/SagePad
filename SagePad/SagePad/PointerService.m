//
//  PointerService.m
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "PointerService.h"

@implementation PointerService

//- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
//          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator 
//                    andClient:(id<AbstractClient>)_client {
//    
//    self = [super init];
//    if (self) {
//        inputTranslator = _inputTranslator;
//        outputTranslator = _outputTranslator;
//        client = _client;
//        
//        [inputTranslator retain];
//        [outputTranslator retain];
//        [client retain];
//    }
//    
//    return self;
//}
//
//- (void)startClient {
//    [client start]; 
//}
//
//- (void)stopClient {
//    [client stop];
//}
//
//- (void)setServerBufferSize:(NSInteger)bufferSize {
//    [client setBufferSize:bufferSize];
//}

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator 
                    andClient:(id<AbstractClient>)_client {
    
    self = [super initWithInputTranslator:_inputTranslator
                      andOutputTranslator:_outputTranslator
                                andClient:_client];
    if (self) { }
    return self;
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
    [client release];
    
    [super dealloc];
}

@end
