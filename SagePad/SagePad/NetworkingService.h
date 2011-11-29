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
    id<AbstractServer> server;
    id<AbstractInputTranslator> inputTranslator;
    id<AbstractOutputTranslator> outputTranslator;
}

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
         withOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator;

- (void)startServer;
- (void)stopServer;

- (void)translateTouchEvent:(CGPoint *)touchCoordinates isFirst:(BOOL)first;

- (void)translatePinchEvent:(CGFloat *)scalef isFirst:(BOOL)first;

@end
