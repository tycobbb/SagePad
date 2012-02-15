//
//  DBFileType.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBFileType.h"

@implementation DBFileType

@synthesize name = _name;

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    
    return self;
}

- (void)dealloc {
    [_name release];
    
    [super dealloc];
}

@end
