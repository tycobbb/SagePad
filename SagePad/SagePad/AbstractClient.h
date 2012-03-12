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
#import "SagePadConstants.h"

@protocol AbstractClient <NSObject>

@property (nonatomic, assign) id<NetworkingDelegate> delegate;
@property (nonatomic, retain) SageConfiguration *sageConfiguration;

@required
- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger)_portNumber;
- (void)handleSageConfiguration:(SageConfiguration *)configuration;

- (void)start;
- (void)stop;

- (void)sendOutputString:(NSString *)string withSize:(SAGE_MSG_SIZE)size;
- (void)setBufferSize:(NSInteger)_bufferSize;

@end
