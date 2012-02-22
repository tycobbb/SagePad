//
//  NetworkingService.h
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractClient.h"
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

@interface NetworkingService : NSObject {
    id<AbstractInputTranslator> inputTranslator;
    id<AbstractOutputTranslator> outputTranslator;
    id<AbstractClient> client;
}

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
                    andClient:(id<AbstractClient>)_client;

- (void)startClient;
- (void)stopClient;
- (void)setServerBufferSize:(NSInteger)bufferSize;

@end
