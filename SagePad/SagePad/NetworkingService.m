//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "NetworkingService.h"

@implementation NetworkingService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator 
                    andClient:(id<AbstractClient>)_client {
    
    self = [super init];
    if (self) {
        inputTranslator = _inputTranslator;
        outputTranslator = _outputTranslator;
        client = _client;
        
        [inputTranslator retain];
        [outputTranslator retain];
        [client retain];
    }
    
    return self;
}

- (void)startClient {
    [client start]; 
}

- (void)stopClient {
    [client stop];
}

- (void)setServerBufferSize:(NSInteger)bufferSize {
    [client setBufferSize:bufferSize];
}

@end
