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

@property (nonatomic, retain) id<AbstractClient> messageClient;
@property (nonatomic, retain) id<AbstractClient> ftpClient;
@property (nonatomic, retain) id<AbstractInputTranslator> inputTranslator;
@property (nonatomic, retain) id<AbstractOutputTranslator> outputTranslator;

@end

@implementation NetworkingService

@synthesize messageClient = _messageClient;
@synthesize ftpClient = _ftpClient;
@synthesize inputTranslator = _inputTranslator;
@synthesize outputTranslator = _outputTranslator;

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)inputTranslator
          andOutputTranslator:(id<AbstractOutputTranslator>)outputTranslator 
                    andClient:(id<AbstractClient>)client
                 andFtpClient:(id<AbstractClient>)ftpClient{
    
    self = [super init];
    if (self) {
        self.messageClient = client;
        self.ftpClient = ftpClient;
        self.inputTranslator = inputTranslator;
        self.outputTranslator = outputTranslator;
        
        self.messageClient.delegate = self;
        self.ftpClient.delegate = self;
        self.inputTranslator.delegate = self;
        self.outputTranslator.delegate = self;
    }
    
    return self;
}

// client methods
- (void)startMessageClient {
    [_messageClient start]; 
}

- (void)stopMessageClient {
    [_messageClient stop];
}

- (void)startFtpClient {
    [_ftpClient start];
}

- (void)stopFtpClient {
    [_ftpClient stop];
}

- (void)setServerBufferSize:(NSInteger)bufferSize {
    [_messageClient setBufferSize:bufferSize];
}

// output translator methods
// --for pointer
- (void)sharePointer {
    [_outputTranslator sharePointer];
}

- (void)unsharePointer {
    [_outputTranslator unsharePointer];
}

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
    NSLog(@"NetworkingService: trying to push %@", path);
    [_outputTranslator sendFileHeader:path];
    [_ftpClient sendFile:path];
}

// child communication methods
- (void)handleConnectionResponse:(NSString *)response {
    [_inputTranslator handleConnectionResponse:response];
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {  
    [_messageClient handleSageConfiguration:configuration];
    [_ftpClient handleSageConfiguration:configuration];
    [_outputTranslator handleSageConfiguration:configuration];
}

- (void)handleOutputReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size {
    [_messageClient sendOutputString:output withSize:size];
}

- (void)handleFtpReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size {
    [_ftpClient sendOutputString:output withSize:size];
}

- (void)dealloc {
    [_messageClient release];
    [_ftpClient release];
    [_inputTranslator release];
    [_outputTranslator release];
    
    [super dealloc];
}

@end
