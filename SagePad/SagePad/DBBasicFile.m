//
//  DBFileType.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBBasicFile.h"

@implementation DBBasicFile

@synthesize metadata = _metadata;
@synthesize parent = _parent;
@synthesize name = _name;

// --- "private" helper methods ---

- (NSString *)sanitize:(NSString *)name {
    return [name substringFromIndex:1];
}

// --- "public" methods ---

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBBasicFile *)parent {
    self = [super init];
    if (self) {
        self.metadata = metadata;
        self.parent = parent;
        self.name = [self sanitize:metadata.path];
    }
    
    return self;
}

- (void)dealloc {
    [_metadata release];
    [_parent release];
    [_name release];
    
    [super dealloc];
}

@end
