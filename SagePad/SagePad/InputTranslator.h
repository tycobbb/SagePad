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
    int bufferSize;
    NSString *pointerConfigurationNotification;
}

- (void)handleBytesAvailableEvent:(NSInputStream *)inputStream;
- (void)translatePointerConfiguration:(NSString *)pointerConfiguration;

@end


