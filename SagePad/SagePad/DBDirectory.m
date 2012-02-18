//
//  DBDirectory.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBDirectory.h"

@implementation DBDirectory

@synthesize children = _children;
@synthesize files = _files;

- (void)initContents {
    self.children = [[NSMutableArray alloc] init];
    self.files = [[NSMutableArray alloc] init];
    
    NSLog(@"dir: '%@' contains:", self.name);
    for(DBMetadata *data in self.metadata.contents) {
        if(data.isDirectory) {
            [self.children addObject:[[DBDirectory alloc] initWithMetadata:(DBMetadata *)data andParent:self]];
        } else {
            [self.files addObject:[[DBBasicFile alloc] initWithMetadata:data andParent:self]];
            NSLog(@"\t%@", [[_files lastObject] name]);
        }
    }
}

- (id)initWithMetadata:(DBMetadata *)metadata {
    self = [super initWithMetadata:metadata andParent:nil];
    if(self) {
        [self initContents];
    }
    
    return self;
}

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBBasicFile *)parent {
    self = [super initWithMetadata:metadata andParent:parent];
    if(self) {
        [self initContents];
    }
    
    return self;
}

- (void)dealloc {
    [_children release];
    [_files release];
    
    [super dealloc];
}

@end
