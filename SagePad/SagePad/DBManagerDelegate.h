//
//  DropboxManagerDelegate.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DBManagerDelegate <NSObject>

@optional
- (void)handleMetadataLoaded:(DBMetadata *)metadata;
- (void)handleMetadataLoadFailure:(NSError *)error;
- (void)handleFileLoaded:(NSString*)localPath;
- (void)handleFileLoadFailure:(NSError*)error;

@end
