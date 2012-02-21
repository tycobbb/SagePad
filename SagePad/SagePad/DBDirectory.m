//
//  DBDirectory.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBDirectory.h"
#import "SagePadConstants.h"
#import "DBBasicFile.h"

@implementation DBDirectory

@synthesize delegate = _delegate;
@synthesize children = _children;
@synthesize files = _files;

- (void)initContents {
    self.children = [[NSMutableArray alloc] init];
    self.files = [[NSMutableArray alloc] init];
    
    NSLog(@"dir: '%@' contains:", self.name);
    for(DBMetadata *data in self.metadata.contents) {
        if(data.isDirectory) {
            [self.children addObject:[[DBDirectory alloc] initWithMetadata:data andParent:self]];
        } else {
            [self.files addObject:[[DBBasicFile alloc] initWithMetadata:data andParent:self]];
            NSLog(@"\t%@", [[_files lastObject] name]);
        }
    }
}

- (id)initAsRoot {
    self = [super init];
    if(self) {
        isPopulated = NO;
        [dropboxManager requestFileList:DROPBOX_ROOT_DIR];
    }
    
    return self;
}

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBFileType *)parent {
    self = [super initWithMetadata:metadata andParent:parent];
    if(self) {
        isPopulated = NO;
    }
    
    return self;
}

- (void)populate {
    if(!isPopulated) [dropboxManager requestFileList:self.metadata.path];
    else [_delegate handleDirectoryReady];
}

- (void)handleMetadataLoaded:(DBMetadata *)metadata {
    [super setMetadataAndNameWith:metadata];
    [self initContents];
    isPopulated = YES;
    [_delegate handleDirectoryReady];
}

- (void)handleMetadataLoadFailure:(NSError *)error {
    NSLog(@"error in dir");
    [_delegate handleDirectoryLoadFailure:error];
}

- (void)dealloc {
    [_children release];
    [_files release];
    
    [super dealloc];
}

@end
