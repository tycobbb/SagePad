//
//  DBFileType.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DBBasicFile : NSObject

@property (nonatomic, retain) DBMetadata *metadata;
@property (nonatomic, retain) DBBasicFile *parent;
@property (nonatomic, retain) NSString *name;

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBBasicFile *)parent;

@end
