//
//  DBFileType.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBFileType.h"

@implementation DBFileType

@synthesize metadata = _metadata;
@synthesize parent = _parent;
@synthesize name = _name;

// --- "private" helper methods ---

- (NSString *)sanitize:(NSString *)path {
    return [[path componentsSeparatedByString:@"/"] lastObject];
}

// --- "public" methods ---
- (id)init {
    self = [super init];
    if(self) {
        dropboxManager = [[DBManager alloc] init];
        dropboxManager.delegate = self;
    }
    
    return self;
}

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBFileType *)parent {
    self = [super init];
    if(self) {
        dropboxManager = [[DBManager alloc] init];
        dropboxManager.delegate = self;
        
        self.metadata = metadata;
        self.name = [self sanitize:metadata.path];
        self.parent = parent;        
    }
    
    return self;
}

- (void)setMetadataAndNameWith:(DBMetadata *)metadata {
    self.metadata = metadata;
    self.name = [self sanitize:metadata.path];
}

- (NSString *)path {
    return self.metadata.path;
}

- (void)dealloc {
    [_metadata release];
    [_parent release];
    [_name release];
    
    [super dealloc];
}

@end
