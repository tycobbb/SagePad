//
//  DBDirectory.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBDirectory.h"

@implementation DBDirectory

@synthesize contents = _contents;

- (id)initWithName:(NSString *)string {
    self = [super initWithName:string];
    if (self) {
        _contents = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_contents release];
    
    [super dealloc];
}

@end
