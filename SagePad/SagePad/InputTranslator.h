//
//  InputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractInputTranslator.h"

@interface InputTranslator : NSObject <AbstractInputTranslator> {
    NSInteger bufferSize;
    NSString *pointerConfigurationNotification;
    BOOL config;
}

- (void)handleBytesAvailableEvent:(NSInputStream *)inputStream;
- (void)translatePointerConfiguration:(NSString *)pointerConfiguration;

@end


