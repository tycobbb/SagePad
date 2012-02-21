//
//  DBDirectoryDelegate.h
//  SagePad
//
//  Created by Matthew Cobb on 2/20/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DBDirectoryDelegate <NSObject>

@required
- (void)handleDirectoryReady;
- (void)handleDirectoryLoadFailure:(NSError *)error;

@end
