//
//  AbstractClient.h
//  SagePad
//
//  Created by Jakub Misterka on 11/22/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingDelegate.h"
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

@protocol AbstractClient <NSObject>

@property (nonatomic, assign) id<NetworkingDelegate> delegate;
@property (nonatomic, retain) SageConfiguration *sageConfiguration;

@required
- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger)_portNumber;
- (void)sendOutput:(NSString *)string;
- (void)handleSageConfiguration:(SageConfiguration *)configuration;

- (void)start;
- (void)stop;
    
@optional
- (NSString *)getIpAddress;
- (void)setBufferSize:(NSInteger)_bufferSize;

@end
