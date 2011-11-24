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

@implementation NetworkingService

- (id)initWithIp:(NSString *)_ip withPortNumber:(NSInteger *)_portNumber 
        withInputTranslator:(id<AbstractInputTranslator> *)_inputTranslator
        withOutputTranslator:(id<AbstractOutputTranslator> *)_outputTranslator {
    
    self = [super init];
    if (self) {
        server = (id<AbstractServer> *)[[Server alloc] initWithIp:_ip andPortNumber:_portNumber]; // this seems like a hack
        inputTranslator = _inputTranslator;                                                       // do we really have to cast
        outputTranslator = _outputTranslator;                                                     // this id to the correct type
    }
    
    return self;
}

- (void)startServer {
    [server startWithInputTranslator:inputTranslator andOutputTranslator:outputTranslator]; // kind of confused by these warnings
}                                                                                           // i think we're missing something about
                                                                                            // protocol polymorphism in obj-c
- (void)stopServer {                                                                        // i think the problem lies in the pointers
    [server stop];                                                                          // to ids will figure out later
}

@end
