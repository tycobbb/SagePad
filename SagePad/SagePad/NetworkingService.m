//
//  NetworkingService.m
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "NetworkingService.h"
#import "Server.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"
#import "SagePadSettings.h"

@implementation NetworkingService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator
         withOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator {
    
    self = [super init];
    if (self) {
        SagePadSettings *sagePadSettings = [[SagePadSettings alloc] init];
        server = [[Server alloc] initWithIp:sagePadSettings.ipAddress
                              andPortNumber:[sagePadSettings.portNumber integerValue]];
        [sagePadSettings release];
        
        inputTranslator = _inputTranslator;
        outputTranslator = _outputTranslator;
        
    }
    
    return self;
}

- (void)dealloc {
    [server release];    
    [super dealloc];
}

- (void)startServer {
    NSLog(@"StartingServer");
    [server start]; 
}

- (void)stopServer {
    [server stop];
}

- (void)translateTouchEvent:(CGPoint *)coordinates {
    [outputTranslator translateTouchEvent:coordinates];
}

@end
