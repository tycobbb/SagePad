//
//  OutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractOutputTranslator.h"
#import "SagePadSettings.h"

@interface OutputTranslator : NSObject <AbstractOutputTranslator> {
    NSUInteger pointerId;
    NSUInteger sageWidth;
    NSUInteger sageHeight;
    NSUInteger ftpPortNumber;
    SagePadSettings *settings;

    CGPoint previousTouch; // coordinates of the previous pointer location read
    CGPoint sageLocation;
    CGFloat firstPinch;
    CGFloat xAtom;
    CGFloat yAtom;

    BOOL pointerAlreadyShared;
}

@property (readonly, nonatomic) NSString *formattedOutput;

- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight;
- (void)handlePointerConfiguration:(NSNotification *)notification;

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2;

- (void)formatOutputAndNotifyServer:(NSInteger)outputType withParam1:(NSString *)param1 
                          andParam2:(NSString *)param2 
                          andParam3:(NSString *)param3;

@end
