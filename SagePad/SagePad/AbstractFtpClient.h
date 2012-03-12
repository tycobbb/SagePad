//
//  AbstractFtpClient.h
//  SagePad
//
//  Created by Matthew Cobb on 3/12/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractFtpClient <AbstractClient>

- (void)sendFile:(NSString *)path;

@end
