//
//  NetworkingService.h
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingDelegate.h"
#import "AbstractClient.h"
#import "AbstractFtpClient.h"
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

@interface NetworkingService : NSObject <NetworkingDelegate>

- (id)initWithInputTranslator:(id<AbstractInputTranslator>)inputTranslator 
          andOutputTranslator:(id<AbstractOutputTranslator>)outputTranslator
                    andClient:(id<AbstractClient>)client
                 andFtpClient:(id<AbstractClient>)ftpClient;

// client methods
- (void)startClient;
- (void)stopClient;
- (void)setServerBufferSize:(NSInteger)bufferSize;

// output translator methods
//      for pointer
- (void)handleMove:(CGPoint *)touchCoordinates isFirst:(BOOL)isFirst;
- (void)handlePinch:(CGFloat *)scale;
- (void)handlePress:(CGPoint *)touchCoordinates;
- (void)handleDrag:(CGPoint *)touchCoordinates;
- (void)handleRelease:(CGPoint *)touchCoodinates;
- (void)handleClick:(CGPoint *)touchCoordinates;

//      for ftp
- (void)pushFile:(NSString *)path;

@end
