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
        notificationName = @"SPSageConfiguration";
        
    }
    
    return self;
}

- (void)stream:(NSStream *)inputStream handleEvent:(NSStreamEvent)streamEvent {
    
}

- (void)translateConnectionConfirmation: (NSString *) sageConfiguration {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end
