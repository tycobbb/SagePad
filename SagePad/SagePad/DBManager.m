//
//  DropboxManager.m
//  SagePad
//
//  Created by Matthew Cobb on 1/25/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBManager.h"
#import "SagePadConstants.h"

@implementation DBManager

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return self;
}

// create dropbox session
+ (void)createSession {
    NSString *dropboxRootFolder = kDBRootAppFolder;
    DBSession* dbSession = [[[DBSession alloc] initWithAppKey:DROPBOX_KEY
                                                    appSecret:DROPBOX_SECRET
                                                         root:dropboxRootFolder] autorelease];
    [DBSession setSharedSession:dbSession];
}

- (void)requestFileList:(NSString *)path {
    [restClient loadMetadata:path];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if(metadata.isDirectory) {
        [delegate handleMetadataLoaded:metadata];
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    [delegate handleMetadataLoadFailure:error];
}

- (void)uploadFile:(NSString *)filename {
    NSArray *fileChunks = [filename componentsSeparatedByString:@"."]; 
    NSString *localPath = [[NSBundle mainBundle] pathForResource:[fileChunks objectAtIndex:0] 
                                                          ofType:[fileChunks objectAtIndex:1]];
    [restClient uploadFile:filename toPath:DROPBOX_ROOT_DIR withParentRev:nil fromPath:localPath];
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}

- (void)downloadFile:(NSString *)file {
    [restClient loadFile:@"" intoPath:@""];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString*)localPath {
    [delegate handleFileLoaded:@""];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError*)error {
    [delegate handleFileLoadFailure:error];
}

@end
