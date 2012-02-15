//
//  DBFileType.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBFileType : NSObject

@property (nonatomic, retain) NSString *name;

- (id)initWithName:(NSString *)string;

@end
