//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "NetworkingService.h"
#import "Client.h"

@interface NetworkingService ()

@property (nonatomic, retain) id<AbstractClient> client;
@property (nonatomic, retain) id<AbstractClient> ftpClient;
@property (nonatomic, retain) id<AbstractInputTranslator> inputTranslator;
@property (nonatomic, retain) id<AbstractOutputTranslator> outputTranslator;

@end

@implementation NetworkingService

@synthesize client = _client;
@synthesize ftpClient = _ftpClient;
@synthesize inputTranslator = _inputTranslator;
@synthesize outputTranslator = _outputTranslator;

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)inputTranslator
          andOutputTranslator:(id<AbstractOutputTranslator>)outputTranslator 
                    andClient:(id<AbstractClient>)client
                 andFtpClient:(id<AbstractClient>)ftpClient{
    
    self = [super init];
    if (self) {
        self.client = client;
        self.ftpClient = ftpClient;
        self.inputTranslator = inputTranslator;
        self.outputTranslator = outputTranslator;
        
        self.client.delegate = self;
        self.ftpClient.delegate = self;
        self.inputTranslator.delegate = self;
        self.outputTranslator.delegate = self;
    }
    
    return self;
}

// client methods
- (void)startClient {
    [_client start]; 
}

- (void)stopClient {
    [_client stop];
}

- (void)setServerBufferSize:(NSInteger)bufferSize {
    [_client setBufferSize:bufferSize];
}

// output translator methods
// --for pointer
- (void)handleMove:(CGPoint *)coordinates isFirst:(BOOL)isFirst {
    [_outputTranslator translateMove:coordinates isFirst:isFirst];
}

- (void)handlePinch:(CGFloat *)scale {
    [_outputTranslator translatePinch:scale];
}

- (void)handlePress:(CGPoint *)touchCoordinates {
    [_outputTranslator translatePress:touchCoordinates];
}

- (void)handleDrag:(CGPoint *)touchCoordinates {
    [_outputTranslator translateDrag:touchCoordinates];
}

- (void)handleRelease:(CGPoint *)touchCoodinates {
    [_outputTranslator translateRelease:touchCoodinates];
}

- (void)handleClick:(CGPoint *)touchCoordinates {
    [_outputTranslator translateClick:touchCoordinates];
}

// --for ftp
- (void)pushFile:(NSString *)path {
    [_outputTranslator sendFileHeader:path];
    [_ftpClient sendFile:path];
}

// child communication methods
- (void)handleConnectionResponse:(NSString *)response {
    [_inputTranslator handleConnectionResponse:response];
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {  
    [_client handleSageConfiguration:configuration];
    [_ftpClient handleSageConfiguration:configuration];
    [_outputTranslator handleSageConfiguration:configuration];
}

- (void)handleOutputReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size {
    [_client sendOutputString:output withSize:size];
}

- (void)dealloc {
    [_client release];
    [_ftpClient release];
    [_inputTranslator release];
    [_outputTranslator release];
    
    [super dealloc];
}

@end
