//
//  DropboxManagerDelegate.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DropboxManagerDelegate <NSObject>
    
@required
- (void)handleDirectoryMetadata:(DBMetadata *)metadata;

@end
