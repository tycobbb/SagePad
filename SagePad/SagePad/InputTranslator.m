//
//  InputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "InputTranslator.h"
#import "Client.h"
#import "SagePadConstants.h"

@implementation InputTranslator

@synthesize delegate = _delegate;
@synthesize sageConfiguration = _sageConfiguration;

- (id)init
{    
    self = [super init];
    if (self) {
        self.sageConfiguration = [[SageConfiguration alloc] init];
    }
    
    return self;
}

// translates pointer configuration data from the SAGE server afer connecting
- (void)handleConnectionResponse:(NSString *)response {
    NSInteger ackFromWall, pointerId, sageWidth, sageHeight, ftpPort;
    NSScanner *scanner = [NSScanner scannerWithString:response];
    
    [scanner scanInt:&ackFromWall];
    [scanner scanInt:&pointerId];
    [scanner scanInt:&sageWidth];
    [scanner scanInt:&sageHeight];
    [scanner scanInt:&ftpPort];
    
    _sageConfiguration.pointerId = pointerId;
    _sageConfiguration.width = sageWidth;
    _sageConfiguration.height = sageHeight;
    _sageConfiguration.ftpPort = ftpPort;
    
    [_delegate handleSageConfiguration:_sageConfiguration];
}

- (void) dealloc {
    [_sageConfiguration release];
    [super dealloc];
}

@end
