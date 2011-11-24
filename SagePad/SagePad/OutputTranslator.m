//
//  OutputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "OutputTranslator.h"

@implementation OutputTranslator

- (id)init
{
    self = [super init];
    if (self) {
        pointerConfigurationNotification = @"SPSageConfiguration"; // move this into some constant storage
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handlePointerConfiguration) 
                                                     name:@"SPSageConfiguration" 
                                                   object:nil];
    }
    
    return self;
}

- (void)stream:(NSStream *)outputStream handleEvent:(NSStreamEvent)streamEvent {
    // handle events
}

- (void)handlePointerConfiguration:(NSNotification *) notification {
    NSLog(@"Received notification in output translator: %@", [notification name]);
    // need to figure out how to get the acutal string, not just notification name
}

@end
