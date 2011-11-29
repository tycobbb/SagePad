//
//  NetworkingService.h
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractServer.h"
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

@interface NetworkingService : NSObject {
    id<AbstractInputTranslator> inputTranslator;
    id<AbstractOutputTranslator> outputTranslator;
    id<AbstractServer> server;
}

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
                    andServer:(id<AbstractServer>)_server;

- (void)startServer;
- (void)stopServer;
- (void)setServerBufferSize:(NSInteger)bufferSize;

- (void)handleMove:(CGPoint *)touchCoordinates isFirst:(BOOL)isFirst;
- (void)handlePinch:(CGFloat *)scale;
- (void)handlePress:(CGPoint *)touchCoordinates;
- (void)handleDrag:(CGPoint *)touchCoordinates;

@end
