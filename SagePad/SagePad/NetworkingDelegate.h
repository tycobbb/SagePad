//
//  NetworkingDelegate.h
//  SagePad
//
//  Created by Matthew Cobb on 3/6/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SageConfiguration.h"

@protocol NetworkingDelegate <NSObject>

@required
- (void)handleConnectionResponse:(NSString *)response;
- (void)handleSageConfiguration:(SageConfiguration *)configuration;
- (void)handleOutputReady:(NSString *)output;

@end
