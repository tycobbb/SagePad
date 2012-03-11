//
//  AbstractInputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingDelegate.h"

@protocol AbstractInputTranslator <NSObject>

@property (nonatomic, assign) id<NetworkingDelegate> delegate;
@property (nonatomic, retain) SageConfiguration *sageConfiguration;

@required
- (void)handleConnectionResponse:(NSString *)response;

@end
