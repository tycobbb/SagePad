//
//  DBBasicFile.h
//  SagePad
//
//  Created by Matthew Cobb on 2/20/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "DBFileType.h"

@interface DBBasicFile : DBFileType

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBFileType *)parent; 

- (void)download;

@end
