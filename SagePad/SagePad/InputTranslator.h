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
    NSString *pointerConfigurationNotification;
}

@property(readonly, nonatomic) NSInteger pointerId;
@property(readonly, nonatomic) NSInteger sageWidth;
@property(readonly, nonatomic) NSInteger sageHeight;
@property(readonly, nonatomic) NSInteger ftpPortNumber;

- (void)translatePointerConfiguration:(NSString *)pointerConfiguration;
- (void)recieveConfigurationString:(NSNotification *)notification; 

@end


