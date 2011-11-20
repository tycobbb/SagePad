//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"

@implementation InputTranslator

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)stream:(NSStream *)inputStream handleEvent:(NSStreamEvent)streamEvent {
    
}

- (void)translateConnectionConfirmation {
    // parse out x, y, id
}

@end
