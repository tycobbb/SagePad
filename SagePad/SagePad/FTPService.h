//
//  FTPService.h
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingService.h"

@interface FTPService : NetworkingService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
                    andClient:(id<AbstractClient>)_client;

@end
