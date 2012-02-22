//
//  PointerService.h
//  SagePad
//
//  Created by Matthew Cobb on 11/23/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingService.h"

//#import "AbstractClient.h"
//#import "AbstractInputTranslator.h"
//#import "AbstractOutputTranslator.h"
//
//@interface PointerService : NSObject {
//    id<AbstractInputTranslator> inputTranslator;
//    id<AbstractOutputTranslator> outputTranslator;
//    id<AbstractClient> client;
//}
//
//- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
//          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
//                    andClient:(id<AbstractClient>)_client;
//
//- (void)startClient;
//- (void)stopClient;
//- (void)setServerBufferSize:(NSInteger)bufferSize;

@interface PointerService : NetworkingService 

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
                    andClient:(id<AbstractClient>)_client;

- (void)handleMove:(CGPoint *)touchCoordinates isFirst:(BOOL)isFirst;
- (void)handlePinch:(CGFloat *)scale;
- (void)handlePress:(CGPoint *)touchCoordinates;
- (void)handleDrag:(CGPoint *)touchCoordinates;
- (void)handleRelease:(CGPoint *)touchCoodinates;
- (void)handleClick:(CGPoint *)touchCoordinates;

@end
