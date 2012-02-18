//
//  DropboxManager.h
//  SagePad
//
//  Created by Matthew Cobb on 1/25/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBManagerDelegate.h"
#import "DBBasicFile.h"

@interface DBManager : NSObject <DBRestClientDelegate> {
    DBRestClient *restClient;
}

@property (nonatomic, assign) id<DBManagerDelegate> delegate;

+ (void)createSession;

- (void)requestFileList;
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata;
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error;

- (void)uploadFile:(NSString *)filename;
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString*)destPath 
              from:(NSString *)srcPath 
          metadata:(DBMetadata *)metadata;
- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError*)error;

- (void)downloadFile:(DBBasicFile *)file;
- (void)restClient:(DBRestClient *)client loadedFile:(NSString*)localPath;
- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError*)error;
@end
