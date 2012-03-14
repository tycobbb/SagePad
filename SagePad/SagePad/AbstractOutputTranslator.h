//
//  AbstractOutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingDelegate.h"
#import "SagePadConstants.h"

@protocol AbstractOutputTranslator <NSObject>

@property (nonatomic, assign) id<NetworkingDelegate> delegate;
@property (nonatomic, retain) SageConfiguration *sageConfiguration;

@required
- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight;
- (void)notifyOutputReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size;
- (void)notifyFtpReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size;
- (void)handleSageConfiguration:(SageConfiguration *)configuration;

@optional
- (void)sharePointer;
- (void)unsharePointer;
- (void)translateMove:(CGPoint *)newTouch isFirst:(BOOL)isFirst;
- (void)translatePinch:(CGFloat *)scale;
- (void)translatePress:(CGPoint *)newTouch;
- (void)translateDrag:(CGPoint *)newTouch;
- (void)translateRelease:(CGPoint *)newTouch;
- (void)translateClick:(CGPoint *)newTouch;

@optional
- (void)sendFileHeader:(NSString *)path;

@end
