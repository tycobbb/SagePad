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
        notificationName = @"SPSageConfiguration";
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                selector:@selector(handleSageConfiguration) 
                                                name:@"SPSageConfiguration" 
                                                object:nil];
    }
    
    return self;
}

- (void)stream:(NSStream *)outputStream handleEvent:(NSStreamEvent)streamEvent {
    // handle events
}

- (void)handleSageConfiguration:(NSNotification *) notification {
    if([[notification name] isEqualToString:notificationName])
        NSLog(@"Successfully received notification");
}

@end
