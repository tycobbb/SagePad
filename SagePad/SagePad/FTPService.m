//
//  FTPService.m
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "FTPService.h"

@implementation FTPService

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)_inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)_outputTranslator
                    andClient:(id<AbstractClient>)_client {
    
    self = [super initWithInputTranslator:_inputTranslator
                      andOutputTranslator:_outputTranslator
                                andClient:_client];
    if (self) { }
    return self;
}



@end
