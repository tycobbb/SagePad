//
//  DBFileType.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBManagerDelegate.h"
#import "DBManager.h"
#import "DBFileTypeDelegate.h"

@interface DBFileType : NSObject <DBManagerDelegate> {
    DBManager *dropboxManager;
}

@property (nonatomic, assign) id<DBFileTypeDelegate> delegate;
@property (nonatomic, retain) DBMetadata *metadata;
@property (nonatomic, retain) DBFileType *parent;
@property (nonatomic, retain) NSString *name;

- (id)initWithMetadata:(DBMetadata *)metadata andParent:(DBFileType *)parent;

- (void)setMetadataAndNameWith:(DBMetadata *)metadata;
- (NSString *)path;

@end