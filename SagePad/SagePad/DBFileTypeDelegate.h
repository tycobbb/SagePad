//
//  DBFileTypeDelegate.h
//  SagePad
//
//  Created by Matthew Cobb on 2/21/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DBFileTypeDelegate <NSObject>

@required
- (void)handleDirectoryReady;
- (void)handleDirectoryLoadFailure:(NSError *)error;

@optional
- (void)handleFileLoaded:(NSString *)path;
- (void)handleFileLoadFailure:(NSError *)error;

@end
