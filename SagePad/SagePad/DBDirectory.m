//
//  DBDirectory.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBDirectory.h"

@implementation DBDirectory

@synthesize parent = _parent;
@synthesize children = _children;
@synthesize files = _files;

- (id)initWithName:(NSString *)name andParent:(DBDirectory *)parent {
    self = [super initWithName:name];
    if (self) {
        self.parent = parent;
        self.children = [[NSMutableArray alloc] init];
        self.files = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_parent release];
    [_children release];
    [_files release];
    
    [super dealloc];
}

@end
